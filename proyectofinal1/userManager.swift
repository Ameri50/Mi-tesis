import SwiftUI
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn
import LocalAuthentication
import UIKit
import CryptoKit

class UserManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: AppUser?
    @Published var isLoading: Bool = false
    @Published var authError: String? = nil
    /// Tras un login con Google: pide crear PIN / activar Face ID para el
    /// desbloqueo rapido de la app. La vista raiz presenta el sheet con este dato.
    @Published var pendingQuickAccess: PendingQuickAccess? = nil
    /// Se activa tras un login iniciado por el usuario (correo, PIN, biometria,
    /// crear cuenta o Google). ContentView lo consume para NO bloquear la app
    /// justo despues de entrar; si la sesion se restaura sola al abrir la app,
    /// el flag queda en false y la pantalla de bloqueo aparece.
    @Published var didAuthenticateViaLogin = false

    // Emails que tienen acceso admin — edita esta lista
    private let adminEmails: Set<String> = [
        "fluttercodigo@gmail.com",
    ]

    @AppStorage("userEmail") private var storedEmail: String = ""
    @AppStorage("userName") private var storedName: String = ""
    @AppStorage("isLoggedIn") private var storedIsLoggedIn: Bool = false
    @AppStorage("userLastName") private var storedLastName: String = ""
    @AppStorage("userAddress") private var storedAddress: String = ""
    @AppStorage("userAge") private var storedAge: String = ""
    @AppStorage("userPhone") private var storedPhone: String = ""
    @AppStorage("userBirthdate") private var storedBirthdate: Double = 0
    @AppStorage("userProfileImage") private var storedProfileImage: String = ""
    @AppStorage("firebaseUID") private var storedFirebaseUID: String = ""

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }
            if let firebaseUser = firebaseUser {
                let email = firebaseUser.email ?? ""
                let name = firebaseUser.displayName ?? self.storedName
                self.buildSession(
                    uid: firebaseUser.uid,
                    email: email,
                    name: name.isEmpty ? email : name
                )
            } else {
                DispatchQueue.main.async {
                    self.currentUser = nil
                    self.isAuthenticated = false
                }
            }
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Admin check
    func isAdmin(email: String) -> Bool {
        adminEmails.contains(email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
    }

    // MARK: - Login
    func login(email: String, name: String, password: String? = nil) {
        guard !email.isEmpty, !name.isEmpty else { return }

        // Usuario invitado — sin Firebase Auth
        if email == "guest@email.com" {
            let guest = AppUser(
                id: UUID(),
                name: name,
                email: email,
                isGuest: true,
                isAdmin: false
            )
            DispatchQueue.main.async { [weak self] in
                self?.currentUser = guest
                self?.isAuthenticated = true
                self?.storedEmail = email
                self?.storedName = name
                self?.storedIsLoggedIn = true
                self?.storedFirebaseUID = "guest"
            }
            self.syncUserSessionToWeb(
                uid: "guest",
                email: email,
                name: name,
                isGuest: true,
                isAdmin: false
            )
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.authError = nil
        }

        didAuthenticateViaLogin = true
        let resolvedPassword = password ?? generatePassword(for: email)

        Auth.auth().signIn(withEmail: email, password: resolvedPassword) { [weak self] result, error in
            guard let self = self else { return }

            if let user = result?.user {
                // ✅ Login exitoso
                print("✅ Login exitoso: \(user.email ?? "") | UID: \(user.uid)")
                self.updateDisplayName(user: user, name: name)
                self.saveLocalSession(email: email, name: name)
                BiometricAuthManager.saveCredentials(.init(email: email, name: name, password: resolvedPassword))
                self.syncUserSessionToWeb(
                    uid: user.uid,
                    email: email,
                    name: name,
                    isGuest: false,
                    isAdmin: self.isAdmin(email: email)
                )
                DispatchQueue.main.async { self.isLoading = false }

            } else {
                // Usuario no existe → crear cuenta nueva
                Auth.auth().createUser(withEmail: email, password: resolvedPassword) { result, error in
                    DispatchQueue.main.async { self.isLoading = false }

                    if let error = error {
                        // ✅ Print detallado del error
                        let nsError = error as NSError
                        print("❌ Error código: \(nsError.code)")
                        print("❌ Error detalle: \(nsError.userInfo)")
                        DispatchQueue.main.async {
                            self.authError = error.localizedDescription
                        }
                        return
                    }

                    if let user = result?.user {
                        print("🎉 Cuenta creada: \(user.email ?? "") | UID: \(user.uid)")
                        self.updateDisplayName(user: user, name: name)
                        self.saveLocalSession(email: email, name: name)
                        BiometricAuthManager.saveCredentials(.init(email: email, name: name, password: resolvedPassword))
                        self.syncUserSessionToWeb(
                            uid: user.uid,
                            email: email,
                            name: name,
                            isGuest: false,
                            isAdmin: self.isAdmin(email: email)
                        )
                    }
                }
            }
        }
    }

    // MARK: - Face ID / Touch ID
    /// Login rapido desde la pantalla de login: solo cuentas de correo, porque
    /// requiere re-autenticar en Firebase con contraseña.
    var canLoginWithBiometrics: Bool {
        guard BiometricAuthManager.isAvailable,
              let creds = BiometricAuthManager.loadCredentials() else { return false }
        return creds.provider == "password"
    }

    /// Desbloqueo de la app con sesion ya activa: valido para cualquier provider,
    /// incluidas cuentas Google (la sesion de Firebase persiste; el chequeo es local).
    var canUnlockWithBiometrics: Bool {
        BiometricAuthManager.isAvailable && BiometricAuthManager.loadCredentials() != nil
    }

    var biometricDisplayName: String? {
        BiometricAuthManager.biometricType.displayName
    }

    /// Autentica con Face ID/Touch ID y, si tiene exito, inicia sesion con las
    /// credenciales guardadas en Keychain. `completion` recibe un mensaje de error
    /// legible en MainActor, o nil si todo salio bien / el usuario cancelo.
    func loginWithBiometrics(reason: String, completion: @escaping @MainActor (String?) -> Void) {
        guard let credentials = BiometricAuthManager.loadCredentials() else {
            Task { @MainActor in completion("login.biometricNoCredentials") }
            return
        }

        BiometricAuthManager.authenticate(reason: reason) { result in
            switch result {
            case .success:
                print("🔓 Biometria exitosa, iniciando sesion para \(credentials.email)")
                self.login(email: credentials.email, name: credentials.name, password: credentials.password)
                Task { @MainActor in completion(nil) }
            case .failure(let error):
                Task { @MainActor in
                    if let laError = error as? LAError,
                       laError.code == .userCancel || laError.code == .systemCancel || laError.code == .userFallback {
                        completion(nil) // Cancelado: no mostrar error
                    } else {
                        completion("login.biometricFailed")
                    }
                }
            }
        }
    }

    // MARK: - Crear cuenta
    /// Crea una cuenta nueva. Si el correo ya esta registrado devuelve la clave
    /// "login.accountExists" para que la vista muestre el mensaje correspondiente.
    /// - pin: PIN de 4 digitos opcional para entrar rapido (se guarda en Keychain).
    /// - enableBiometric: si es true, guarda credenciales para Face ID / Touch ID.
    func createAccount(email: String, name: String,
                       pin: String? = nil,
                       enableBiometric: Bool = true,
                       completion: @escaping @MainActor (String?) -> Void) {
        guard !email.isEmpty, !name.isEmpty else {
            Task { @MainActor in completion("login.fillAllFields") }
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.authError = nil
        }

        didAuthenticateViaLogin = true
        let password = generatePassword(for: email)

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }

            if let error = error as NSError? {
                print("❌ Error creando cuenta: \(error.code) — \(error.localizedDescription)")
                let key = (error.domain == AuthErrorDomain &&
                           error.code == AuthErrorCode.emailAlreadyInUse.rawValue)
                    ? "login.accountExists"
                    : "login.createAccountFailed"
                Task { @MainActor in completion(key) }
                return
            }

            guard let user = result?.user else {
                Task { @MainActor in completion("login.createAccountFailed") }
                return
            }

            print("🎉 Cuenta creada: \(user.email ?? "") | UID: \(user.uid)")
            self.updateDisplayName(user: user, name: name)
            self.saveLocalSession(email: email, name: name)
            if let pin = pin, !pin.isEmpty {
                BiometricAuthManager.savePin(pin, email: email, name: name)
            }
            if enableBiometric {
                BiometricAuthManager.saveCredentials(.init(email: email, name: name, password: password))
            }
            Task { @MainActor in completion(nil) }
        }
    }

    // MARK: - PIN de desbloqueo
    /// PIN para entrar desde la pantalla de login: solo cuentas de correo
    /// (re-autentica en Firebase con la contraseña generada).
    var canLoginWithPin: Bool {
        BiometricAuthManager.loadPin()?.provider == "password"
    }

    /// PIN para desbloquear la app con sesion activa: valido tambien para Google.
    var canUnlockWithPin: Bool {
        BiometricAuthManager.loadPin() != nil
    }

    /// Validacion sincrona: ¿el PIN coincide con el guardado?
    func validatePin(_ pin: String) -> Bool {
        BiometricAuthManager.loadPin()?.pin == pin
    }

    /// Entra con el PIN guardado tras verificarlo. La contraseña de Firebase se
    /// regenera de forma determinista a partir del correo guardado con el PIN.
    func loginWithPin(_ pin: String, completion: @escaping @MainActor (String?) -> Void) {
        guard let entry = BiometricAuthManager.loadPin() else {
            Task { @MainActor in completion("login.biometricNoCredentials") }
            return
        }
        guard entry.pin == pin else {
            Task { @MainActor in completion("login.pinWrong") }
            return
        }
        login(email: entry.email, name: entry.name)
        Task { @MainActor in completion(nil) }
    }

    // MARK: - Google Sign-In
    /// Inicia sesion (o crea la cuenta si no existe) con la cuenta de Google.
    /// No guarda credenciales biometricas: la contraseña de cuentas Google no es
    /// conocida por la app, asi que Face ID queda solo para cuentas de correo.
    func loginWithGoogle(presenting viewController: UIViewController,
                         completion: @escaping @MainActor (String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            Task { @MainActor in completion("login.googleNotConfigured") }
            return
        }

        didAuthenticateViaLogin = true
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.authError = nil
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Google Sign-In: \(error.localizedDescription)")
                DispatchQueue.main.async { self.isLoading = false }
                let canceled = (error as NSError).code == GIDSignInError.canceled.rawValue
                Task { @MainActor in completion(canceled ? nil : "login.googleFailed") }
                return
            }

            guard let user = result?.user, let idToken = user.idToken else {
                DispatchQueue.main.async { self.isLoading = false }
                Task { @MainActor in completion("login.googleFailed") }
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                DispatchQueue.main.async { self.isLoading = false }

                guard error == nil, let firebaseUser = authResult?.user else {
                    print("❌ Firebase Google auth: \(error?.localizedDescription ?? "sin usuario")")
                    Task { @MainActor in completion("login.googleFailed") }
                    return
                }

                let email = firebaseUser.email ?? user.profile?.email ?? ""
                let name = firebaseUser.displayName ?? user.profile?.name ?? email
                print("✅ Login con Google: \(email)")
                self.saveLocalSession(email: email, name: name)

                // Si la cuenta aun no tiene acceso rapido guardado, pedirlo.
                // Pequena espera: la vista acaba de cambiar de login a la app y
                // presentar el sheet en medio de ese cambio hace que SwiftUI lo ignore.
                let hasPin = BiometricAuthManager.loadPin()?.email == email
                let hasCreds = BiometricAuthManager.loadCredentials()?.email == email
                if !hasPin && !hasCreds {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.pendingQuickAccess = PendingQuickAccess(email: email, name: name)
                    }
                }

                Task { @MainActor in completion(nil) }
            }
        }
    }

    // MARK: - Acceso rapido (PIN / Face ID tras login con Google)
    /// Guarda el PIN y/o las credenciales biometricas de una cuenta Google.
    /// El desbloqueo es local: la sesion de Firebase persiste entre aperturas.
    func saveQuickAccess(email: String, name: String, pin: String?, enableBiometric: Bool) {
        if let pin = pin, !pin.isEmpty {
            BiometricAuthManager.savePin(pin, email: email, name: name, provider: "google")
        }
        if enableBiometric {
            BiometricAuthManager.saveCredentials(
                .init(email: email, name: name, password: "", provider: "google")
            )
        }
        pendingQuickAccess = nil
    }

    // MARK: - Logout
    func logout() {
        BiometricAuthManager.deleteCredentials()
        BiometricAuthManager.deletePin()
        let uidToSync = storedFirebaseUID.isEmpty ? Auth.auth().currentUser?.uid : storedFirebaseUID
        if let uidToSync {
            syncUserLogoutToWeb(uid: uidToSync)
        }

        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Error al cerrar sesión: \(error.localizedDescription)")
        }

        DispatchQueue.main.async { [weak self] in
            self?.currentUser = nil
            self?.isAuthenticated = false
            self?.storedEmail = ""
            self?.storedName = ""
            self?.storedIsLoggedIn = false
            self?.storedLastName = ""
            self?.storedAddress = ""
            self?.storedAge = ""
            self?.storedPhone = ""
            self?.storedBirthdate = 0
            self?.storedProfileImage = ""
            self?.storedFirebaseUID = ""
        }
        print("👋 Usuario cerró sesión")
    }

    // MARK: - Completar perfil
    func completarPerfil(nombre: String, apellido: String, correo: String, direccion: String,
                         edad: String, telefono: String, fechaNacimiento: Date, profileImageURL: String = "") {

        let trimmedName  = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLast  = apellido.trimmingCharacters(in: .whitespacesAndNewlines)
        let fullName     = [trimmedName, trimmedLast].filter { !$0.isEmpty }.joined(separator: " ")
        let trimmedEmail = correo.trimmingCharacters(in: .whitespacesAndNewlines)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            var updatedUser: AppUser
            if let current = self.currentUser {
                updatedUser = AppUser(
                    id: current.id,
                    name: fullName.isEmpty ? current.name : fullName,
                    email: trimmedEmail.isEmpty ? current.email : trimmedEmail,
                    isGuest: current.isGuest,
                    isAdmin: self.isAdmin(email: trimmedEmail.isEmpty ? current.email : trimmedEmail)
                )
            } else {
                updatedUser = AppUser(
                    id: UUID(),
                    name: fullName.isEmpty ? "Usuario" : fullName,
                    email: trimmedEmail,
                    isGuest: false,
                    isAdmin: self.isAdmin(email: trimmedEmail)
                )
            }

            updatedUser.apellido        = trimmedLast
            updatedUser.direccion       = direccion
            updatedUser.edad            = edad
            updatedUser.telefono        = telefono
            updatedUser.fechaNacimiento = fechaNacimiento
            updatedUser.profileImageURL = profileImageURL

            self.currentUser     = updatedUser
            self.isAuthenticated = true

            if !fullName.isEmpty     { self.storedName    = fullName }
            if !trimmedEmail.isEmpty { self.storedEmail   = trimmedEmail }
            self.storedLastName = trimmedLast
            self.storedAddress  = direccion
            self.storedAge      = edad
            self.storedPhone    = telefono
            self.storedBirthdate = fechaNacimiento.timeIntervalSince1970
            if !profileImageURL.isEmpty { self.storedProfileImage = profileImageURL }
            if let authUID = Auth.auth().currentUser?.uid {
                self.storedFirebaseUID = authUID
            }
        }

        guard let uid = Auth.auth().currentUser?.uid ?? (storedFirebaseUID.isEmpty ? nil : storedFirebaseUID) else { return }
        syncFullProfileToWeb(uid: uid)
    }

    // MARK: - Subir imagen de perfil
    func uploadProfileImage(_ image: UIImage, userId: String, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Error al convertir imagen")
            completion(nil)
            return
        }
        DispatchQueue.global(qos: .background).async {
            storageRef.putData(imageData) { _, error in
                if let error = error { print("❌ Error subiendo imagen: \(error)"); completion(nil); return }
                storageRef.downloadURL { url, error in
                    if let error = error { print("❌ Error obteniendo URL: \(error)"); completion(nil); return }
                    if let url = url {
                        print("✅ Imagen subida: \(url.absoluteString)")
                        completion(url.absoluteString)
                    }
                }
            }
        }
    }

    func updateUserProfile(name: String) {
        guard var user = currentUser else { return }
        DispatchQueue.main.async { [weak self] in
            user.name = name
            self?.currentUser = user
            self?.storedName = name
        }
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let error = error { print("❌ Error actualizando nombre: \(error)") }
            else { print("🔄 Perfil actualizado: \(name)") }
        }
    }

    // MARK: - Helpers privados

    private func buildSession(uid: String, email: String, name: String) {
        var user = AppUser(
            id: UUID(uuidString: uid) ?? UUID(),
            name: name,
            email: email,
            isGuest: email == "guest@email.com",
            isAdmin: isAdmin(email: email)
        )
        user.apellido        = storedLastName
        user.direccion       = storedAddress
        user.edad            = storedAge
        user.telefono        = storedPhone
        user.profileImageURL = storedProfileImage
        if storedBirthdate > 0 {
            user.fechaNacimiento = Date(timeIntervalSince1970: storedBirthdate)
        }

        DispatchQueue.main.async { [weak self] in
            self?.currentUser    = user
            self?.isAuthenticated = true
            self?.storedFirebaseUID = uid
        }
        syncUserSessionToWeb(
            uid: uid,
            email: email,
            name: name,
            isGuest: email == "guest@email.com",
            isAdmin: isAdmin(email: email)
        )
        print("🔄 Sesión activa: \(name) | Admin: \(isAdmin(email: email))")
    }

    private func saveLocalSession(email: String, name: String) {
        DispatchQueue.main.async { [weak self] in
            self?.storedEmail      = email
            self?.storedName       = name
            self?.storedIsLoggedIn = true
        }
    }

    private func updateDisplayName(user: FirebaseAuth.User, name: String) {
        if user.displayName == nil || user.displayName!.isEmpty {
            let req = user.createProfileChangeRequest()
            req.displayName = name
            req.commitChanges { error in
                if let error = error { print("⚠️ No se pudo guardar displayName: \(error)") }
            }
        }
    }

    private func syncUserSessionToWeb(uid: String, email: String, name: String, isGuest: Bool, isAdmin: Bool) {
        let db = Firestore.firestore()
        let payload: [String: Any] = [
            "uid": uid,
            "nombre": name,
            "email": email,
            "isGuest": isGuest,
            "isAdmin": isAdmin,
            "online": true,
            "lastLoginAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
            "platform": "iOS"
        ]

        for collectionName in ["usuarios", "users"] {
            db.collection(collectionName).document(uid).setData(payload, merge: true) { error in
                if let error = error {
                    print("❌ Error guardando usuario en \(collectionName): \(error)")
                } else {
                    print("✅ Usuario sincronizado en \(collectionName) con UID: \(uid)")
                }
            }
        }
    }

    private func syncFullProfileToWeb(uid: String) {
        guard let user = currentUser else { return }
        let db = Firestore.firestore()

        let payload: [String: Any] = [
            "uid": uid,
            "nombre": user.name,
            "apellido": user.apellido,
            "email": user.email,
            "direccion": user.direccion,
            "edad": user.edad,
            "telefono": user.telefono,
            "fechaNacimiento": user.fechaNacimiento?.timeIntervalSince1970 ?? 0,
            "profileImageURL": user.profileImageURL,
            "isGuest": user.isGuest,
            "isAdmin": user.isAdmin,
            "online": true,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        for collectionName in ["usuarios", "users"] {
            db.collection(collectionName).document(uid).setData(payload, merge: true) { error in
                if let error = error {
                    print("❌ Error actualizando perfil en \(collectionName): \(error)")
                } else {
                    print("✅ Perfil sincronizado en \(collectionName)")
                }
            }
        }
    }

    private func syncUserLogoutToWeb(uid: String) {
        guard !uid.isEmpty else { return }

        let db = Firestore.firestore()
        let payload: [String: Any] = [
            "online": false,
            "lastLogoutAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]

        for collectionName in ["usuarios", "users"] {
            db.collection(collectionName).document(uid).setData(payload, merge: true) { error in
                if let error = error {
                    print("❌ Error marcando logout en \(collectionName): \(error)")
                }
            }
        }
    }

    /// Genera una contraseña determinística a partir del correo usando SHA256.
    /// A diferencia de `String.hashValue` (que Swift aleatoriza en cada
    /// ejecución del proceso por seguridad), SHA256 siempre da el mismo
    /// resultado para el mismo texto de entrada — así la contraseña es
    /// estable entre reinicios de la app, dispositivos, etc.
    private func generatePassword(for email: String) -> String {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let inputData = Data((normalizedEmail + "MiTesisSalt2026").utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return "Px" + String(hashString.prefix(20)) + "!Z"
    }
}

// MARK: - AppUser Model

struct AppUser: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var isGuest: Bool
    var isAdmin: Bool
    let createdAt: Date

    var apellido: String = ""
    var direccion: String = ""
    var edad: String = ""
    var telefono: String = ""
    var fechaNacimiento: Date?
    var profileImageURL: String = ""

    init(id: UUID, name: String, email: String, isGuest: Bool = false, isAdmin: Bool = false) {
        self.id        = id
        self.name      = name
        self.email     = email
        self.isGuest   = isGuest
        self.isAdmin   = isAdmin
        self.createdAt = Date()
    }

    var displayName: String {
        guard isGuest else { return name }
        return (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es") == "en" ? "Guest" : "Invitado"
    }
    var isValidEmail: Bool  { email.contains("@") && email.contains(".") }
}

// MARK: - PendingQuickAccess
/// Datos de la cuenta Google que acaba de entrar y aun no tiene PIN ni
/// credenciales biometricas guardadas. La vista raiz presenta el sheet de
/// configuracion de acceso rapido mientras este valor sea no nil.
struct PendingQuickAccess: Identifiable {
    let id = UUID()
    let email: String
    let name: String
}
