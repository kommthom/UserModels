import Vapor

extension Request {
	public var random: RandomGenerator {
        self.application.random
    }
}
