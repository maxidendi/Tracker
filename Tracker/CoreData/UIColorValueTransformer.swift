//
//  UIColorValueTransformer.swift
//  Tracker
//
//  Created by Денис Максимов on 25.10.2024.
//

import UIKit

@objc
public final class UIColorValueTransformer: NSSecureUnarchiveFromDataTransformer {
    public override class func transformedValueClass() -> AnyClass {
        UIColor.self
    }
    
    public override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            UIColorValueTransformer(),
            forName: NSValueTransformerName(String(describing: UIColorValueTransformer.self)))
    }
}
