import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit
import CryptoKit

class UserManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: AppUser?
    @Published var isLoading: Bool = false
    @Published var authError: String? = nil

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
    func login(email: String, name: String) {
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
            }
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.authError = nil
        }

        let password = generatePassword(for: email)

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let user = result?.user {
                // ✅ Login exitoso
                print("✅ Login exitoso: \(user.email ?? "") | UID: \(user.uid)")
                self.updateDisplayName(user: user, name: name)
                self.saveLocalSession(email: email, name: name)
                DispatchQueue.main.async { self.isLoading = false }

            } else {
                // Usuario no existe → crear cuenta nueva
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
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
                        self.saveUserToFirestore(uid: user.uid, email: email, name: name)
                    }
                }
            }
        }
    }

    // MARK: - Logout
    func logout() {
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
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self,
                  let uid = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            do {
                if let user = self.currentUser {
                    try db.collection("usuarios").document(uid).setData(from: user)
                    print("✅ Datos guardados en Firestore")
                }
            } catch {
                print("❌ Error guardando en Firestore: \(error)")
            }
        }
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
        }
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

    private func saveUserToFirestore(uid: String, email: String, name: String) {
        let db = Firestore.firestore()
        db.collection("usuarios").document(uid).setData([
            "nombre": name,
            "email": email,
            "isGuest": false,
            "isAdmin": isAdmin(email: email),
            "creadoEn": FieldValue.serverTimestamp()
        ], merge: true) { error in
            if let error = error { print("❌ Error guardando en Firestore: \(error)") }
            else { print("✅ Usuario guardado en Firestore con UID: \(uid)") }
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

    var displayName: String { isGuest ? "Invitado" : name }
    var isValidEmail: Bool  { email.contains("@") && email.contains(".") }
}
