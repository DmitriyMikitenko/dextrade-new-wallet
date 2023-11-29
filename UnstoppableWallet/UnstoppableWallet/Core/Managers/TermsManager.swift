import Combine
import HsExtensions


class TermsManager {
    private let keyTermsAccepted = "key_terms_accepted"
    private let storage: ILocalStorage

    @DistinctPublished var termsAccepted: Bool

    init(storage: ILocalStorage) {
        self.storage = storage

        termsAccepted = storage.value(for: keyTermsAccepted) ?? false
    }
}

extension TermsManager {
    func setTermsAccepted() {
        storage.set(value: true, for: keyTermsAccepted)
        termsAccepted = true
    }
}
