//
//  GeometricParams.swift
//  Tracker
//
//  Created by Денис Максимов on 02.10.2024.
//

import Foundation

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let topInset: CGFloat
    let bottomInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int,
         leftInset: CGFloat,
         rightInset: CGFloat,
         topInset: CGFloat,
         bottomInset: CGFloat,
         cellSpacing: CGFloat
    ) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + cellSpacing * CGFloat(cellCount - 1)
    }
}
