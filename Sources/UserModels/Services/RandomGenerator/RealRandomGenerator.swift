import Vapor

extension Application.RandomGenerators.Provider {
    public static var random: Self {
        .init {
            $0.randomGenerators.use { _ in RealRandomGenerator() }
        }
    }
}

public struct RealRandomGenerator: RandomGenerator {
    public func generate(bits: Int) -> String {
        [UInt8].random(count: bits / 8).hex
    }
}
