import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    
    @State private var email = ""
    @State private var name = ""
    @State private var pin = ""
    @State private var pinConfirm = ""
    @State private var enableBiometric = true
    @State private var showError = false
    @State private var showPinPad = false
    @State private var errorMessage = ""
    @State private var appear = false
    @State private var canUseBiometrics = false
    @State private var hasSavedPin = false
    @State private var autoPrompted = false

    enum Field { case name, email, pin, pinConfirm }
    enum AuthMode: String, CaseIterable {
        case signIn, createAccount
    }
    @FocusState private var focusedField: Field?

    @State private var authMode: AuthMode = .signIn

    /// PIN filtrado: solo digitos, maximo 4.
    private var pinBinding: Binding<String> {
        Binding(
            get: { pin },
            set: { pin = String($0.filter(\.isNumber).prefix(4)) }
        )
    }

    private var pinConfirmBinding: Binding<String> {
        Binding(
            get: { pinConfirm },
            set: { pinConfirm = String($0.filter(\.isNumber).prefix(4)) }
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: themeManager.isDarkMode
                    ? [Color(white: 0.08), Color(white: 0.14)]
                    : [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()

                // MARK: - Logo
                Image("LogoApp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 20)

                Spacer()

                // MARK: - Formulario
                VStack(spacing: 14) {

                    // Selector: Iniciar Sesion / Crear Cuenta
                    Picker("", selection: $authMode) {
                        Text(localizationManager.translate("login.signIn"))
                            .tag(AuthMode.signIn)
                        Text(localizationManager.translate("login.createAccount"))
                            .tag(AuthMode.createAccount)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: authMode) { _, _ in
                        pin = ""
                        pinConfirm = ""
                        showError = false
                    }

                    // Campo Nombre
                    HStack(spacing: 12) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField(localizationManager.translate("profile.name"), text: $name)
                            .font(.system(size: fontSize))
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .name)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // Campo Email
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField(localizationManager.translate("profile.email"), text: $email)
                            .font(.system(size: fontSize))
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.done)
                            .onSubmit { focusedField = nil }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // MARK: - Campos exclusivos de Crear Cuenta
                    if authMode == .createAccount {
                        // PIN de 4 digitos (opcional)
                        HStack(spacing: 12) {
                            Image(systemName: "number.square.fill")
                                .foregroundColor(.secondary)
                                .frame(width: 20)
                            SecureField(localizationManager.translate("login.pinCreate"), text: pinBinding)
                                .font(.system(size: fontSize))
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .pin)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .pinConfirm }
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        // Confirmar PIN (solo si empezo a escribirlo)
                        if !pin.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "number.square.fill")
                                    .foregroundColor(.secondary)
                                    .frame(width: 20)
                                SecureField(localizationManager.translate("login.pinConfirm"), text: pinConfirmBinding)
                                    .font(.system(size: fontSize))
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: .pinConfirm)
                                    .submitLabel(.done)
                                    .onSubmit { focusedField = nil }
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }

                        // Opcion Face ID / Touch ID
                        if BiometricAuthManager.isAvailable,
                           let biometricName = userManager.biometricDisplayName {
                            Toggle(isOn: $enableBiometric) {
                                HStack(spacing: 10) {
                                    Image(systemName: biometricIconName)
                                        .foregroundColor(.secondary)
                                    Text(String(format: localizationManager.translate("login.unlockWith"), biometricName))
                                        .font(.system(size: fontSize))
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }

                    // Error
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: fontSize - 2))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }

                    // Botón principal: Iniciar Sesion o Crear Cuenta
                    Button(action: primaryAction) {
                        HStack(spacing: 10) {
                            Image(systemName: authMode == .signIn ? "arrow.right.circle.fill" : "person.badge.plus")
                                .font(.system(size: fontSize + 2))
                            Text(localizationManager.translate(
                                authMode == .signIn ? "login.signIn" : "login.createAccount"
                            ))
                                .font(.system(size: fontSize, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? Color.blue : Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(!isFormValid)

                    // MARK: - Entrar con PIN (cuenta con PIN guardado)
                    if authMode == .signIn && hasSavedPin {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) { showPinPad = true }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "number.circle.fill")
                                    .font(.system(size: fontSize + 2))
                                Text(localizationManager.translate("login.loginWithPin"))
                                    .font(.system(size: fontSize, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.secondarySystemGroupedBackground))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }

                    // MARK: - Face ID / Touch ID
                    if canUseBiometrics {
                        Button(action: biometricLoginAction) {
                            HStack(spacing: 10) {
                                Image(systemName: biometricIconName)
                                    .font(.system(size: fontSize + 2))
                                Text(String(
                                    format: localizationManager.translate("login.biometricButton"),
                                    userManager.biometricDisplayName ?? ""
                                ))
                                    .font(.system(size: fontSize, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.secondarySystemGroupedBackground))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }

                    // MARK: - Google
                    GoogleSignInButton(scheme: .light, style: .wide, state: .normal) {
                        googleLoginAction()
                    }
                    .frame(height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.secondary.opacity(0.4))
                        Text("o")
                            .font(.system(size: fontSize - 3))
                            .foregroundColor(.secondary)
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.secondary.opacity(0.4))
                    }

                    // Botón Invitado
                    Button(action: guestLoginAction) {
                        HStack(spacing: 10) {
                            Image(systemName: "person.crop.circle.dashed")
                                .font(.system(size: fontSize + 2))
                            Text(localizationManager.translate("login.continueAsGuest"))
                                .font(.system(size: fontSize, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(.horizontal, 24)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 30)

                Spacer().frame(height: 40)
            }

            // MARK: - PIN Pad
            if showPinPad {
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .onTapGesture { showPinPad = false }

                PinPadView(
                    title: localizationManager.translate("login.pinEnterTitle"),
                    onComplete: { code in
                        guard userManager.validatePin(code) else { return false }
                        showPinPad = false
                        userManager.loginWithPin(code) { _ in }
                        return true
                    },
                    onCancel: { showPinPad = false }
                )
                .environmentObject(themeManager)
                .environmentObject(localizationManager)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // MARK: - Cargando
            if userManager.isLoading {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.4)
                    .progressViewStyle(.circular)
            }
        }
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        .onAppear {
            canUseBiometrics = userManager.canLoginWithBiometrics
            hasSavedPin = userManager.canLoginWithPin
            if canUseBiometrics && !autoPrompted {
                autoPrompted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    biometricLoginAction()
                }
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
                appear = true
            }
        }
    }

    private var biometricIconName: String {
        switch BiometricAuthManager.biometricType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return "lock.fill"
        }
    }

    private func biometricLoginAction() {
        let reason = localizationManager.translate("login.biometricReason")
        userManager.loginWithBiometrics(reason: reason) { errorKey in
            if let errorKey {
                errorMessage = localizationManager.translate(errorKey)
                showError = true
            } else {
                showError = false
            }
        }
    }

    // MARK: - Actions
    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }

    /// Validacion del formulario segun el modo activo.
    private var isFormValid: Bool {
        guard !email.isEmpty, !name.isEmpty else { return false }
        if authMode == .createAccount {
            guard isValidEmail else { return false }
            let pinTouched = !pin.isEmpty || !pinConfirm.isEmpty
            if pinTouched {
                return pin.count == 4 && pin == pinConfirm
            }
        }
        return true
    }

    private func primaryAction() {
        guard isValidEmail else {
            errorMessage = localizationManager.translate("login.invalidEmail")
            showError = true
            return
        }

        if authMode == .createAccount {
            let pinTouched = !pin.isEmpty || !pinConfirm.isEmpty
            if pinTouched {
                guard pin.count == 4 else {
                    errorMessage = localizationManager.translate("login.pinInvalid")
                    showError = true
                    return
                }
                guard pin == pinConfirm else {
                    errorMessage = localizationManager.translate("login.pinMismatch")
                    showError = true
                    return
                }
            }
        }

        showError = false

        if authMode == .signIn {
            loginAction()
        } else {
            createAccountAction()
        }
    }

    private func createAccountAction() {
        let finalPin = pin.isEmpty ? nil : pin
        let useBiometric = BiometricAuthManager.isAvailable && enableBiometric
        userManager.createAccount(
            email: email,
            name: name,
            pin: finalPin,
            enableBiometric: useBiometric
        ) { errorKey in
            if let errorKey {
                errorMessage = localizationManager.translate(errorKey)
                showError = true
            } else {
                showError = false
            }
        }
    }

    private func googleLoginAction() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        showError = false
        userManager.loginWithGoogle(presenting: root) { errorKey in
            if let errorKey {
                errorMessage = localizationManager.translate(errorKey)
                showError = true
            } else {
                showError = false
            }
        }
    }

    private func loginAction() {
        userManager.login(email: email, name: name)
    }

    private func guestLoginAction() {
        userManager.login(email: "guest@email.com", name: localizationManager.translate("login.guest"))
    }
}

