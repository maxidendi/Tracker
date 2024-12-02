import Foundation

protocol ScheduleViewModelDelegate: AnyObject {
    func didRecieveSchedule(_ schedule: Set<WeekDay>)
}
