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
        UserDefaults.standard.set(data, forKey: key)
    }

    func retrive<T>(for key: String) -> T? {
        guard let value = UserDefaults.standard.string(forKey: key) else {
            return nil
        }
        return value as? T
    }

    func clear(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
