import Foundation

// MARK: - ChatMessage Model
struct ChatMessage: Identifiable, Codable {
    let id: String
    let productId: String
    let userId: String
    let senderType: SenderType
    let message: String
    let timestamp: Date
    var isRead: Bool

    enum SenderType: String, Codable {
        case user = "user"
        case support = "support"
    }

    init(
        id: String = UUID().uuidString,
        productId: String,
        userId: String,
        senderType: SenderType,
        message: String,
        timestamp: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.productId = productId
        self.userId = userId
        self.senderType = senderType
        self.message = message
        self.timestamp = timestamp
        self.isRead = isRead
    }

    // Decoder tolerante: si "isRead" no viene en el JSON, usa false en vez de fallar
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        productId = try container.decode(String.self, forKey: .productId)
        userId = try container.decode(String.self, forKey: .userId)
        senderType = try container.decode(SenderType.self, forKey: .senderType)
        message = try container.decode(String.self, forKey: .message)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead) ?? false
    }
}

// MARK: - ChatSession Model
struct ChatSession: Identifiable, Codable {
    let id: String
    let productId: String
    let productName: String
    let userId: String
    let createdAt: Date
    var messages: [ChatMessage]
    let isActive: Bool

    init(
        id: String = UUID().uuidString,
        productId: String,
        productName: String,
        userId: String,
        createdAt: Date = Date(),
        messages: [ChatMessage] = [],
        isActive: Bool = true
    ) {
        self.id = id
        self.productId = productId
        self.productName = productName
        self.userId = userId
        self.createdAt = createdAt
        self.messages = messages
        self.isActive = isActive
    }
}
