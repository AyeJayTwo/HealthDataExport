import Foundation

struct ExportPreferences: Codable {
    var selectedMetrics: Set<HealthMetricType>
    var selectedDates: [Date]

    static var `default`: ExportPreferences {
        ExportPreferences(
            selectedMetrics: Set(HealthMetricType.allCases),
            selectedDates: [Calendar.current.date(byAdding: .day, value: -1, to: Date())!]
        )
    }

    // Keys for UserDefaults
    static let metricsKey = "selectedMetrics"
    static let datesKey = "selectedDates"

    func save() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(Array(selectedMetrics)) {
            defaults.set(encoded, forKey: Self.metricsKey)
        }
        if let encoded = try? JSONEncoder().encode(selectedDates) {
            defaults.set(encoded, forKey: Self.datesKey)
        }
    }

    static func load() -> ExportPreferences {
        let defaults = UserDefaults.standard
        var metrics = Set(HealthMetricType.allCases)
        var dates = [Calendar.current.date(byAdding: .day, value: -1, to: Date())!]

        if let metricsData = defaults.data(forKey: metricsKey),
           let decoded = try? JSONDecoder().decode([HealthMetricType].self, from: metricsData) {
            metrics = Set(decoded)
        }

        if let datesData = defaults.data(forKey: datesKey),
           let decoded = try? JSONDecoder().decode([Date].self, from: datesData) {
            dates = decoded
        }

        return ExportPreferences(selectedMetrics: metrics, selectedDates: dates)
    }
}
