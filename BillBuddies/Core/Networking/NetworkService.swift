import Foundation
import os

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
    private let logger = Logger.network

    init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [AuthenticationNetworkInterceptor.self]
        self.session = URLSession(configuration: config)
    }

    func request<T: Decodable>(_ request: URLRequest) async -> NetworkResult<T> {
        let correlationID = UUID().uuidString
        let start = Date()

        logRequest(request, correlationID: correlationID)

        do {
            let (data, response) = try await session.data(for: request)

            let durationMs = Int(Date().timeIntervalSince(start) * 1000)
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("[\(correlationID)] No HTTPURLResponse (duration: \(durationMs, privacy: .public) ms)")
                return .failure(.noData)
            }

            logResponse(response: httpResponse, data: data, correlationID: correlationID, durationMs: durationMs)

            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                return decodeResponse(data: data, correlationID: correlationID)

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
            logNetworkError(error, correlationID: correlationID, request: request, since: start)
            return .failure(.networkError(error))
        }
    }

    // MARK: - Private Helpers

    private func decodeResponse<T: Decodable>(data: Data, correlationID: String) -> NetworkResult<T> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            logger.error("[\(correlationID)] Decoding error: \(error.localizedDescription, privacy: .public)")
            if let pretty = prettyPrintedJSONString(from: data) {
                logger.debug("[\(correlationID)] Decoding payload: \(pretty, privacy: .public)")
            } else if !data.isEmpty {
                logger.debug("[\(correlationID)] Decoding payload (raw bytes): \(data.count, privacy: .public) bytes")
            }
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

    // MARK: - Logging

    private func logRequest(_ request: URLRequest, correlationID: String) {
        let method = request.httpMethod ?? "UNKNOWN"
        let urlString = request.url?.absoluteString ?? "Unknown URL"
        let timeout = request.timeoutInterval
        let cachePolicy = String(describing: request.cachePolicy)

        logger.log("[\(correlationID)] → Request \(method, privacy: .public) \(urlString, privacy: .public)")
        logger.debug("[\(correlationID)] Request timeout: \(timeout, privacy: .public)s, cachePolicy: \(cachePolicy, privacy: .public)")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            logger.debug("[\(correlationID)] Headers: \(self.redactedHeaders(headers), privacy: .public)")
        } else {
            logger.debug("[\(correlationID)] Headers: none")
        }

        if let body = request.httpBody, !body.isEmpty {
            if let pretty = prettyPrintedJSONString(from: body) {
                logger.debug("[\(correlationID)] Body JSON: \(pretty, privacy: .public)")
            } else {
                logger.debug("[\(correlationID)] Body: \(body.count, privacy: .public) bytes")
            }
        } else {
            logger.debug("[\(correlationID)] Body: none")
        }
    }

    private func logResponse(response: HTTPURLResponse, data: Data, correlationID: String, durationMs: Int) {
        let urlString = response.url?.absoluteString ?? "Unknown URL"
        logger.log("[\(correlationID)] ← Response \(response.statusCode, privacy: .public) \(urlString, privacy: .public) (\(durationMs, privacy: .public) ms, \(data.count, privacy: .public) bytes)")

        if !response.allHeaderFields.isEmpty {
            let headers = response.allHeaderFields.reduce(into: [String: String]()) { dict, pair in
                if let key = pair.key as? String, let value = pair.value as? CustomStringConvertible {
                    dict[key] = String(describing: value)
                }
            }
            logger.debug("[\(correlationID)] Response headers: \(self.redactedHeaders(headers), privacy: .public)")
        } else {
            logger.debug("[\(correlationID)] Response headers: none")
        }

        if !data.isEmpty {
            if let pretty = prettyPrintedJSONString(from: data) {
                logger.debug("[\(correlationID)] Response JSON: \(pretty, privacy: .public)")
            } else if let text = String(data: data, encoding: .utf8), text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                logger.debug("[\(correlationID)] Response text: \(text, privacy: .public)")
            } else {
                logger.debug("[\(correlationID)] Response body: \(data.count, privacy: .public) bytes (non-text)")
            }
        } else {
            logger.debug("[\(correlationID)] Response body: none")
        }
    }

    private func logNetworkError(_ error: Error, correlationID: String, request: URLRequest, since start: Date) {
        let durationMs = Int(Date().timeIntervalSince(start) * 1000)
        let urlString = request.url?.absoluteString ?? "Unknown URL"
        logger.error("[\(correlationID)] ✕ Network error after \(durationMs, privacy: .public) ms for \(urlString, privacy: .public): \(error.localizedDescription, privacy: .public)")

        let nsError = error as NSError
        logger.debug("[\(correlationID)] Error domain: \(nsError.domain, privacy: .public), code: \(nsError.code, privacy: .public)")
        if let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            logger.debug("[\(correlationID)] Underlying: \(underlying.domain, privacy: .public) (\(underlying.code, privacy: .public)) - \(underlying.localizedDescription, privacy: .public)")
        }
    }

    private func redactedHeaders(_ headers: [String: String]) -> String {
        var safe = headers
        for key in headers.keys {
            if key.caseInsensitiveCompare("Authorization") == .orderedSame ||
                key.caseInsensitiveCompare("Cookie") == .orderedSame ||
                key.lowercased().contains("token") {
                safe[key] = "REDACTED"
            }
        }
        return safe.map { "\($0): \($1)" }
            .sorted()
            .joined(separator: ", ")
    }

    private func prettyPrintedJSONString(from data: Data) -> String? {
        guard !data.isEmpty else { return nil }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              JSONSerialization.isValidJSONObject(object) || object is [Any] || object is [String: Any] else {
            // Try to print if it's at least UTF-8 text
            if let text = String(data: data, encoding: .utf8) {
                return text
            }
            return nil
        }
        let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes])
        return prettyData.flatMap { String(data: $0, encoding: .utf8) }
    }
}
