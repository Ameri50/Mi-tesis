import SwiftUI
import Foundation

class CulqiManager: ObservableObject {
    static let shared = CulqiManager()
    
    // Reemplaza con tu llave pública de Culqi
    let publicKey = "pk_test_tu_llave_publica_aqui"
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var token: String?
    @Published var paymentSuccess = false
    
    init() {
        setupCulqi()
    }
    
    private func setupCulqi() {
        // Inicializar Culqi si está disponible
        if NSClassFromString("Culqi") != nil {
            // Culqi está disponible
            print("✅ Culqi SDK cargado correctamente")
        }
    }
    
    // MARK: - Crear Token
    func createToken(
        cardNumber: String,
        cvv: String,
        expiryMonth: String,
        expiryYear: String,
        email: String
    ) {
        isLoading = true
        errorMessage = nil
        token = nil
        
        // Validar formato de datos
        guard cardNumber.count >= 13 else {
            self.errorMessage = "Número de tarjeta inválido"
            self.isLoading = false
            return
        }
        
        guard cvv.count >= 3 else {
            self.errorMessage = "CVV inválido"
            self.isLoading = false
            return
        }
        
        guard !expiryMonth.isEmpty && !expiryYear.isEmpty else {
            self.errorMessage = "Fecha de vencimiento inválida"
            self.isLoading = false
            return
        }
        
        // Simular creación de token (en producción usarías la API de Culqi)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Token simulado (en producción vendría de Culqi)
            let simulatedToken = "tok_\(UUID().uuidString.prefix(20))"
            
            self.isLoading = false
            self.token = simulatedToken
            self.paymentSuccess = true
            
            print("✅ Token creado: \(simulatedToken)")
        }
    }
    
    // MARK: - Procesar Pago en Backend
    func processPaymentWithServer(
        token: String,
        amount: Double,
        email: String,
        description: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        isLoading = true
        
        // URL de tu servidor
        let urlString = "https://tuservidor.com/api/payment"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            completion(false, "URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "token": token,
            "amount": amount,
            "email": email,
            "description": description,
            "currency": "PEN"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            self.errorMessage = "Error procesando datos"
            self.isLoading = false
            completion(false, "Error procesando datos")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Sin datos de respuesta"
                    completion(false, "Sin datos")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let success = json["success"] as? Bool, success {
                            self?.paymentSuccess = true
                            completion(true, nil)
                        } else {
                            let message = json["message"] as? String ?? "Error desconocido"
                            self?.errorMessage = message
                            completion(false, message)
                        }
                    }
                } catch {
                    self?.errorMessage = "Error procesando respuesta"
                    completion(false, "Error procesando respuesta")
                }
            }
        }.resume()
    }
    
    // MARK: - Reiniciar
    func reset() {
        isLoading = false
        errorMessage = nil
        token = nil
        paymentSuccess = false
    }
}
