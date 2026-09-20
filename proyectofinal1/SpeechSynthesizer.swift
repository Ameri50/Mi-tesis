import Foundation
import AVFoundation

@MainActor
final class SpeechSynthesizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false
    @Published var isPaused = false
    @Published var lastSpokenText = ""

    private let synthesizer = AVSpeechSynthesizer()

    /// Voz según el idioma seleccionado en la app (inglés o español).
    private var voice: AVSpeechSynthesisVoice? {
        if (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es") == "en" {
            return AVSpeechSynthesisVoice(language: "en-US")
                ?? AVSpeechSynthesisVoice(language: "en-GB")
        }
        return AVSpeechSynthesisVoice(language: "es-ES")
            ?? AVSpeechSynthesisVoice(language: "es-MX")
    }

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        let clean = Self.cleanTextForSpeech(text)
        guard !clean.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: clean)
        utterance.voice = voice
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        lastSpokenText = text
        isSpeaking = true
        isPaused = false
        synthesizer.speak(utterance)
    }

    /// Encola texto para hablarlo DESPUÉS de lo que ya suena, sin cortarlo.
    func enqueue(_ text: String) {
        let clean = Self.cleanTextForSpeech(text)
        guard !clean.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: clean)
        utterance.voice = voice
        utterance.rate = 0.5
        lastSpokenText = text
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    func pause() {
        guard isSpeaking, !isPaused else { return }
        synthesizer.pauseSpeaking(at: .word)
        isPaused = true
    }

    func resume() {
        guard isSpeaking, isPaused else { return }
        synthesizer.continueSpeaking()
        isPaused = false
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
    }

    static func cleanTextForSpeech(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: #"\*\*(.+?)\*\*"#, with: "$1", options: .regularExpression)
        result = result.replacingOccurrences(of: #"[*_`~]#"#, with: "", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\|"#, with: ", ", options: .regularExpression)
        result = result.replacingOccurrences(of: #"[^\p{L}\p{N}\s.,;:!?¡¿%$()-]"#, with: " ", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\s{2,}"#, with: " ", options: .regularExpression)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - AVSpeechSynthesizerDelegate
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false; self.isPaused = false }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false; self.isPaused = false }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isPaused = true }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isPaused = false }
    }
}
