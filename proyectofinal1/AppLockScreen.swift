import SwiftUI
import LocalAuthentication

// MARK: - AppLockScreen
// Pantalla de bloqueo mostrada al abrir la app (con sesion guardada) y al volver
// de segundo plano. El desbloqueo es local: biometria o PIN guardado en Keychain;
// la sesion de Firebase ya sigue activa, no hace falta volver a autenticar.
struct AppLockScreen: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager

    @Binding var isLocked: Bool

    @State private var showPinPad = false
    @State private var showBiometricError = false
    @State private var autoPrompted = false

    private var canUseBiometrics: Bool { userManager.canUnlockWithBiometrics }
    private var hasPin: Bool { userManager.canUnlockWithPin }

    private var biometricIconName: String {
        switch BiometricAuthManager.biometricType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return "lock.fill"
        }
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

            VStack(spacing: 20) {
                Spacer()

                Image("LogoApp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: .black.opacity(0.2), radius: 14, x: 0, y: 6)

                Image(systemName: "lock.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.secondary)

                Text(localizationManager.translate("lock.title"))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)

                Text(localizationManager.translate("lock.subtitle"))
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer().frame(height: 12)

                // MARK: - Face ID / Touch ID
                if canUseBiometrics {
                    Button(action: biometricUnlock) {
                        VStack(spacing: 8) {
                            Image(systemName: biometricIconName)
                                .font(.system(size: 34))
                            Text(String(
                                format: localizationManager.translate("login.biometricButton"),
                                userManager.biometricDisplayName ?? ""
                            ))
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(.secondarySystemGroupedBackground))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, 32)
                }

                // MARK: - PIN
                if hasPin {
                    Button(action: {
                        showBiometricError = false
                        withAnimation(.easeInOut(duration: 0.25)) { showPinPad = true }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "number.circle.fill")
                                .font(.system(size: 20))
                            Text(localizationManager.translate("login.loginWithPin"))
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, 32)
                }

                // MARK: - Error de biometria
                if showBiometricError {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(localizationManager.translate("lock.biometricError"))
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 32)
                }

                // MARK: - Salida de emergencia
                Button(action: {
                    userManager.logout()
                    isLocked = false
                }) {
                    Text(localizationManager.translate("lock.logout"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.red)
                }
                .padding(.top, 8)

                Spacer()
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
                        isLocked = false
                        return true
                    },
                    onCancel: { showPinPad = false }
                )
                .environmentObject(themeManager)
                .environmentObject(localizationManager)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            // Auto-prompt de biometria una sola vez al aparecer la pantalla de bloqueo
            if canUseBiometrics && !autoPrompted {
                autoPrompted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    biometricUnlock()
                }
            }
        }
    }

    private func biometricUnlock() {
        let reason = localizationManager.translate("login.biometricReason")
        BiometricAuthManager.authenticate(reason: reason) { result in
            Task { @MainActor in
                switch result {
                case .success:
                    showBiometricError = false
                    isLocked = false
                case .failure(let error):
                    if let laError = error as? LAError,
                       laError.code == .userCancel || laError.code == .systemCancel {
                        // Cancelado a proposito: no mostrar error
                    } else {
                        // Fallo real (rostro no reconocido, sin permiso, bloqueo):
                        // avisar para que el usuario use el PIN o cierre sesion
                        showBiometricError = true
                    }
                }
            }
        }
    }
}
