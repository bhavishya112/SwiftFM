import Testing
import FoundationModels
@testable import SwiftFM

struct SwiftFMSnookerTests {
    
    @Test("Text: define a century break")
    func textCentury() async throws {
        guard SwiftFM.isModelAvailable else { return }
        let fm = SwiftFM()
        let s = try await fm.generateText(for: "Define a snooker century break in one sentence.")
        #expect(!s.isEmpty)
    }
    
    @Test("Stream: break-building basics")
    func streamBasics() async throws {
        guard SwiftFM.isModelAvailable else { return }
        let fm = SwiftFM()
        var out = ""
        for try await chunk in await fm.streamText(for: "Explain snooker break-building basics in 3–4 sentences.") {
            out += chunk
        }
        #expect(!out.isEmpty)
    }
    
    @Generable
    struct PracticeDrill: Decodable, Sendable {
        @Guide(description: "Name of the drill")
        let title: String
        @Guide(description: "Steps a player should follow")
        let steps: String
    }
    
    @Test("Guided: practice drill JSON")
    func guidedDrill() async throws {
        guard SwiftFM.isModelAvailable else { return }
        let fm = SwiftFM()
        let drill: PracticeDrill = try await fm.generateJSON(
            for: "Return JSON {title,steps} for a snooker practice drill focused on cue ball control.",
            as: PracticeDrill.self
        )
        #expect(!drill.title.isEmpty)
        #expect(!drill.steps.isEmpty)
    }
    
    @Generable
    struct MatchPrediction: Decodable, Sendable {
        @Guide(description: "First player")
        let player: String
        @Guide(description: "Opponent")
        let opponent: String
        @Guide(description: "Predicted winner")
        let predictedWinner: String
        @Guide(description: "Confidence 0.0–1.0")
        let confidence: Double
    }
    
    @Test("Guided: match prediction JSON")
    func guidedPrediction() async throws {
        guard SwiftFM.isModelAvailable else { return }
        let fm = SwiftFM()
        let p: MatchPrediction = try await fm.generateJSON(
            for: "Predict a snooker match between two well-known professionals. Return JSON {player,opponent,predictedWinner,confidence}.",
            as: MatchPrediction.self
        )
        #expect(!p.player.isEmpty)
        #expect(!p.opponent.isEmpty)
        #expect(!p.predictedWinner.isEmpty)
        #expect(0.0 ... 1.0 ~= p.confidence)
    }
    
    @Test("Config: system prompt influences tone")
    func systemPrompt() async throws {
        guard SwiftFM.isModelAvailable else { return }
        let fm = SwiftFM(config: .init(system: "You are a snooker commentator; be concise and technical."))
        let s = try await fm.generateText(for: "Describe a safety battle in one sentence.")
        #expect(!s.isEmpty)
    }
}
