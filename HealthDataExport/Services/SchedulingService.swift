import Foundation
import BackgroundTasks
import UserNotifications

class SchedulingService {
    static let shared = SchedulingService()
    static let backgroundTaskIdentifier = "com.ayejaytwo.HealthDataExport.refresh"

    private let healthKitManager: HealthKitManager
    private let exportEngine: ExportEngine

    private init() {
        self.healthKitManager = HealthKitManager()
        self.exportEngine = ExportEngine(healthKitManager: healthKitManager)
    }

    // Register background task handler
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.backgroundTaskIdentifier,
            using: nil
        ) { task in
            self.handleBackgroundExport(task: task as! BGAppRefreshTask)
        }
    }

    // Schedule next background export
    func scheduleBackgroundExport() {
        let schedule = Schedule.load()

        guard schedule.isEnabled, let nextDate = schedule.nextScheduledDate else {
            // Cancel any existing scheduled tasks
            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.backgroundTaskIdentifier)
            return
        }

        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundTaskIdentifier)
        request.earliestBeginDate = nextDate

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background task scheduled for: \(nextDate)")
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }

    // Handle background export task
    private func handleBackgroundExport(task: BGAppRefreshTask) {
        // Schedule the next task
        scheduleBackgroundExport()

        task.expirationHandler = {
            // Clean up if task expires
            task.setTaskCompleted(success: false)
        }

        // Perform the export
        Task {
            do {
                // Load preferences
                let preferences = ExportPreferences.load()

                // Use yesterday's date for scheduled exports
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                let dates = [yesterday]

                // Export data
                let fileURL = try await exportEngine.exportData(
                    metrics: preferences.selectedMetrics,
                    dates: dates
                )

                // Send notification
                await sendNotification(filename: fileURL.lastPathComponent)

                task.setTaskCompleted(success: true)
            } catch {
                print("Background export failed: \(error)")
                task.setTaskCompleted(success: false)
            }
        }
    }

    // Request notification permissions
    func requestNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    // Send local notification when export completes
    private func sendNotification(filename: String) async {
        let content = UNMutableNotificationContent()
        content.title = "Health Data Exported"
        content.body = "Your scheduled health data export has been created: \(filename)"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Deliver immediately
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Error sending notification: \(error)")
        }
    }

    // Cancel scheduled exports
    func cancelScheduledExports() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.backgroundTaskIdentifier)
    }
}
