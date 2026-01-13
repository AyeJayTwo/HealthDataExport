import Foundation
import HealthKit

enum HealthMetricType: String, CaseIterable, Identifiable, Codable {
    case steps
    case heartRate
    case sleep
    case activeEnergy
    case exerciseTime
    case weight
    case bodyMassIndex

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .steps:
            return "Steps"
        case .heartRate:
            return "Heart Rate"
        case .sleep:
            return "Sleep"
        case .activeEnergy:
            return "Active Energy"
        case .exerciseTime:
            return "Exercise Time"
        case .weight:
            return "Weight"
        case .bodyMassIndex:
            return "BMI"
        }
    }

    var icon: String {
        switch self {
        case .steps:
            return "figure.walk"
        case .heartRate:
            return "heart.fill"
        case .sleep:
            return "bed.double.fill"
        case .activeEnergy:
            return "flame.fill"
        case .exerciseTime:
            return "figure.run"
        case .weight:
            return "scalemass.fill"
        case .bodyMassIndex:
            return "chart.bar.fill"
        }
    }

    var healthKitType: HKObjectType? {
        switch self {
        case .steps:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)
        case .heartRate:
            return HKQuantityType.quantityType(forIdentifier: .heartRate)
        case .sleep:
            return HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
        case .activeEnergy:
            return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        case .exerciseTime:
            return HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)
        case .weight:
            return HKQuantityType.quantityType(forIdentifier: .bodyMass)
        case .bodyMassIndex:
            return HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)
        }
    }

    var unit: HKUnit? {
        switch self {
        case .steps:
            return HKUnit.count()
        case .heartRate:
            return HKUnit.count().unitDivided(by: .minute())
        case .sleep:
            return nil // Category type, no unit
        case .activeEnergy:
            return HKUnit.kilocalorie()
        case .exerciseTime:
            return HKUnit.minute()
        case .weight:
            return HKUnit.pound()
        case .bodyMassIndex:
            return HKUnit.count()
        }
    }
}
