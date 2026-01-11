// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dTOGroups = try DTOGroups(json)

import Foundation

// MARK: - DTOGroups
struct DTOGroups: Codable {
    let data: [DTODatum]
    let meta: DTOMeta
}

// MARK: DTOGroups convenience initializers and mutators

extension DTOGroups {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DTOGroups.self, from: data)
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
        data: [DTODatum]? = nil,
        meta: DTOMeta? = nil
    ) -> DTOGroups {
        return DTOGroups(
            data: data ?? self.data,
            meta: meta ?? self.meta
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DTODatum
struct DTODatum: Codable {
    let id: Int
    let documentId, name, description, category: String
    let simplifyDebts: Bool
    let createdAt, updatedAt, publishedAt: String
    let creator: DTOCreator
    let members: [DTOCreator]
}

// MARK: DTODatum convenience initializers and mutators

extension DTODatum {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DTODatum.self, from: data)
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
        documentId: String? = nil,
        name: String? = nil,
        description: String? = nil,
        category: String? = nil,
        simplifyDebts: Bool? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        publishedAt: String? = nil,
        creator: DTOCreator? = nil,
        members: [DTOCreator]? = nil
    ) -> DTODatum {
        return DTODatum(
            id: id ?? self.id,
            documentId: documentId ?? self.documentId,
            name: name ?? self.name,
            description: description ?? self.description,
            category: category ?? self.category,
            simplifyDebts: simplifyDebts ?? self.simplifyDebts,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            publishedAt: publishedAt ?? self.publishedAt,
            creator: creator ?? self.creator,
            members: members ?? self.members
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DTOCreator
struct DTOCreator: Codable {
    let id: Int
    let documentId, username: String
}

// MARK: DTOCreator convenience initializers and mutators

extension DTOCreator {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DTOCreator.self, from: data)
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
        documentId: String? = nil,
        username: String? = nil
    ) -> DTOCreator {
        return DTOCreator(
            id: id ?? self.id,
            documentId: documentId ?? self.documentId,
            username: username ?? self.username
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DTOMeta
struct DTOMeta: Codable {
    let pagination: DTOPagination
}

// MARK: DTOMeta convenience initializers and mutators

extension DTOMeta {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DTOMeta.self, from: data)
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
        pagination: DTOPagination? = nil
    ) -> DTOMeta {
        return DTOMeta(
            pagination: pagination ?? self.pagination
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DTOPagination
struct DTOPagination: Codable {
    let page, pageSize, pageCount, total: Int
}

// MARK: DTOPagination convenience initializers and mutators

extension DTOPagination {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DTOPagination.self, from: data)
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
        page: Int? = nil,
        pageSize: Int? = nil,
        pageCount: Int? = nil,
        total: Int? = nil
    ) -> DTOPagination {
        return DTOPagination(
            page: page ?? self.page,
            pageSize: pageSize ?? self.pageSize,
            pageCount: pageCount ?? self.pageCount,
            total: total ?? self.total
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
