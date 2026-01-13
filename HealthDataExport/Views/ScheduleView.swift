import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var showingPermissionAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Scheduled Exports", isOn: Binding(
                        get: { viewModel.schedule.isEnabled },
                        set: { newValue in
                            if newValue && !viewModel.notificationsEnabled {
                                showingPermissionAlert = true
                            } else {
                                viewModel.toggleSchedule()
                            }
                        }
                    ))

                    if viewModel.schedule.isEnabled {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.accentColor)
                            Text("Next export:")
                            Spacer()
                            Text(viewModel.nextScheduledDateString)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Automatic Exports")
                } footer: {
                    if viewModel.schedule.isEnabled {
                        Text("Health data will be automatically exported based on your schedule. Exports will use your saved metric preferences.")
                    } else {
                        Text("Enable to automatically export your health data on a regular schedule.")
                    }
                }

                if viewModel.schedule.isEnabled {
                    Section("Schedule Configuration") {
                        Picker("Frequency", selection: Binding(
                            get: { viewModel.schedule.frequency },
                            set: { viewModel.updateFrequency($0) }
                        )) {
                            ForEach(ScheduleFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.displayName).tag(frequency)
                            }
                        }

                        DatePicker(
                            "Export Time",
                            selection: Binding(
                                get: { viewModel.schedule.time },
                                set: { viewModel.updateTime($0) }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

                Section {
                    HStack {
                        Image(systemName: viewModel.notificationsEnabled ? "bell.fill" : "bell.slash.fill")
                            .foregroundColor(viewModel.notificationsEnabled ? .accentColor : .secondary)
                        Text("Notifications")
                        Spacer()
                        Text(viewModel.notificationsEnabled ? "Enabled" : "Disabled")
                            .foregroundColor(.secondary)
                    }

                    if !viewModel.notificationsEnabled {
                        Button("Enable Notifications") {
                            Task {
                                await viewModel.requestNotificationPermission()
                            }
                        }
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Notifications are required to alert you when scheduled exports complete. You can manage notification settings in the Settings app.")
                }

                Section("How It Works") {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(
                            icon: "clock.fill",
                            title: "Background Processing",
                            description: "Exports run automatically in the background based on your schedule."
                        )

                        InfoRow(
                            icon: "doc.fill",
                            title: "Yesterday's Data",
                            description: "Scheduled exports include data from yesterday by default."
                        )

                        InfoRow(
                            icon: "folder.fill",
                            title: "Saved to Documents",
                            description: "Files are saved to your Documents folder and can be accessed via the Files app."
                        )
                    }
                }
            }
            .navigationTitle("Schedule")
            .alert("Notifications Required", isPresented: $showingPermissionAlert) {
                Button("Enable Notifications") {
                    Task {
                        await viewModel.requestNotificationPermission()
                        if viewModel.notificationsEnabled {
                            viewModel.toggleSchedule()
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Scheduled exports require notification permissions to alert you when exports complete. Would you like to enable notifications?")
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ScheduleView()
}
