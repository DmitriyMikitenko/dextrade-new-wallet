import Foundation
import MarketKit

struct CexAsset {
    let id: String
    let name: String
    let freeBalance: Decimal
    let lockedBalance: Decimal
    let depositEnabled: Bool
    let withdrawEnabled: Bool
    let networks: [CexNetwork]
    let coin: Coin?
}

extension CexAsset: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: CexAsset, rhs: CexAsset) -> Bool {
        lhs.id == rhs.id && lhs.freeBalance == rhs.freeBalance && lhs.lockedBalance == rhs.lockedBalance && lhs.networks == rhs.networks && lhs.coin == rhs.coin
    }

}
