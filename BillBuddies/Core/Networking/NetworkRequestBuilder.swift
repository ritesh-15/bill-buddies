import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkResult<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int, String?)
    case networkError(Error)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingError(let error): return "Decoding failed: \(error.localizedDescription)"
        case .serverError(let code, let message): return "Server error \(code): \(message ?? "")"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .unauthorized: return "Unauthorized access"
        case .unknown: return "Unknown error occurred"
        }
    }
}

final class NetworkRequestBuilder {

    // MARK: - Properties

    private var baseURL: String

    private var path: String = ""
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var queryParameters: [String: Any] = [:]
    private var body: Data? = nil

    init(baseURL: String = "http://localhost/v1/api") {
        self.baseURL = baseURL
    }

    @discardableResult
    func setPath(path: String) -> NetworkRequestBuilder {
        self.path = path
        return self
    }

    @discardableResult
    func method(method: HTTPMethod) -> NetworkRequestBuilder {
        self.method = method
        return self
    }

    @discardableResult
    func addHeader(key: String, value: String) -> NetworkRequestBuilder {
        self.headers[key] = value
        return self
    }

    @discardableResult
    func addQuery(_ key: String, value: Any) -> NetworkRequestBuilder {
        queryParameters[key] = value
        return self
    }

    @discardableResult
    func addQuery(_ parameters: [String: Any]) -> NetworkRequestBuilder {
        queryParameters.merge(parameters) { _, new in new }
        return self
    }

    @discardableResult
    func setJSONBody<T: Encodable>(_ encodable: T) -> NetworkRequestBuilder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.body = try? encoder.encode(encodable)
        self.addHeader(key: "Content-Type", value: "application/json")
        return self
    }

    // MARK: - Strapi Specific

    @discardableResult
    func populate(_ fields: String...) -> NetworkRequestBuilder {
        let populateValue = fields.isEmpty ? "*" : fields.joined(separator: ",")
        queryParameters["populate"] = populateValue
        return self
    }

    @discardableResult
    func filter(_ key: String, value: Any) -> NetworkRequestBuilder {
        queryParameters["filters[\(key)]"] = value
        return self
    }

    @discardableResult
    func sort(_ field: String, ascending: Bool = true) -> NetworkRequestBuilder {
        queryParameters["sort"] = ascending ? field : "\(field):desc"
        return self
    }

    @discardableResult
    func pagination(page: Int, pageSize: Int) -> NetworkRequestBuilder {
        queryParameters["pagination[page]"] = page
        queryParameters["pagination[pageSize]"] = pageSize
        return self
    }

    // MARK: - Build

    func build() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        // Only set queryItems if there are any and only for GET
        if method == .get, !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        } else {
            components.queryItems = nil
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        return request
    }
}
