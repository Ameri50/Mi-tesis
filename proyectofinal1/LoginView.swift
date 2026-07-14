import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    
    @State private var email = ""
    @State private var name = ""
    @State private var showError = false
    @State private var showTerms = false
    @State private var termsAccepted = false
    @State private var errorMessage = ""
    @State private var appear = false

    enum Field { case name, email }
    @FocusState private var focusedField: Field?

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

                    // Términos
                    HStack {
                        Button(action: { showTerms = true }) {
                            Text(localizationManager.translate("login.termsAndConditions"))
                                .underline()
                                .font(.system(size: fontSize - 3))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Image(systemName: termsAccepted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundColor(termsAccepted ? .green : .secondary)
                            .onTapGesture { termsAccepted.toggle() }
                    }
                    .padding(.horizontal, 4)

                    // Error
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: fontSize - 2))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }

                    // Botón Login
                    Button(action: loginAction) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: fontSize + 2))
                            Text(localizationManager.translate("login.signIn"))
                                .font(.system(size: fontSize, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            termsAccepted && !email.isEmpty && !name.isEmpty
                                ? Color.blue
                                : Color.blue.opacity(0.4)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(!termsAccepted || email.isEmpty || name.isEmpty)

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

            // MARK: - Terms Sheet
            if showTerms {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { showTerms = false }

                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 40, height: 4)
                        .foregroundColor(.secondary.opacity(0.4))

                    Text(localizationManager.translate("login.termsAndConditions"))
                        .font(.system(size: fontSize + 2, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)

                    ScrollView {
                        Text(localizationManager.translate("login.termsPlaceholder"))
                            .font(.system(size: fontSize - 2))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .padding()
                    }

                    Button(localizationManager.translate("login.close")) {
                        showTerms = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .font(.system(size: fontSize, weight: .bold))
                }
                .padding(24)
                .background(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
                }))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 16)
                .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
                appear = true
            }
        }
    }

    // MARK: - Actions
    private func loginAction() {
        userManager.login(email: email, name: name)
    }

    private func guestLoginAction() {
        userManager.login(email: "guest@email.com", name: localizationManager.translate("login.guest"))
    }
}

#Preview {
    LoginView()
        .environmentObject(UserManager())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
