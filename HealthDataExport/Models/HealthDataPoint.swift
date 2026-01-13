import Foundation

struct HealthDataPoint: Identifiable {
    let id = UUID()
    let type: HealthMetricType
    let value: Double
    let date: Date
    let unit: String

    var formattedValue: String {
        switch type {
        case .steps:
            return "\(Int(value)) steps"
        case .heartRate:
            return String(format: "%.0f bpm", value)
        case .sleep:
            let hours = Int(value)
            let minutes = Int((value - Double(hours)) * 60)
            return "\(hours)h \(minutes)m"
        case .activeEnergy:
            return String(format: "%.1f kcal", value)
        case .exerciseTime:
            return "\(Int(value)) min"
        case .weight:
            return String(format: "%.1f lbs", value)
        case .bodyMassIndex:
            return String(format: "%.1f", value)
        }
    }
}

struct HealthDataSummary {
    let metricType: HealthMetricType
    let total: Double?
    let average: Double?
    let minimum: Double?
    let maximum: Double?
    let dataPoints: [HealthDataPoint]

    var formattedSummary: String {
        switch metricType {
        case .steps:
            if let total = total {
                return "\(Int(total)) steps"
            }
        case .heartRate:
            if let avg = average, let min = minimum, let max = maximum {
                return String(format: "Avg %.0f bpm (Min: %.0f, Max: %.0f)", avg, min, max)
            }
        case .sleep:
            if let total = total {
                let hours = Int(total)
                let minutes = Int((total - Double(hours)) * 60)
                return "\(hours)h \(minutes)m"
            }
        case .activeEnergy:
            if let total = total {
                return String(format: "%.1f kcal", total)
            }
        case .exerciseTime:
            if let total = total {
                return "\(Int(total)) min"
            }
        case .weight:
            if let avg = average {
                return String(format: "%.1f lbs", avg)
            }
        case .bodyMassIndex:
            if let avg = average {
                return String(format: "%.1f", avg)
            }
        }
        return "No data"
    }
}
