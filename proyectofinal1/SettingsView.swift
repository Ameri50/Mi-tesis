import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("appFontSize") private var appFontSize: Double = 16

    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var fontSizeManager: AppFontSizeManager

    @StateObject private var imageUploader = FirebaseImageUploader.shared

    @State private var showThemePicker = false
    @State private var showUploadAlert = false
    @State private var uploadMessage = ""
    @State private var showLogoutConfirmation = false

    // MARK: - Estado para el borrado masivo de productos
    @State private var showDeleteProductsConfirmation = false
    @State private var isDeletingProducts = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        profileSection
                        themeSection
                        fontSizeSection
                        notificationsSection

                        // Solo visible para admin
                        if userManager.currentUser?.isAdmin == true {
                            toolsSection
                        }

                        privacySection
                        infoSection
                        logoutSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .padding(.bottom, 30)
                }
            }
        }
        .alert(localizationManager.translate("settings.firebaseAlert"), isPresented: $showUploadAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(uploadMessage)
        }
        .alert(localizationManager.translate("settings.logout"), isPresented: $showLogoutConfirmation) {
            Button(localizationManager.translate("cancel"), role: .cancel) {}
            Button(localizationManager.translate("settings.logout"), role: .destructive) {
                userManager.logout()
            }
        } message: {
            Text(localizationManager.translate("settings.logoutConfirmation"))
        }
        .alert("Borrar todos los productos", isPresented: $showDeleteProductsConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Borrar todo", role: .destructive) {
                deleteAllProducts()
            }
        } message: {
            Text("Esto elimina TODOS los productos de Firestore de forma permanente. Esta acción no se puede deshacer.")
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            Spacer()
            Text(localizationManager.translate("settings.title"))
                .font(.system(size: appFontSize + 1, weight: .semibold))
                .foregroundStyle(themeManager.isDarkMode ? .white : .black)
            Spacer()
        }
        .frame(height: 56)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
    }

    // MARK: - Perfil
    private var profileSection: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .foregroundStyle(themeManager.isDarkMode ? .white : .black)

            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Text(userManager.currentUser?.name ?? "Usuario")
                        .font(.system(size: appFontSize + 2, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)

                    // Badge admin visible solo para el propio admin
                    if userManager.currentUser?.isAdmin == true {
                        Text("ADMIN")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange)
                            .clipShape(Capsule())
                    }
                }

                Text(userManager.currentUser?.email ?? "email@example.com")
                    .font(.system(size: appFontSize - 2))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Tema
    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(localizationManager.translate("settings.appearance"))

            Button(action: { showThemePicker.toggle() }) {
                settingRow(
                    icon: "paintbrush.fill",
                    title: localizationManager.translate("settings.theme"),
                    value: themeManager.isDarkMode
                        ? localizationManager.translate("settings.dark")
                        : localizationManager.translate("settings.light")
                )
            }
        }
        .sheet(isPresented: $showThemePicker) {
            ThemePickerSheet()
                .environmentObject(themeManager)
                .environmentObject(localizationManager)
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Tamaño de fuente
    private var fontSizeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(localizationManager.translate("settings.textSize"))

            VStack(spacing: 16) {
                HStack {
                    Text("A")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)

                    Slider(value: $appFontSize, in: 12...24, step: 1)
                        .tint(themeManager.isDarkMode ? .white : .black)
                        .onChange(of: appFontSize) { _, newValue in
                            fontSizeManager.fontSize = newValue
                        }

                    Text("A")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                }

                Text(localizationManager.translate("settings.currentSize") + ": \(Int(appFontSize))px")
                    .font(.system(size: appFontSize - 2))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    // MARK: - Notificaciones
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(localizationManager.translate("settings.notifications"))

            Toggle(isOn: $notificationsEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .frame(width: 24)

                    Text(localizationManager.translate("settings.enableNotifications"))
                        .font(.system(size: appFontSize))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                }
            }
            .tint(themeManager.isDarkMode ? .white : .black)
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    // MARK: - Herramientas Firebase (solo admin)
    private var toolsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(localizationManager.translate("settings.firebaseTools"))

            VStack(spacing: 1) {
                Button(action: {
                    imageUploader.uploadAllImagesAndUpdateProducts { success in
                        uploadMessage = success
                            ? localizationManager.translate("settings.uploadSuccess")
                            : localizationManager.translate("settings.uploadError")
                        showUploadAlert = true
                    }
                }) {
                    settingRow(icon: "photo.stack.fill", title: localizationManager.translate("settings.uploadImages"))
                }
                .disabled(imageUploader.isUploading)

                Button(action: {
                    FirebaseProductSync.shared.syncAllProducts { success in
                        uploadMessage = success
                            ? localizationManager.translate("settings.syncSuccess")
                            : localizationManager.translate("settings.syncError")
                        showUploadAlert = true
                    }
                }) {
                    settingRow(icon: "square.stack.3d.up.fill", title: localizationManager.translate("settings.syncProducts"))
                }

                // ⚠️ Botón temporal de mantenimiento — quitar antes de entregar/publicar la app
                Button(action: { showDeleteProductsConfirmation = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .frame(width: 24)

                        if isDeletingProducts {
                            Text("Eliminando productos...")
                                .font(.system(size: appFontSize))
                                .foregroundColor(.red)
                            Spacer()
                            ProgressView()
                        } else {
                            Text("Borrar TODOS los productos")
                                .font(.system(size: appFontSize))
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                }
                .disabled(isDeletingProducts)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    // MARK: - Privacidad
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(localizationManager.translate("settings.privacy"))

            VStack(spacing: 1) {
                settingRow(icon: "lock.fill", title: localizationManager.translate("settings.privacyPolicy"))
                settingRow(icon: "doc.text.fill", title: localizationManager.translate("settings.termsOfService"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    // MARK: - Información
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(localizationManager.translate("settings.information"))

            VStack(spacing: 1) {
                settingRow(icon: "info.circle.fill", title: localizationManager.translate("settings.about"), value: "v1.0.0")
                settingRow(icon: "envelope.fill", title: localizationManager.translate("settings.support"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    // MARK: - Cerrar Sesión
    private var logoutSection: some View {
        Button(action: { showLogoutConfirmation = true }) {
            HStack(spacing: 12) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.red)
                    .frame(width: 24)

                Text(localizationManager.translate("settings.logout"))
                    .font(.system(size: appFontSize, weight: .semibold))
                    .foregroundColor(.red)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.red.opacity(0.4))
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    // MARK: - Acción: borrar todos los productos
    private func deleteAllProducts() {
        isDeletingProducts = true
        FirebaseProductManager.shared.deleteAllProducts { success in
            DispatchQueue.main.async {
                isDeletingProducts = false
                uploadMessage = success
                    ? "✅ Todos los productos fueron eliminados de Firestore."
                    : "❌ Ocurrió un error al eliminar los productos. Revisa la consola."
                showUploadAlert = true
            }
        }
    }

    // MARK: - Componentes auxiliares
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: appFontSize - 1, weight: .semibold))
            .foregroundColor(.secondary)
            .padding(.horizontal, 4)
            .textCase(.uppercase)
    }

    private func settingRow(icon: String, title: String, value: String = "") -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                .frame(width: 24)

            Text(title)
                .font(.system(size: appFontSize))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)

            Spacer()

            if !value.isEmpty {
                Text(value)
                    .font(.system(size: appFontSize - 2))
                    .foregroundColor(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - Theme Picker
struct ThemePickerSheet: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager

    var body: some View {
        VStack(spacing: 20) {
            Text(localizationManager.translate("settings.theme"))
                .font(.headline)
            Button(localizationManager.translate("settings.light")) { themeManager.isDarkMode = false }
            Button(localizationManager.translate("settings.dark")) { themeManager.isDarkMode = true }
        }
        .padding()
    }
}
