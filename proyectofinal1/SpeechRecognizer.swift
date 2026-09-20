import Foundation
@preconcurrency import Speech
@preconcurrency import AVFoundation

@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var transcript = ""
    @Published var isListening = false
    @Published var authorizationDenied = false

    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    nonisolated(unsafe) private var sessionID = 0

    func start() {
        guard !isListening else { return }
        transcript = ""
        authorizationDenied = false

        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self else { return }
            Task { @MainActor in
                guard status == .authorized else {
                    self.authorizationDenied = true
                    return
                }
                self.beginSession()
            }
        }
    }

    func stop() {
        guard isListening else { return }
        isListening = false
        teardownAudio()
    }

    func reset() {
        stop()
        transcript = ""
    }

    // MARK: - Privado
    private func beginSession() {
        let isEnglish = (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es") == "en"
        let recognizer: SFSpeechRecognizer? = isEnglish
            ? (SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
                ?? SFSpeechRecognizer(locale: Locale(identifier: "en")))
            : (SFSpeechRecognizer(locale: Locale(identifier: "es-ES"))
                ?? SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
                ?? SFSpeechRecognizer(locale: Locale(identifier: "es")))
        guard let recognizer, recognizer.isAvailable else {
            authorizationDenied = true
            return
        }
        speechRecognizer = recognizer

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.taskHint = .dictation
        self.request = request

        // Configura la sesión de audio y arranca el motor FUERA del hilo principal
        // para evitar el aviso "AVAudioSession Hang Risk".
        sessionID += 1
        let currentSession = sessionID
        let audioEngine = self.audioEngine
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self, self.sessionID == currentSession else { return }

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

                let inputNode = audioEngine.inputNode
                let format = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                    request.append(buffer)
                }
                audioEngine.prepare()
                try audioEngine.start()
            } catch {
                Task { @MainActor in
                    guard self.sessionID == currentSession else { return }
                    self.isListening = false
                }
                return
            }

            let task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                let text = result?.bestTranscription.formattedString
                let isFinal = result?.isFinal ?? false
                Task { @MainActor in
                    guard let self, self.sessionID == currentSession else { return }
                    if let text { self.transcript = text }
                    if isFinal || error != nil {
                        self.isListening = false
                        self.teardownAudio()
                    }
                }
            }
            Task { @MainActor in
                guard self.sessionID == currentSession else { return }
                self.task = task
                self.isListening = true
            }
        }
    }

    private func teardownAudio() {
        sessionID += 1
        let audioEngine = self.audioEngine
        let request = self.request
        let task = self.task
        self.request = nil
        self.task = nil

        if audioEngine.isRunning {
            audioEngine.stop()
        }
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.finish()

        // Desactiva la sesión de audio FUERA del hilo principal (evita "AVAudioSession Hang Risk").
        DispatchQueue.global(qos: .userInitiated).async {
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
    }
}
