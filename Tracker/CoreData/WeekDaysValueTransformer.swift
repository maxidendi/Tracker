//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import Foundation

@objc
public final class WeekDaysValueTransformer: ValueTransformer {
    public override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    public override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDay].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekDaysValueTransformer(),
            forName: NSValueTransformerName(String(describing: WeekDaysValueTransformer.self)))
    }
}
