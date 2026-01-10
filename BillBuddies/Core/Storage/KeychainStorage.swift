import Foundation

protocol KeychainStorageProtocol: AnyObject {

    func save<T>(with key: String, data: T)

    func retrive<T>(for key: String) -> T?

    func clear(for key: String)
}

final class KeychainStorage: KeychainStorageProtocol {

    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
    static let me = "me"

    func save<T>(with key: String, data: T) {
        switch data {
        case let string as String:
            UserDefaults.standard.set(string, forKey: key)
        case let data as Data:
            UserDefaults.standard.set(data, forKey: key)
        default:
            // No-op
            print("[DEBUG] KeychainStorage:unknown field")
        }
    }

    func retrive<T>(for key: String) -> T? {
        // Try to return as String
        if T.self == String.self, let string = UserDefaults.standard.string(forKey: key) {
            return string as? T
        }

        // Try to return as Data
        if T.self == Data.self, let data = UserDefaults.standard.data(forKey: key) {
            return data as? T
        }

        return nil
    }

    func clear(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
