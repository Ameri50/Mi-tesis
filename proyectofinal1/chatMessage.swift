import Foundation

// MARK: - ChatMessage Model
struct ChatMessage: Identifiable, Codable {
    let id: String
    let productId: String
    let userId: String
    let senderType: SenderType
    let message: String
    let timestamp: Date
    let isRead: Bool

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

    enum CodingKeys: String, CodingKey {
        case id, productId, userId, senderType, message, timestamp, isRead
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.senderType = try container.decode(SenderType.self, forKey: .senderType)
        self.message = try container.decode(String.self, forKey: .message)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(productId, forKey: .productId)
        try container.encode(userId, forKey: .userId)
        try container.encode(senderType, forKey: .senderType)
        try container.encode(message, forKey: .message)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(isRead, forKey: .isRead)
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

    enum CodingKeys: String, CodingKey {
        case id, productId, productName, userId, createdAt, messages, isActive
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.messages = try container.decode([ChatMessage].self, forKey: .messages)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(productId, forKey: .productId)
        try container.encode(productName, forKey: .productName)
        try container.encode(userId, forKey: .userId)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(messages, forKey: .messages)
        try container.encode(isActive, forKey: .isActive)
    }
}
