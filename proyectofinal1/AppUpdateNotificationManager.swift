import Foundation
import UIKit
import UserNotifications

final class AppUpdateNotificationManager: NSObject, ObservableObject {
    static let shared = AppUpdateNotificationManager()

    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private let center = UNUserNotificationCenter.current()
    private let notificationsEnabledKey = "notificationsEnabled"
    private let lastSeenVersionKey = "lastSeenAppVersionIdentifier"

    func configure() {
        center.delegate = self

        Task {
            await refreshNotificationState()
        }
    }

    func enableNotifications() async -> Bool {
        UserDefaults.standard.set(true, forKey: notificationsEnabledKey)
        return await refreshNotificationState()
    }

    func disableNotifications() {
        UserDefaults.standard.set(false, forKey: notificationsEnabledKey)
        UserDefaults.standard.set(currentAppVersionIdentifier(), forKey: lastSeenVersionKey)
        center.removePendingNotificationRequests(withIdentifiers: [updateNotificationIdentifier])
    }

    func refreshNotificationState() async -> Bool {
        let enabled = UserDefaults.standard.bool(forKey: notificationsEnabledKey)

        guard enabled else {
            UserDefaults.standard.set(currentAppVersionIdentifier(), forKey: lastSeenVersionKey)
            let settings = await fetchNotificationSettings()
            await MainActor.run { self.authorizationStatus = settings.authorizationStatus }
            return true
        }

        let settings = await fetchNotificationSettings()
        authorizationStatus = settings.authorizationStatus

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            await notifyIfAppWasUpdated()
            return true
        case .notDetermined:
            let granted = await requestAuthorization()
            let refreshedSettings = await fetchNotificationSettings()
            await MainActor.run { self.authorizationStatus = refreshedSettings.authorizationStatus }

            if granted {
                await notifyIfAppWasUpdated()
                return true
            }

            UserDefaults.standard.set(false, forKey: notificationsEnabledKey)
            UserDefaults.standard.set(currentAppVersionIdentifier(), forKey: lastSeenVersionKey)
            return false
        case .denied:
            UserDefaults.standard.set(false, forKey: notificationsEnabledKey)
            UserDefaults.standard.set(currentAppVersionIdentifier(), forKey: lastSeenVersionKey)
            return false
        @unknown default:
            UserDefaults.standard.set(false, forKey: notificationsEnabledKey)
            UserDefaults.standard.set(currentAppVersionIdentifier(), forKey: lastSeenVersionKey)
            return false
        }
    }

    private var updateNotificationIdentifier: String {
        "app.update.notification"
    }

    private func notifyIfAppWasUpdated() async {
        let currentVersionIdentifier = currentAppVersionIdentifier()
        let lastSeen = UserDefaults.standard.string(forKey: lastSeenVersionKey)

        if lastSeen == nil {
            UserDefaults.standard.set(currentVersionIdentifier, forKey: lastSeenVersionKey)
            return
        }

        guard lastSeen != currentVersionIdentifier else { return }

        let isEnglish = UserDefaults.standard.string(forKey: "selectedLanguage") == "en"
        let version = displayVersionString()

        let content = UNMutableNotificationContent()
        content.title = isEnglish ? "App updated" : "Aplicacion actualizada"
        content.body = isEnglish
            ? "Version \(version) is now available with improvements and new features."
            : "La version \(version) ya esta disponible con mejoras y nuevas funciones."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: updateNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        do {
            try await addNotificationRequest(request)
            UserDefaults.standard.set(currentVersionIdentifier, forKey: lastSeenVersionKey)
        } catch {
            print("❌ No se pudo programar la notificacion de actualizacion: \(error.localizedDescription)")
        }
    }

    private func currentAppVersionIdentifier() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func displayVersionString() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (build \(build))"
    }

    private func fetchNotificationSettings() async -> UNNotificationSettings {
        await withCheckedContinuation { continuation in
            center.getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }
    }

    private func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }

    private func addNotificationRequest(_ request: UNNotificationRequest) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            center.add(request) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}

extension AppUpdateNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
