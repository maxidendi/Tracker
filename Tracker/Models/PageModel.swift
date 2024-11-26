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
        case .firstPage: return Constants.OnboardingPages.firstPageTitle
        case .secondPage: return Constants.OnboardingPages.secondPageTitle
        }
    }
}
