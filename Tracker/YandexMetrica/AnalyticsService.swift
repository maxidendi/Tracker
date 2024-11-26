import Foundation
import AppMetricaCore

final class AnalyticsService {
    
    //MARK: - Init
    
    private init() {}
    
    //MARK: - Properties
    
    static let shared = AnalyticsService()
    private let apiKey = "45aeb444-bf2c-40c5-bd7c-c880fdff7e71"
    
    //MARK: - Methods
    
    func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: apiKey) else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func trackEvent(event: AnalyticsEvents, parameters: [AnyHashable : Any]) {
        guard let reporter = AppMetrica.reporter(for: AnalyticsService.shared.apiKey) else {
            print("Failed to get reporter")
            return
        }
        reporter.resumeSession()
        reporter.reportEvent(name: event.rawValue, parameters: parameters, onFailure: { error in
            print("Failed to report event: \(error.localizedDescription)")
        })
        reporter.pauseSession()
        print("Event reported: \(event.rawValue)\nParameters: \(parameters)")
    }
}
