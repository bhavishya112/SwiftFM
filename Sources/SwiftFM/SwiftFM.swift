import Foundation
import FoundationModels

/// `SwiftFM` is a simple façade over Apple's Foundation Models framework.
/// It supports plain text generation and strongly-typed guided generation.
public actor SwiftFM {
    private let session: LanguageModelSession
    private let config: Config

    /// Configuration options applied per call.
    public struct Config {
        public var system: String?
        public var temperature: Double
        public var maximumResponseTokens: Int?

        public init(system: String? = nil,
                    temperature: Double = 0.6,
                    maximumResponseTokens: Int? = nil) {
            self.system = system
            self.temperature = temperature
            self.maximumResponseTokens = maximumResponseTokens
        }
    }

    /// Create a new SwiftFM client with an optional system prompt and generation settings.
    public init(config: Config = .init()) {
        self.config = config
        if let system = config.system {
            self.session = LanguageModelSession(instructions: system)
        } else {
            self.session = LanguageModelSession()
        }
    }

    /// Generate a plain text response.
    /// - Parameter prompt: The instruction or question.
    /// - Returns: Model-generated text.
    public func generateText(for prompt: String) async throws -> String {
        var opts = GenerationOptions()
        opts.temperature = config.temperature
        if let max = config.maximumResponseTokens {
            opts.maximumResponseTokens = max
        }
        let r = try await session.respond(to: prompt, options: opts)
        return r.content
    }

    /// Generate a strongly-typed result using guided generation.
    /// - Parameters:
    ///   - prompt: The instruction describing the desired object.
    ///   - type: A `Decodable & Sendable & Generable` type.
    /// - Returns: A fully typed instance produced by the model.
    public func generateJSON<T: Decodable & Sendable & Generable>(
        for prompt: String,
        as type: T.Type
    ) async throws -> T {
        var opts = GenerationOptions()
        opts.temperature = config.temperature
        if let max = config.maximumResponseTokens {
            opts.maximumResponseTokens = max
        }
        let r = try await session.respond(to: prompt, generating: T.self, options: opts)
        return r.content
    }

    /// Indicates whether the model is currently responding.
    public var isBusy: Bool { session.isResponding }

    /// True if the on-device model is available on this device.
    public static var isModelAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }

    /// Detailed availability state (e.g. not supported, not enabled, not ready).
    public static var modelAvailability: SystemLanguageModel.Availability {
        SystemLanguageModel.default.availability
    }
}
