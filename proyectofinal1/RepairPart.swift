import Foundation

// MARK: - RepairPart
struct RepairPart: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let compatibleModels: [String]
    let repairTime: String
    let stock: Bool
    let imageName: String

    // MARK: - Ícono según el tipo de repuesto
    var icon: String {
        let n = name.lowercased()

        if n.contains("pantalla") || n.contains("display") {
            return "iphone.gen3"
        } else if n.contains("batería") || n.contains("bateria") || n.contains("battery") {
            return "battery.100"
        } else if n.contains("cámara") || n.contains("camara") || n.contains("camera") {
            return "camera.fill"
        } else if n.contains("puerto") || n.contains("carga") || n.contains("lightning") || n.contains("usb-c") || n.contains("usb c") {
            return "cable.connector"
        } else if n.contains("altavoz") || n.contains("parlante") || n.contains("speaker") {
            return "speaker.wave.2.fill"
        } else if n.contains("micrófono") || n.contains("microfono") || n.contains("mic") {
            return "mic.fill"
        } else if n.contains("carcasa") || n.contains("chasis") || n.contains("case") {
            return "iphone.rear.camera"
        } else if n.contains("botón") || n.contains("boton") || n.contains("button") {
            return "poweron"
        } else if n.contains("táctil") || n.contains("tactil") || n.contains("touch") {
            return "hand.tap.fill"
        } else if n.contains("vidrio") || n.contains("cristal") || n.contains("glass") {
            return "square.fill"
        } else if n.contains("placa") || n.contains("board") || n.contains("logic") {
            return "cpu"
        } else if n.contains("face id") || n.contains("faceid") {
            return "faceid"
        } else if n.contains("home") {
            return "circle.fill"
        } else {
            return "wrench.and.screwdriver.fill"
        }
    }
}
