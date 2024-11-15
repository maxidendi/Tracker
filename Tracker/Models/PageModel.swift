//
//  PageModel.swift
//  Tracker
//
//  Created by Денис Максимов on 15.11.2024.
//

import UIKit

enum PageModel {
    case firstPage
    case secondPage
    
    var image: UIImage {
        switch self {
        case .firstPage: return .onboardingFirstPage
        case .secondPage: return .onboardingSecondPage
        }
    }
    var text: String {
        switch self {
        case .firstPage: return "Отслеживайте только то, что хотите"
        case .secondPage: return "Даже если это не литры воды и йога"
        }
    }
}
