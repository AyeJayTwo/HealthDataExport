import SwiftUI

@main
struct HealthDataExportApp: App {
    @StateObject private var healthKitManager = HealthKitManager()

    init() {
        // Register background task handler
        SchedulingService.shared.registerBackgroundTask()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
                .onAppear {
                    // Request HealthKit authorization on first launch
                    Task {
                        if HealthKitManager.isHealthKitAvailable {
                            try? await healthKitManager.requestAuthorization()
                        }
                    }
                }
        }
    }
}
