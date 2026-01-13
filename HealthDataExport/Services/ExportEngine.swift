import Foundation

class ExportEngine {
    private let healthKitManager: HealthKitManager

    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }

    // Main export function
    func exportData(
        metrics: Set<HealthMetricType>,
        dates: [Date]
    ) async throws -> URL {
        // Collect data for all requested metrics
        var summaries: [HealthDataSummary] = []

        for metricType in metrics.sorted(by: { $0.displayName < $1.displayName }) {
            let dataPoints = try await healthKitManager.queryDataForDates(
                for: metricType,
                dates: dates
            )
            let summary = healthKitManager.createSummary(from: dataPoints, for: metricType)
            summaries.append(summary)
        }

        // Generate markdown
        let markdown = MarkdownGenerator.generate(summaries: summaries, dates: dates)

        // Save to file
        let fileURL = try saveToFile(markdown: markdown, dates: dates)

        return fileURL
    }

    // Save markdown to Documents directory
    private func saveToFile(markdown: String, dates: [Date]) -> throws -> URL {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        let filename = generateFilename(for: dates)
        let fileURL = documentsPath.appendingPathComponent(filename)

        try markdown.write(to: fileURL, atomically: true, encoding: .utf8)

        return fileURL
    }

    // Generate filename based on dates
    private func generateFilename(for dates: [Date]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if dates.count == 1 {
            return "health-export-\(formatter.string(from: dates[0])).md"
        } else {
            let sorted = dates.sorted()
            let start = formatter.string(from: sorted.first!)
            let end = formatter.string(from: sorted.last!)
            return "health-export-\(start)-to-\(end).md"
        }
    }

    // Get list of previously exported files
    func getExportedFiles() -> [ExportedFile] {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: documentsPath,
                includingPropertiesForKeys: [.creationDateKey, .fileSizeKey],
                options: .skipsHiddenFiles
            )

            let healthExports = files.filter { $0.pathExtension == "md" && $0.lastPathComponent.starts(with: "health-export-") }

            return healthExports.compactMap { url in
                guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
                      let creationDate = attributes[.creationDate] as? Date,
                      let fileSize = attributes[.size] as? Int64 else {
                    return nil
                }

                return ExportedFile(
                    url: url,
                    filename: url.lastPathComponent,
                    creationDate: creationDate,
                    fileSize: fileSize
                )
            }.sorted { $0.creationDate > $1.creationDate }
        } catch {
            return []
        }
    }

    // Delete an exported file
    func deleteFile(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
}

struct ExportedFile: Identifiable {
    let id = UUID()
    let url: URL
    let filename: String
    let creationDate: Date
    let fileSize: Int64

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }

    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
}
