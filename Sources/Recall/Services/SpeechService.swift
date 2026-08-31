import AVFoundation
import Foundation

/// Speaks a word's character text aloud using the on-device voice for its language.
/// Fully offline — AVSpeechSynthesizer never touches the network for standard voices.
@Observable
final class SpeechService {
    static let shared = SpeechService()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    func speak(_ text: String, voiceLocale: String) {
        guard let voice = AVSpeechSynthesisVoice(language: voiceLocale) else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.92
        synthesizer.speak(utterance)
    }
}
