import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct CrearPerfilView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String = ""
    @State private var apellido: String = ""
    @State private var correo: String = ""
    @State private var telefono: String = ""
    @State private var imagenSeleccionada: PhotosPickerItem?
    @State private var fotoPerfil: Image?
    @State private var fotoPerfilUIImage: UIImage?
    @State private var showLogoutConfirmation = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                // MARK: - Header
                HStack {
                    Text("Mi Perfil")
                        .font(.system(size: fontSize + 12, weight: .bold, design: .rounded))
                    Spacer()
                    NavigationLink(destination: SettingsView()
                        .environmentObject(themeManager)
                        .environmentObject(userManager)) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: fontSize + 2, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // MARK: - Foto Perfil
                VStack(spacing: 12) {
                    ZStack(alignment: .bottomTrailing) {
                        if let foto = fotoPerfil {
                            foto
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                        } else {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 110, height: 110)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.gray)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }

                        PhotosPicker(selection: $imagenSeleccionada, matching: .images) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .blue.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        .onChange(of: imagenSeleccionada) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    fotoPerfil = Image(uiImage: uiImage)
                                    fotoPerfilUIImage = uiImage
                                }
                            }
                        }
                    }

                    Text("Editar foto")
                        .font(.system(size: fontSize - 4))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                // MARK: - Campos
                VStack(spacing: 0) {
                    fieldRow(icon: "person.fill", placeholder: "Nombre", text: $nombre)
                    Divider().padding(.leading, 52)
                    fieldRow(icon: "person.fill", placeholder: "Apellido", text: $apellido)
                    Divider().padding(.leading, 52)
                    fieldRow(icon: "envelope.fill", placeholder: "Correo", text: $correo, keyboard: .emailAddress)
                    Divider().padding(.leading, 52)
                    fieldRow(icon: "phone.fill", placeholder: "Teléfono", text: $telefono, keyboard: .phonePad)
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)

                // MARK: - Botones
                VStack(spacing: 12) {
                    Button(action: guardarPerfil) {
                        Text("Guardar cambios")
                            .font(.system(size: fontSize, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Button(action: { showLogoutConfirmation = true }) {
                        Text("Cerrar sesión")
                            .font(.system(size: fontSize, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGroupedBackground))
        .alert("Cerrar sesión", isPresented: $showLogoutConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                userManager.logout()
            }
        } message: {
            Text("¿Estás seguro que quieres cerrar sesión?")
        }
        .onAppear {
            if let usuario = userManager.currentUser {
                nombre = usuario.name
                correo = usuario.email
            }
        }
    }

    // MARK: - Field Row
    @ViewBuilder
    private func fieldRow(icon: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: fontSize - 1, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 22)
                .padding(.leading, 16)

            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .focused($isInputFocused)
                .font(.system(size: fontSize))
                .padding(.vertical, 14)
        }
    }

    // MARK: - Guardar
    private func guardarPerfil() {
        if let uiImage = fotoPerfilUIImage {
            userManager.uploadProfileImage(uiImage, userId: userManager.currentUser?.id.uuidString ?? "") { imageURL in
                DispatchQueue.main.async {
                    userManager.completarPerfil(
                        nombre: nombre,
                        apellido: apellido,
                        correo: correo,
                        direccion: "",
                        edad: "",
                        telefono: telefono,
                        fechaNacimiento: Date(),
                        profileImageURL: imageURL ?? ""
                    )
                    dismiss()
                }
            }
        } else {
            userManager.completarPerfil(
                nombre: nombre,
                apellido: apellido,
                correo: correo,
                direccion: "",
                edad: "",
                telefono: telefono,
                fechaNacimiento: Date(),
                profileImageURL: ""
            )
            dismiss()
        }
    }
}
