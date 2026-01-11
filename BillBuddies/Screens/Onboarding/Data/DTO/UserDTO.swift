import Foundation

struct UserDTO: Codable {
    let id: Int
    let documentID, username, email, provider: String
    let confirmed, blocked: Bool
    let createdAt, updatedAt, publishedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case documentID = "documentId"
        case username, email, provider, confirmed, blocked, createdAt, updatedAt, publishedAt
    }
}

// MARK: User convenience initializers and mutators

extension UserDTO {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserDTO.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        documentID: String? = nil,
        username: String? = nil,
        email: String? = nil,
        provider: String? = nil,
        confirmed: Bool? = nil,
        blocked: Bool? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        publishedAt: String? = nil
    ) -> UserDTO {
        return UserDTO(
            id: id ?? self.id,
            documentID: documentID ?? self.documentID,
            username: username ?? self.username,
            email: email ?? self.email,
            provider: provider ?? self.provider,
            confirmed: confirmed ?? self.confirmed,
            blocked: blocked ?? self.blocked,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            publishedAt: publishedAt ?? self.publishedAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
