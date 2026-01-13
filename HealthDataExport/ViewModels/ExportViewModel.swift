import Foundation
import SwiftUI

@MainActor
class ExportViewModel: ObservableObject {
    @Published var selectedMetrics: Set<HealthMetricType>
    @Published var selectedDates: Set<Date>
    @Published var isExporting = false
    @Published var showShareSheet = false
    @Published var exportedFileURL: URL?
    @Published var errorMessage: String?
    @Published var exportedFiles: [ExportedFile] = []

    private let healthKitManager: HealthKitManager
    private let exportEngine: ExportEngine

    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
        self.exportEngine = ExportEngine(healthKitManager: healthKitManager)

        // Load saved preferences
        let preferences = ExportPreferences.load()
        self.selectedMetrics = preferences.selectedMetrics
        self.selectedDates = Set(preferences.selectedDates)

        // Load existing exported files
        loadExportedFiles()
    }

    func toggleMetric(_ metric: HealthMetricType) {
        if selectedMetrics.contains(metric) {
            selectedMetrics.remove(metric)
        } else {
            selectedMetrics.insert(metric)
        }
        savePreferences()
    }

    func toggleDate(_ date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)

        if selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: normalizedDate) }) {
            selectedDates.removeAll { calendar.isDate($0, inSameDayAs: normalizedDate) }
        } else {
            selectedDates.insert(normalizedDate)
        }
        savePreferences()
    }

    func setYesterday() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let normalizedYesterday = Calendar.current.startOfDay(for: yesterday)
        selectedDates = [normalizedYesterday]
        savePreferences()
    }

    func isDateSelected(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        return selectedDates.contains { calendar.isDate($0, inSameDayAs: normalizedDate) }
    }

    private func savePreferences() {
        let preferences = ExportPreferences(
            selectedMetrics: selectedMetrics,
            selectedDates: Array(selectedDates)
        )
        preferences.save()
    }

    func exportData() async {
        guard !selectedMetrics.isEmpty else {
            errorMessage = "Please select at least one metric to export"
            return
        }

        guard !selectedDates.isEmpty else {
            errorMessage = "Please select at least one date"
            return
        }

        isExporting = true
        errorMessage = nil

        do {
            let sortedDates = selectedDates.sorted()
            let fileURL = try await exportEngine.exportData(
                metrics: selectedMetrics,
                dates: sortedDates
            )

            exportedFileURL = fileURL
            showShareSheet = true
            loadExportedFiles()
        } catch {
            errorMessage = "Export failed: \(error.localizedDescription)"
        }

        isExporting = false
    }

    func loadExportedFiles() {
        exportedFiles = exportEngine.getExportedFiles()
    }

    func deleteFile(_ file: ExportedFile) {
        do {
            try exportEngine.deleteFile(at: file.url)
            loadExportedFiles()
        } catch {
            errorMessage = "Failed to delete file: \(error.localizedDescription)"
        }
    }

    func shareFile(_ file: ExportedFile) {
        exportedFileURL = file.url
        showShareSheet = true
    }
}
