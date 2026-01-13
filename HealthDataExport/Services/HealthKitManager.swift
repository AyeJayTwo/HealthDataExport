import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()

    @Published var isAuthorized = false

    // Check if HealthKit is available on this device
    static var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    // Request authorization for all supported metric types
    func requestAuthorization() async throws {
        guard Self.isHealthKitAvailable else {
            throw HealthKitError.notAvailable
        }

        let allTypes = Set(HealthMetricType.allCases.compactMap { $0.healthKitType })

        try await healthStore.requestAuthorization(toShare: [], read: allTypes)

        await MainActor.run {
            self.isAuthorized = true
        }
    }

    // Query data for a specific metric type and date range
    func queryData(
        for metricType: HealthMetricType,
        startDate: Date,
        endDate: Date
    ) async throws -> [HealthDataPoint] {
        guard let healthKitType = metricType.healthKitType else {
            throw HealthKitError.invalidType
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        // Handle sleep differently (category type)
        if metricType == .sleep {
            return try await querySleepData(startDate: startDate, endDate: endDate)
        }

        // Query quantity types
        guard let quantityType = healthKitType as? HKQuantityType else {
            throw HealthKitError.invalidType
        }

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }

                let dataPoints = samples.map { sample in
                    let value = sample.quantity.doubleValue(for: metricType.unit ?? .count())
                    return HealthDataPoint(
                        type: metricType,
                        value: value,
                        date: sample.startDate,
                        unit: metricType.unit?.unitString ?? ""
                    )
                }

                continuation.resume(returning: dataPoints)
            }

            self.healthStore.execute(query)
        }
    }

    // Query sleep data (category type)
    private func querySleepData(
        startDate: Date,
        endDate: Date
    ) async throws -> [HealthDataPoint] {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            throw HealthKitError.invalidType
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let samples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: [])
                    return
                }

                // Filter for asleep samples and calculate duration
                let sleepSamples = samples.filter { sample in
                    sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue
                }

                let dataPoints = sleepSamples.map { sample in
                    let duration = sample.endDate.timeIntervalSince(sample.startDate) / 3600 // Convert to hours
                    return HealthDataPoint(
                        type: .sleep,
                        value: duration,
                        date: sample.startDate,
                        unit: "hours"
                    )
                }

                continuation.resume(returning: dataPoints)
            }

            self.healthStore.execute(query)
        }
    }

    // Query data for multiple dates
    func queryDataForDates(
        for metricType: HealthMetricType,
        dates: [Date]
    ) async throws -> [HealthDataPoint] {
        var allDataPoints: [HealthDataPoint] = []

        for date in dates {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

            let points = try await queryData(
                for: metricType,
                startDate: startOfDay,
                endDate: endOfDay
            )
            allDataPoints.append(contentsOf: points)
        }

        return allDataPoints
    }

    // Create summary statistics from data points
    func createSummary(from dataPoints: [HealthDataPoint], for type: HealthMetricType) -> HealthDataSummary {
        guard !dataPoints.isEmpty else {
            return HealthDataSummary(
                metricType: type,
                total: nil,
                average: nil,
                minimum: nil,
                maximum: nil,
                dataPoints: []
            )
        }

        let values = dataPoints.map { $0.value }
        let total = values.reduce(0, +)
        let average = total / Double(values.count)
        let minimum = values.min()
        let maximum = values.max()

        return HealthDataSummary(
            metricType: type,
            total: total,
            average: average,
            minimum: minimum,
            maximum: maximum,
            dataPoints: dataPoints
        )
    }
}

enum HealthKitError: LocalizedError {
    case notAvailable
    case invalidType
    case authorizationDenied

    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .invalidType:
            return "Invalid health data type"
        case .authorizationDenied:
            return "Health data access was denied"
        }
    }
}
