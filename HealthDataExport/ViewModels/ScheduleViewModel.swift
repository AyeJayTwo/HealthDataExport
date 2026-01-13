import Foundation
import SwiftUI

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published var schedule: Schedule
    @Published var notificationsEnabled = false

    private let schedulingService = SchedulingService.shared

    init() {
        self.schedule = Schedule.load()
        checkNotificationStatus()
    }

    func toggleSchedule() {
        schedule.isEnabled.toggle()
        saveAndUpdate()
    }

    func updateFrequency(_ frequency: ScheduleFrequency) {
        schedule.frequency = frequency
        saveAndUpdate()
    }

    func updateTime(_ time: Date) {
        schedule.time = time
        saveAndUpdate()
    }

    private func saveAndUpdate() {
        schedule.save()

        if schedule.isEnabled {
            schedulingService.scheduleBackgroundExport()
        } else {
            schedulingService.cancelScheduledExports()
        }
    }

    func requestNotificationPermission() async {
        let granted = await schedulingService.requestNotificationPermission()
        notificationsEnabled = granted

        if !granted {
            // If notifications not granted, disable schedule
            schedule.isEnabled = false
            saveAndUpdate()
        }
    }

    private func checkNotificationStatus() {
        Task {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            notificationsEnabled = settings.authorizationStatus == .authorized
        }
    }

    var nextScheduledDateString: String {
        if let nextDate = schedule.nextScheduledDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: nextDate)
        } else {
            return "Not scheduled"
        }
    }
}
