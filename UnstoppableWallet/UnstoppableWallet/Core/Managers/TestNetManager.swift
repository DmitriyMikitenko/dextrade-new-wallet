import Foundation
import HsExtensions


class TestNetManager {
    private let keyTestNetEnabled = "test-net-enabled"

    private let localStorage: ILocalStorage

    @PostPublished private(set) var testNetEnabled: Bool

    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage

        testNetEnabled = localStorage.value(for: keyTestNetEnabled) ?? false
    }

}

extension TestNetManager {

    func set(testNetEnabled: Bool) {
        self.testNetEnabled = testNetEnabled
        localStorage.set(value: testNetEnabled, for: keyTestNetEnabled)
    }

}
