import UIKit

extension UIColor {
    
    var codedString: String {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        return data?.base64EncodedString() ?? ""
    }
    
    static func fromCodedString(_ string: String) -> UIColor {
        guard let data = Data(base64Encoded: string),
              let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        else { return UIColor.white }
        return color
    }
}

