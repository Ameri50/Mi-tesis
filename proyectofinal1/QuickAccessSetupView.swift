import SwiftUI

// MARK: - QuickAccessSetupView
// Sheet presentado tras un login con Google: pide crear un PIN de 4 digitos
// y/o activar Face ID para desbloquear la app al abrirla. El desbloqueo es
// local (la sesion de Firebase persiste), asi que funciona igual para Google.
struct QuickAccessSetupView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager

    let pending: PendingQuickAccess

    @State private var pin = ""
    @State private var pinConfirm = ""
    @State private var enableBiometric = true
    @State private var errorKey: String?

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

    private var biometricIconName: String {
        switch BiometricAuthManager.biometricType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return "lock.fill"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .padding(.top, 12)

                Text(localizationManager.translate("quickAccess.title"))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)

                Text(localizationManager.translate("quickAccess.subtitle"))
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)

                // Face ID / Touch ID
                if BiometricAuthManager.isAvailable,
                   let biometricName = userManager.biometricDisplayName {
                    Toggle(isOn: $enableBiometric) {
                        HStack(spacing: 10) {
                            Image(systemName: biometricIconName)
                                .foregroundColor(.secondary)
                            Text(String(format: localizationManager.translate("login.unlockWith"), biometricName))
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                // PIN
                HStack(spacing: 12) {
                    Image(systemName: "number.square.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    SecureField(localizationManager.translate("login.pinCreate"), text: pinBinding)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                if !pin.isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: "number.square.fill")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        SecureField(localizationManager.translate("login.pinConfirm"), text: pinConfirmBinding)
                            .keyboardType(.numberPad)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                if let errorKey {
                    Text(localizationManager.translate(errorKey))
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: save) {
                    Text(localizationManager.translate("quickAccess.save"))
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                Button(action: {
                    userManager.pendingQuickAccess = nil
                }) {
                    Text(localizationManager.translate("quickAccess.skip"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }

    private func save() {
        let pinTouched = !pin.isEmpty || !pinConfirm.isEmpty
        if pinTouched {
            guard pin.count == 4 else {
                errorKey = "login.pinInvalid"
                return
            }
            guard pin == pinConfirm else {
                errorKey = "login.pinMismatch"
                return
            }
        }
        let biometricOn = BiometricAuthManager.isAvailable && enableBiometric
        guard pinTouched || biometricOn else {
            errorKey = "quickAccess.chooseOne"
            return
        }
        userManager.saveQuickAccess(
            email: pending.email,
            name: pending.name,
            pin: pinTouched ? pin : nil,
            enableBiometric: biometricOn
        )
    }
}