// MARK: - PinPadView
/// Pad numerico de 4 digitos con puntos indicadores. `onComplete` devuelve true
/// si el PIN fue aceptado (la vista padre se encarga de cerrar); false sacude y
/// limpia para reintentar.
struct PinPadView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager

    let title: String
    let onComplete: (String) -> Bool
    let onCancel: () -> Void

    @State private var entered = ""
    @State private var shake = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 18), count: 3)

    var body: some View {
        VStack(spacing: 22) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)

            // Puntos indicadores
            HStack(spacing: 18) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .strokeBorder(themeManager.isDarkMode ? .white : .black, lineWidth: 1.5)
                        .background(Circle().fill(index < entered.count ? (themeManager.isDarkMode ? Color.white : Color.black) : .clear))
                        .frame(width: 16, height: 16)
                }
            }
            .offset(x: shake ? -10 : 0)

            // Teclas
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(1...9, id: \.self) { digit in
                    keyButton("\(digit)")
                }
                keyButton("") // espaciador
                    .disabled(true)
                    .opacity(0)
                keyButton("0")
                keyButton("delete.backward.fill", isSystemImage: true)
            }
            .padding(.horizontal, 8)

            Button(localizationManager.translate("login.close")) {
                onCancel()
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.red)
            .padding(.top, 4)
        }
        .padding(24)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
        }))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 28)
        .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 12)
    }

    private func keyButton(_ label: String, isSystemImage: Bool = false) -> some View {
        Button(action: { tapKey(label, isSystemImage: isSystemImage) }) {
            Group {
                if isSystemImage {
                    Image(systemName: label)
                        .font(.system(size: 22, weight: .medium))
                } else {
                    Text(label)
                        .font(.system(size: 26, weight: .medium))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(Color(.secondarySystemGroupedBackground))
            .foregroundColor(themeManager.isDarkMode ? .white : .black)
            .clipShape(Circle())
        }
    }

    private func tapKey(_ label: String, isSystemImage: Bool) {
        if isSystemImage {
            if !entered.isEmpty { entered.removeLast() }
            return
        }
        guard entered.count < 4 else { return }
        entered.append(label)
        if entered.count == 4 {
            let code = entered
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                if onComplete(code) {
                    entered = ""
                } else {
                    withAnimation(.default) { shake = true }
                    entered = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        shake = false
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserManager())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
