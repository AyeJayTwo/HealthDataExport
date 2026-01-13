import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var showingHealthKitInfo = false

    var body: some View {
        NavigationView {
            Form {
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Health Data") {
                    HStack {
                        Text("HealthKit Status")
                        Spacer()
                        if HealthKitManager.isHealthKitAvailable {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Available")
                                .foregroundColor(.secondary)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Unavailable")
                                .foregroundColor(.secondary)
                        }
                    }

                    Button("Manage Health Permissions") {
                        if let url = URL(string: "x-apple-health://") {
                            UIApplication.shared.open(url)
                        }
                    }

                    Button("About HealthKit") {
                        showingHealthKitInfo = true
                    }
                }

                Section("Data & Privacy") {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(
                            icon: "lock.shield.fill",
                            title: "Local Processing",
                            description: "All health data is processed locally on your device."
                        )

                        InfoRow(
                            icon: "icloud.slash.fill",
                            title: "No Cloud Upload",
                            description: "Your health data is never transmitted to external servers without your explicit action."
                        )

                        InfoRow(
                            icon: "doc.text.fill",
                            title: "You Control Sharing",
                            description: "Exported files are saved locally. You decide when and where to share them."
                        )
                    }
                }

                Section("Storage") {
                    NavigationLink("Manage Exported Files") {
                        ExportedFilesView()
                    }

                    Button("Open Documents Folder") {
                        openDocumentsFolder()
                    }
                }

                Section("Support") {
                    Link("GitHub Repository", destination: URL(string: "https://github.com/AyeJayTwo/HealthDataExport")!)

                    Link("Report an Issue", destination: URL(string: "https://github.com/AyeJayTwo/HealthDataExport/issues")!)
                }

                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("HealthDataExport")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Built with Claude Code")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingHealthKitInfo) {
                HealthKitInfoView()
            }
        }
    }

    private func openDocumentsFolder() {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        // This will open Files app but won't navigate directly to the folder
        // iOS doesn't provide a direct way to open a specific folder
        if let url = URL(string: "shareddocuments://") {
            UIApplication.shared.open(url)
        }
    }
}

struct ExportedFilesView: View {
    @StateObject private var viewModel: ExportViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ExportViewModel(healthKitManager: HealthKitManager()))
    }

    var body: some View {
        List {
            if viewModel.exportedFiles.isEmpty {
                Text("No exported files yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.exportedFiles) { file in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(file.filename)
                            .font(.subheadline)
                        HStack {
                            Text(file.formattedDate)
                            Text("•")
                            Text(file.formattedSize)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteFile(file)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.shareFile(file)
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .navigationTitle("Exported Files")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let url = viewModel.exportedFileURL {
                ShareSheet(items: [url])
            }
        }
        .onAppear {
            viewModel.loadExportedFiles()
        }
    }
}

struct HealthKitInfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What is HealthKit?")
                            .font(.headline)

                        Text("HealthKit is Apple's framework for managing and accessing health and fitness data. It provides a secure, centralized repository for health information from various sources including the Health app, fitness trackers, and other health apps.")
                            .font(.body)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("How This App Uses HealthKit")
                            .font(.headline)

                        Text("HealthDataExport requests read-only access to specific health metrics you choose. The app queries this data locally on your device and formats it into readable markdown files. No data leaves your device without your explicit action.")
                            .font(.body)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Permissions")
                            .font(.headline)

                        Text("You control which health data this app can access. You can modify permissions at any time through the Health app or iOS Settings. The app only requests access to the metrics it supports: Steps, Heart Rate, Sleep, Active Energy, Exercise Time, Weight, and BMI.")
                            .font(.body)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy")
                            .font(.headline)

                        Text("Your health data is private and sensitive. This app processes all data locally and does not transmit it to any servers. Exported files are saved to your device's Documents folder, and you have complete control over when and how they're shared.")
                            .font(.body)
                    }
                }
                .padding()
            }
            .navigationTitle("About HealthKit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(HealthKitManager())
}
