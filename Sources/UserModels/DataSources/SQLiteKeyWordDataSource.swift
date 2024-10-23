//
//  SQLiteKeyWordsDataSource.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 15.10.24.
//

import Vapor
import UserDTOs
import Lingo

/// Class providing file backed data source for Lingo in case localizations are stored in SQLite database.
public final class SQLiteKeyWordsDataSource: ExtensibleLocalizationDataSourceProtocol, @unchecked Sendable {
	private var repository: LocalizationRepositoryProtocol
	
	public init(repository: LocalizationRepositoryProtocol) {
		self.repository = repository
	}
	
	public func availableLocales() async throws -> [String] {
		try await repository
			.allLocales()
	}
	
	public func localizations(forLocale locale: String) async throws -> [Localizations.Key: Localization] {
		try await repository
			.all(locale: locale) //Future<[LocalizationModel]>
			.map { localizations in
				return localizations
					.map { localization in
						if let stringValue = localization.value {
							return (localization.key, Localization.universal(value: stringValue))
						} else {
							return (localization.key, Localization.pluralized(values: self.pluralizedValues(fromRaw: localization.pluralized ?? [:])))
						}
					}
			}
			.map { localizationPairs in
				return Dictionary(localizationPairs, uniquingKeysWith: { (key, _) in key })
			}
	}
	
	public func localizations(forLocale locale: KeyWords.LocaleIdentifier) async throws -> [KeyWords.LocalizationKey: CompositeString] {
		try await self.repository
			.allKeyWords() //Future<[LocalizationModel]>
			.map { localizations in
				return localizations
					.compactMap { localization in
						if let stringValue = localization.value {
							return (KeyWord(rawValue: localization.enumKey!)!, CompositeString(rawValue: stringValue)!)
						}
						return nil
					}
			}
			.map { localizationPairs in
				return Dictionary(localizationPairs, uniquingKeysWith: { (key, _) in key })
			}
	}
	
	public func appendLocalization(forLocale locale: String, localizationKey: Localizations.Key, value: Localizations.Value) async throws -> Void {
		try await self.repository
			.find(userName: locale, locale: locale, key: localizationKey)
			.flatMap { localization in
				switch value {
				case Localization.universal(value: let localizationValue):
					if let _ = localization {
						return self.repository
							.set(\.$value, to: localizationValue, for: localization!.id!)
					}
					return self.repository
						.create(LocalizationModel(id: UUID(), languageModel: .localizations, languageCode: locale, enumKey: nil, key: localizationKey, value: localizationValue))
				case .pluralized(values: let pluralizedValues):
					let pluralizedDict = Dictionary(pluralizedValues
						.map { (pluralizedCategory, stringValue) in
							return (pluralizedCategory.rawValue, stringValue)
								},
						uniquingKeysWith: { (key, _) in key })
					if let localizationNotNil = localization {
						return self.repository
							.set(LocalizationModel(id: localizationNotNil.id!, languageModel: localizationNotNil.languageModel, languageCode: localizationNotNil.languageCode, enumKey: nil, key: localizationNotNil.key, value: nil, pluralized: pluralizedDict))
					}
					return self.repository
						.create(LocalizationModel(id: UUID(), languageModel: .localizations, languageCode: locale, enumKey: nil, key: localizationKey, value: nil, pluralized: pluralizedDict))
				}
			}
	}
}

private extension SQLiteLocalizationDataSource {
	/// Parses a dictionary which has string plural categories as keys ([String: String]) and returns a typed dictionary ([PluralCategory: String])
	/// An example dictionary looks like:
	/// {
	///   "one": "You have an unread message."
	///   "many": "You have %{count} unread messages."
	/// }
	func pluralizedValues(fromRaw rawPluralizedValues: [String: String]) -> [PluralCategory: String] {
		var result = [PluralCategory: String]()
		
		for (rawPluralCategory, value) in rawPluralizedValues {
			if let pluralCategory = PluralCategory(rawValue: rawPluralCategory) {
				result[pluralCategory] = value
			} else { print("Unsupported plural category: \(rawPluralCategory)") }
		}
		return result
	}
}

