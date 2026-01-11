import Foundation

// MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ request: URLRequest) async -> NetworkResult<T>
}

// MARK: - AuthenticationNetworkInterceptor

final class AuthenticationNetworkInterceptor: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        var mutableRequest = request

        // Infer generic type from the variable type, and handle optional safely
        let accessToken: String? = DependencyContainer.shared.keychainStorage.retrive(for: KeychainStorage.accessToken)

        if let token = accessToken, !token.isEmpty {
            // Prefer standard Authorization header with Bearer scheme
            mutableRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Proceed with the modified request
        let task = URLSession.shared.dataTask(with: mutableRequest) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }

    override func stopLoading() {
        // No-op
    }
}

// MARK: - Network Service Implementation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [AuthenticationNetworkInterceptor.self]
        self.session = URLSession(configuration: config)
    }

    func request<T: Decodable>(_ request: URLRequest) async -> NetworkResult<T> {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.noData)
            }

            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                return decodeResponse(data: data)

            case 401:
                return .failure(.unauthorized)

            case 400...499:
                let errorMessage = parseErrorMessage(from: data)
                return .failure(.serverError(httpResponse.statusCode, errorMessage))

            case 500...599:
                let errorMessage = parseErrorMessage(from: data)
                return .failure(.serverError(httpResponse.statusCode, errorMessage))

            default:
                return .failure(.unknown)
            }

        } catch {
            return .failure(.networkError(error))
        }
    }

    // MARK: - Private Helpers

    private func decodeResponse<T: Decodable>(data: Data) -> NetworkResult<T> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingError(error))
        }
    }

    private func parseErrorMessage(from data: Data) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            // Try different common error message keys
            if let message = json["message"] as? String {
                return message
            }
            if let error = json["error"] as? [String: Any],
               let message = error["message"] as? String {
                return message
            }
        }
        return nil
    }
}
