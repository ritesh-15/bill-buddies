import Foundation

protocol AuthRepositoryProtocol: AnyObject {

    func register(data: RegistrationModel) async throws
}

final class AuthRepository: AuthRepositoryProtocol {

    func register(data: RegistrationModel) async throws {
        let request = try NetworkRequestBuilder()
            .method(method: .post)
            .setPath(path: "/auth/local/register")
            .addHeader(key: "Content-Type", value: "application/json")
            .setJSONBody(data)
            .build()

        let (data, response) = try await URLSession.shared.data(for: request)

        print("[DEBUG] data: \(String(describing: request))")
        print("[DEBUG] response: \(String(describing: response))")
    }
}
