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
            // MARK: - Fondo con glow
            GeometryReader { geo in
                ZStack {
                    LinearGradient(
                        colors: themeManager.isDarkMode
                            ? [Color(white: 0.06), Color(red: 0.07, green: 0.09, blue: 0.16), Color(white: 0.1)]
                            : [Color(.systemBackground), Color(red: 0.93, green: 0.96, blue: 1.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Circle()
                        .fill(Color.blue.opacity(themeManager.isDarkMode ? 0.25 : 0.18))
                        .frame(width: 340, height: 340)
                        .blur(radius: 90)
                        .offset(x: geo.size.width * 0.25, y: -geo.size.height * 0.08)

                    Circle()
                        .fill(Color.indigo.opacity(themeManager.isDarkMode ? 0.2 : 0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 90)
                        .offset(x: -geo.size.width * 0.3, y: geo.size.height * 0.35)
                }
                .ignoresSafeArea()
            }

            ScrollView {
                VStack(spacing: 28) {
                    // MARK: - Header
                    VStack(spacing: 14) {
                        Image("LogoApp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 92, height: 92)
                            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                            .shadow(color: .blue.opacity(0.4), radius: 26, x: 0, y: 12)
                            .opacity(appear ? 1 : 0)
                            .offset(y: appear ? 0 : 20)

                        VStack(spacing: 4) {
                            Text("TechSupport")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            Text(localizationManager.translate("login.welcome"))
                                .font(.system(size: fontSize - 1))
                                .foregroundColor(.secondary)
                        }
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 16)
                    }
                    .padding(.top, 24)

                    // MARK: - Tarjeta de formulario
                    VStack(spacing: 16) {
                        // Selector de modo: pildora deslizante
                        ZStack(alignment: .leading) {
                            GeometryReader { geo in
                                let segment = geo.size.width / CGFloat(AuthMode.allCases.count)
                                let index = CGFloat(AuthMode.allCases.firstIndex(of: authMode) ?? 0)
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue, Color(red: 0.25, green: 0.62, blue: 1.0)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: segment - 6, height: geo.size.height - 8)
                                    .position(x: segment * (index + 0.5), y: geo.size.height / 2)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: authMode)
                            }

                            HStack(spacing: 0) {
                                ForEach(AuthMode.allCases, id: \.self) { mode in
                                    Button {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                            authMode = mode
                                        }
                                    } label: {
                                        Text(localizationManager.translate(
                                            mode == .signIn ? "login.signIn" : "login.createAccount"
                                        ))
                                        .font(.system(size: fontSize - 1, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .foregroundColor(authMode == mode ? .white : .secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .frame(height: 48)
                        .padding(4)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(Capsule())

                        // Campo Nombre
                        ModernField(
                            icon: "person.fill",
                            placeholder: localizationManager.translate("profile.name"),
                            text: $name,
                            fontSize: fontSize,
                            focused: focusedField == .name,
                            submit: .next
                        ) { focusedField = .email }

                        // Campo Email
                        ModernField(
                            icon: "envelope.fill",
                            placeholder: localizationManager.translate("profile.email"),
                            text: $email,
                            keyboard: .emailAddress,
                            autoCapitalization: .never,
                            fontSize: fontSize,
                            focused: focusedField == .email
                        ) { focusedField = nil }

                        // MARK: - Campos exclusivos de Crear Cuenta
                        if authMode == .createAccount {
                            VStack(spacing: 14) {
                                // PIN de 4 digitos (opcional)
                                ModernField(
                                    icon: "number",
                                    placeholder: localizationManager.translate("login.pinCreate"),
                                    text: pinBinding,
                                    isSecure: true,
                                    keyboard: .numberPad,
                                    fontSize: fontSize,
                                    focused: focusedField == .pin,
                                    submit: .next
                                ) { focusedField = .pinConfirm }

                                // Confirmar PIN (solo si empezo a escribirlo)
                                if !pin.isEmpty {
                                    ModernField(
                                        icon: "number",
                                        placeholder: localizationManager.translate("login.pinConfirm"),
                                        text: pinConfirmBinding,
                                        isSecure: true,
                                        keyboard: .numberPad,
                                        fontSize: fontSize,
                                        focused: focusedField == .pinConfirm
                                    ) { focusedField = nil }
                                }

                                // Opcion Face ID / Touch ID
                                if BiometricAuthManager.isAvailable,
                                   let biometricName = userManager.biometricDisplayName {
                                    Toggle(isOn: $enableBiometric) {
                                        HStack(spacing: 12) {
                                            Image(systemName: biometricIconName)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(enableBiometric ? .white : .secondary)
                                                .frame(width: 34, height: 34)
                                                .background(enableBiometric
                                                    ? Color.blue
                                                    : Color.secondary.opacity(themeManager.isDarkMode ? 0.25 : 0.15))
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            Text(String(format: localizationManager.translate("login.unlockWith"), biometricName))
                                                .font(.system(size: fontSize))
                                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                        }
                                    }
                                    .toggleStyle(.switch)
                                    .tint(.blue)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(Color(.tertiarySystemGroupedBackground))
                                    )
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Error
                        if showError {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(errorMessage)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .font(.system(size: fontSize - 2, weight: .medium))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(
                                Color.red.opacity(0.12),
                                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                            )
                        }

                        // Botón principal: Iniciar Sesion o Crear Cuenta
                        Button(action: primaryAction) {
                            HStack(spacing: 10) {
                                Text(localizationManager.translate(
                                    authMode == .signIn ? "login.signIn" : "login.createAccount"
                                ))
                                .font(.system(size: fontSize + 1, weight: .bold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: fontSize, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                isFormValid
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: [Color.blue, Color(red: 0.25, green: 0.62, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                  )
                                : AnyShapeStyle(Color(.tertiarySystemGroupedBackground))
                            )
                            .foregroundColor(isFormValid ? .white : .secondary)
                            .clipShape(Capsule())
                            .shadow(color: .blue.opacity(isFormValid ? 0.4 : 0), radius: 14, x: 0, y: 7)
                        }
                        .disabled(!isFormValid)

                        // MARK: - Entrar con PIN (cuenta con PIN guardado)
                        if authMode == .signIn && hasSavedPin {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) { showPinPad = true }
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "number.circle.fill")
                                    Text(localizationManager.translate("login.loginWithPin"))
                                }
                                .font(.system(size: fontSize, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .foregroundColor(.blue)
                                .background(
                                    Capsule()
                                        .strokeBorder(Color.blue.opacity(0.45), lineWidth: 1.2)
                                )
                            }
                        }

                        // MARK: - Face ID / Touch ID
                        if canUseBiometrics {
                            Button(action: biometricLoginAction) {
                                HStack(spacing: 10) {
                                    Image(systemName: biometricIconName)
                                    Text(String(
                                        format: localizationManager.translate("login.biometricButton"),
                                        userManager.biometricDisplayName ?? ""
                                    ))
                                }
                                .font(.system(size: fontSize, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .foregroundColor(.blue)
                                .background(
                                    Capsule()
                                        .strokeBorder(Color.blue.opacity(0.45), lineWidth: 1.2)
                                )
                            }
                        }

                        // MARK: - Google
                        GoogleSignInButton(scheme: .light, style: .wide, state: .normal) {
                            googleLoginAction()
                        }
                        .frame(height: 52)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
                    }
                    .padding(20)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 28, style: .continuous)
                    )
                    .shadow(
                        color: .black.opacity(themeManager.isDarkMode ? 0.4 : 0.1),
                        radius: 26, x: 0, y: 14
                    )
                    .padding(.horizontal, 20)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 30)
                    .onChange(of: authMode) { _, _ in
                        pin = ""
                        pinConfirm = ""
                        showError = false
                    }
                    .animation(.easeInOut(duration: 0.25), value: authMode)
                }
                .padding(.bottom, 32)
            }
            .scrollDismissesKeyboard(.interactively)

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
}

// MARK: - ModernField
/// Campo del formulario: icono en chip, fondo suave y anillo de color al enfocar.
private struct ModernField: View {
    @EnvironmentObject var themeManager: ThemeManager

    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure = false
    var keyboard: UIKeyboardType = .default
    var autoCapitalization: TextInputAutocapitalization = .sentences
    var fontSize: Double = 16
    var focused = false
    var submit: SubmitLabel = .done
    var onSubmit: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(focused ? .white : .secondary)
                .frame(width: 34, height: 34)
                .background(
                    focused
                        ? Color.blue
                        : Color.secondary.opacity(themeManager.isDarkMode ? 0.25 : 0.15)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: fontSize))
            .foregroundColor(themeManager.isDarkMode ? .white : .black)
            .keyboardType(keyboard)
            .autocorrectionDisabled()
            .textInputAutocapitalization(autoCapitalization)
            .submitLabel(submit)
            .onSubmit(onSubmit)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(focused ? Color.blue : Color.clear, lineWidth: 1.5)
        )
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
