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
let response = try await fm.generateText(for: "Explain a century break in snooker in one sentence.")
print(response)
// "A century break is when a player scores 100 points or more in a single visit."
```

### 2. Strongly-Typed Guided Generation

To use guided generation, your type must conform to Decodable & Sendable & Generable.

```swift
import SwiftFM
import FoundationModels

struct Tip: Decodable, Sendable, Generable {
    let player: String
    let confidence: Double
}

let fm = SwiftFM()
let tip: Tip = try await fm.generateJSON(
    for: "Pick a likely winner and provide {player, confidence}.",
    as: Tip.self
)

print(tip.player, tip.confidence)
// "Ronnie O'Sullivan 0.87"
```

### Check availability at runtime:
```swift
if SwiftFM.isModelAvailable {
    print("Foundation Model ready to use.")
} else {
    print("Not available:", SwiftFM.modelAvailability)
}
```

### Availability

SwiftFM requires the Apple Intelligence Foundation Models, which are only available on:
	•	iOS 26 or later
	•	iPadOS 26 or later
	•	macOS 15 or later

Note: Foundation Models are not currently supported on watchOS or tvOS. If you add SwiftFM to those platforms, it will not compile.

### License

SwiftFM is released under the MIT License.

This means:
	•	You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of this software.
	•	The only requirements are that you include the original license and copyright notice in copies or substantial portions of the software.
	•	The software is provided “as is”, without warranty of any kind.








