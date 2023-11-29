import UIKit

class ModuleKit {

    static func image(named: String) -> UIImage? {
        UIImage(named: named)
    }

}

//extension String {
//
//    var localized: String {
//        LanguageManager.shared.localize(string: self, bundle: ModuleKit.bundle)
//    }
//
//    func localized(_ arguments: CVarArg...) -> String {
//        LanguageManager.shared.localize(string: self, bundle: ModuleKit.bundle, arguments: arguments)
//    }
//
//}
