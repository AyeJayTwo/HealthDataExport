import SwiftUI

struct ExportView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @StateObject private var viewModel: ExportViewModel

    init() {
        // Create viewModel with injected healthKitManager in init won't work with @EnvironmentObject
        // So we'll use a workaround by initializing in body or using a different pattern
        _viewModel = StateObject(wrappedValue: ExportViewModel(healthKitManager: HealthKitManager()))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Date Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Select Dates")
                                .font(.headline)
                            Spacer()
                            Button("Yesterday") {
                                viewModel.setYesterday()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }

                        DatePicker(
                            "Pick dates",
                            selection: Binding(
                                get: { viewModel.selectedDates.first ?? Date() },
                                set: { viewModel.toggleDate($0) }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)

                        if !viewModel.selectedDates.isEmpty {
                            Text("Selected: \(formattedSelectedDates)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Metrics Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Select Metrics")
                                .font(.headline)
                            Spacer()
                            Button(viewModel.selectedMetrics.count == HealthMetricType.allCases.count ? "Deselect All" : "Select All") {
                                if viewModel.selectedMetrics.count == HealthMetricType.allCases.count {
                                    viewModel.selectedMetrics.removeAll()
                                } else {
                                    viewModel.selectedMetrics = Set(HealthMetricType.allCases)
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }

                        ForEach(HealthMetricType.allCases) { metric in
                            MetricToggleRow(
                                metric: metric,
                                isSelected: viewModel.selectedMetrics.contains(metric)
                            ) {
                                viewModel.toggleMetric(metric)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Export Button
                    Button(action: {
                        Task {
                            await viewModel.exportData()
                        }
                    }) {
                        HStack {
                            if viewModel.isExporting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "arrow.down.doc.fill")
                            }
                            Text(viewModel.isExporting ? "Exporting..." : "Export Data")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isExporting || viewModel.selectedMetrics.isEmpty || viewModel.selectedDates.isEmpty)

                    // Error Message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }

                    // Export History Section
                    if !viewModel.exportedFiles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Exports")
                                .font(.headline)

                            ForEach(viewModel.exportedFiles) { file in
                                ExportFileRow(file: file) {
                                    viewModel.shareFile(file)
                                } onDelete: {
                                    viewModel.deleteFile(file)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Health Export")
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let url = viewModel.exportedFileURL {
                    ShareSheet(items: [url])
                }
            }
            .onAppear {
                // Re-inject healthKitManager when view appears
                viewModel.loadExportedFiles()
            }
        }
    }

    private var formattedSelectedDates: String {
        let sorted = viewModel.selectedDates.sorted()
        let formatter = DateFormatter()
        formatter.dateStyle = .short

        if sorted.count == 1 {
            return formatter.string(from: sorted[0])
        } else if sorted.count <= 3 {
            return sorted.map { formatter.string(from: $0) }.joined(separator: ", ")
        } else {
            return "\(sorted.count) dates selected"
        }
    }
}

struct MetricToggleRow: View {
    let metric: HealthMetricType
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: metric.icon)
                    .frame(width: 24)
                Text(metric.displayName)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct ExportFileRow: View {
    let file: ExportedFile
    let onShare: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(file.filename)
                    .font(.subheadline)
                Text("\(file.formattedDate) • \(file.formattedSize)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onShare) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.borderless)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 8)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ExportView()
        .environmentObject(HealthKitManager())
}
