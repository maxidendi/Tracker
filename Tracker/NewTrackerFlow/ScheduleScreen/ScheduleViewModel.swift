import Foundation

protocol ScheduleViewModelProtocol {
    var onScheduleIsEmpty: ((Bool) -> Void)? { get set }
    var delegate: ScheduleViewModelDelegate? { get set }
    func isScheduleEmpty() -> Bool
    func insertWeekday(tag: Int)
    func removeWeekday(tag: Int)
    func isWeekdayAdded(tag: Int) -> Bool
    func doneButtonTapped()
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    //MARK: - Init
    
    init(schedule: Set<WeekDay>) {
        self.schedule = schedule
    }
    
    //MARK: - Properties
    
    weak var delegate: ScheduleViewModelDelegate?
    private var schedule: Set<WeekDay> = [] {
        didSet {
            if schedule.isEmpty {
                onScheduleIsEmpty?(true)
            } else {
                onScheduleIsEmpty?(false)
            }
        }
    }
    var onScheduleIsEmpty: ((Bool) -> Void)?

    //MARK: - Methods
    
    func isScheduleEmpty() -> Bool {
        schedule.isEmpty
    }
    
    func insertWeekday(tag: Int) {
        schedule.insert(WeekDay.allCases[tag])
    }
    
    func removeWeekday(tag: Int) {
        schedule.remove(WeekDay.allCases[tag])
    }
    
    func isWeekdayAdded(tag: Int) -> Bool {
        schedule.contains(WeekDay.allCases[tag])
    }
    
    func doneButtonTapped() {
        delegate?.didRecieveSchedule(schedule)
    }
}
