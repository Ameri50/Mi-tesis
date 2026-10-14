import Foundation
import LocalAuthentication
import Security

// MARK: - BiometricAuthManager
// Envuelve LocalAuthentication y el Keychain para permitir "Iniciar sesion con Face ID".
// Las credenciales solo se guardan tras un login manual exitoso (no invitado) y se
// eliminan del Keychain al cerrar sesion.
enum BiometricAuthManager {

    enum BiometricType {
        case none, faceID, touchID

        var displayName: String? {
            switch self {
            case .faceID: return "Face ID"
            case .touchID: return "Touch ID"
            case .none: return nil
            }
        }
    }

    /// provider: "password" (login con correo) o "google" (sin contraseña local;
    /// el desbloqueo es local porque la sesion de Firebase persiste).
    struct Credentials {
        let email: String
        let name: String
        let password: String
        let provider: String

        init(email: String, name: String, password: String, provider: String = "password") {
            self.email = email
            self.name = name
            self.password = password
            self.provider = provider
        }
    }

    struct PinEntry {
        let pin: String
        let email: String
        let name: String
        let provider: String

        init(pin: String, email: String, name: String, provider: String = "password") {
            self.pin = pin
            self.email = email
            self.name = name
            self.provider = provider
        }
    }

    private static let service = "com.mitesis.proyectofinal1"
    private static let account = "biometricLogin"
    private static let pinAccount = "appUnlockPin"

    // MARK: - Biometria
    static var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return .none
        }
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }

    static var isAvailable: Bool { biometricType != .none }

    /// Autentica con Face ID / Touch ID. Incluye fallback al codigo del dispositivo
    /// (politica .deviceOwnerAuthentication) para no bloquear al usuario por fallos.
    static func authenticate(reason: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Cancelar"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            if success {
                completion(.success(()))
            } else if let error {
                completion(.failure(error))
            } else {
                completion(.failure(LAError(LAError.authenticationFailed)))
            }
        }
    }

    // MARK: - Keychain
    static func saveCredentials(_ credentials: Credentials) {
        let isGoogle = credentials.provider == "google"
        guard !credentials.email.isEmpty, (!credentials.password.isEmpty || isGoogle) else { return }

        let payload: [String: String] = [
            "email": credentials.email,
            "name": credentials.name,
            "password": credentials.password,
            "provider": credentials.provider
        ]
        guard let data = try? JSONEncoder().encode(payload) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        // Reemplaza cualquier entrada previa
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        SecItemAdd(attributes as CFDictionary, nil)
    }

    static func loadCredentials() -> Credentials? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let payload = try? JSONDecoder().decode([String: String].self, from: data),
              let email = payload["email"],
              let name = payload["name"],
              let password = payload["password"],
              !email.isEmpty
        else { return nil }

        // Entradas guardadas antes de la marca "provider" se tratan como password
        let provider = payload["provider"] ?? "password"
        guard !password.isEmpty || provider == "google" else { return nil }

        return Credentials(email: email, name: name, password: password, provider: provider)
    }

    static func deleteCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - PIN de desbloqueo
    static func savePin(_ pin: String, email: String, name: String, provider: String = "password") {
        guard pin.count == 4, !email.isEmpty else { return }

        let payload: [String: String] = [
            "pin": pin,
            "email": email,
            "name": name,
            "provider": provider
        ]
        guard let data = try? JSONEncoder().encode(payload) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: pinAccount
        ]
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        SecItemAdd(attributes as CFDictionary, nil)
    }

    static func loadPin() -> PinEntry? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: pinAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let payload = try? JSONDecoder().decode([String: String].self, from: data),
              let pin = payload["pin"],
              let email = payload["email"],
              let name = payload["name"],
              pin.count == 4, !email.isEmpty
        else { return nil }

        return PinEntry(
            pin: pin,
            email: email,
            name: name,
            provider: payload["provider"] ?? "password"
        )
    }

    static func deletePin() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: pinAccount
        ]
        SecItemDelete(query as CFDictionary)
    }
}
