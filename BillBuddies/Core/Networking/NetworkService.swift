import Foundation

// MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ request: URLRequest) async -> NetworkResult<T>
}

// MARK: - Network Service Implementation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
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
