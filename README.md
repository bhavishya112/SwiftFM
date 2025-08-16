# SwiftFM

> **Super-simple API for Apple Foundation Models in Swift (iOS 26+, macOS 15+).**  
> A lightweight façade designed for beginners: generate text or strongly-typed results in one line.

---

## Features

- ✅ **Plain text generation** — pass a prompt, get back a string.  
- ✅ **Guided typed generation** — decode directly into your own `Decodable & Generable` structs.  
- ✅ **Beginner-friendly API** — minimal surface, sensible defaults.  
- ✅ **On-device** — powered by Apple’s Foundation Models framework, no server required.  
- ✅ **Future-proof** — extend with streaming, tools, and advanced options later.

---

## Availability

SwiftFM requires the Apple Intelligence Foundation Models, which are only available on:

- iOS 26 or later  
- iPadOS 26 or later  
- macOS 26 or later  

---

## Installation

Add **SwiftFM** to your project using Swift Package Manager:

1. In Xcode: **File → Add Packages…**
2. Enter the repository URL:  https://github.com/ricky-stone/SwiftFM
3. Select **main branch** or a tagged version (e.g. `0.1.0`).

---

## Usage

### 1. Plain Text Generation

```swift
import SwiftFM


let fm = SwiftFM()

Task {
    do {
        let response = try await fm.generateText(
            for: "Explain a century break in snooker in one sentence."
        )
        print(response)
        // "A century break is when a player scores 100 points or more in a single visit."
    } catch {
        print("Error:", error)
    }
}
```

### 2. Strongly-Typed Guided Generation

To use guided generation, your type must conform to Decodable & Sendable & Generable.

```swift
@Generable
struct MatchPrediction: Decodable, Sendable {
    @Guide(description: "First player’s name")
    let player: String

    @Guide(description: "Opponent’s name")
    let opponent: String

    @Guide(description: "Who is predicted to win")
    let predictedWinner: String

    @Guide(description: "Confidence 0.0–1.0")
    let confidence: Double
}

let fm = SwiftFM()

Task {
    do {
        let prediction: MatchPrediction = try await fm.generateJSON(
            for: """
            Imagine a snooker match.
            Choose two well-known players and predict the winner.
            Return {player, opponent, predictedWinner, confidence}.
            """,
            as: MatchPrediction.self
        )

        print("Upcoming match: \(prediction.player) vs \(prediction.opponent)")
        print("Predicted winner: \(prediction.predictedWinner) (\(Int(prediction.confidence * 100))%)")
    } catch {
        print("Error:", error)
    }
}
```

### 3. Using a System Prompt

```swift
import SwiftFM

// Configure SwiftFM with a system role
let fm = SwiftFM(config: .init(system: "You are a professional snooker coach."))

Task {
    do {
        let tip = try await fm.generateText(
            for: "Give me a practice drill to improve cue ball control."
        )
        print(tip)
        // e.g. "Set up three reds in a line and practice stopping the cue ball dead after each pot."
    } catch {
        print("Error:", error)
    }
}
```

### Check availability at runtime:
```swift
if SwiftFM.isModelAvailable {
    print("Foundation Model ready to use.")
} else {
    print("Not available:", SwiftFM.modelAvailability)
}
```

### License

SwiftFM is released under the MIT License.

This means:
	•	You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of this software.
	•	The only requirements are that you include the original license and copyright notice in copies or substantial portions of the software.
	•	The software is provided “as is”, without warranty of any kind.








