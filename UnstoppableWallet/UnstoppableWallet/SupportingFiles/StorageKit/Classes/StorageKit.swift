import UIKit

class StorageKit {

    static func image(named: String) -> UIImage? {
        UIImage(named: named)
    }

}

public enum PasscodeLockState {
    case passcodeSet
    case passcodeNotSet
    case unknown
}

public class KitLocalStorage {

    public static var `default`: ILocalStorage {
        userDefaults
    }

    public static let userDefaults: ILocalStorage = UserDefaultsStorage()

}

public protocol ILocalStorage {
    func value<T>(for key: String) -> T?
    func set<T>(value: T?, for key: String)
}

public protocol ISecureStorage {
    func value<T: LosslessStringConvertible>(for key: String) -> T?
    func set<T: LosslessStringConvertible>(value: T?, for key: String) throws
    func value(for key: String) -> Data?
    func set(value: Data?, for key: String) throws
    func removeValue(for key: String) throws
}

public protocol IKeychainKit {
    var secureStorage: ISecureStorage { get }
    var passcodeLockState: PasscodeLockState { get }
    func set(delegate: IKeychainKitDelegate?)
    func handleLaunch()
    func handleForeground()
}

public protocol IKeychainKitDelegate: AnyObject {
    func onSecureStorageInvalidation()
    func onPasscodeSet()
    func onPasscodeNotSet()
    func onCannotCheckPasscode()
}
