import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager

    var body: some View {
        TabView {
            ExportView()
                .tabItem {
                    Label("Export", systemImage: "arrow.down.doc.fill")
                }

            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager())
}
