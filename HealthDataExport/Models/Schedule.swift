import Foundation

enum ScheduleFrequency: String, CaseIterable, Codable {
    case daily
    case weekly
    case monthly

    var displayName: String {
        rawValue.capitalized
    }
}

struct Schedule: Codable {
    var isEnabled: Bool
    var frequency: ScheduleFrequency
    var time: Date

    static var `default`: Schedule {
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        let defaultTime = Calendar.current.date(from: components) ?? Date()

        return Schedule(
            isEnabled: false,
            frequency: .daily,
            time: defaultTime
        )
    }

    // UserDefaults keys
    static let enabledKey = "scheduleEnabled"
    static let frequencyKey = "scheduleFrequency"
    static let timeKey = "scheduleTime"

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(isEnabled, forKey: Self.enabledKey)
        defaults.set(frequency.rawValue, forKey: Self.frequencyKey)
        defaults.set(time, forKey: Self.timeKey)
    }

    static func load() -> Schedule {
        let defaults = UserDefaults.standard
        let isEnabled = defaults.bool(forKey: enabledKey)
        let frequencyString = defaults.string(forKey: frequencyKey) ?? ScheduleFrequency.daily.rawValue
        let frequency = ScheduleFrequency(rawValue: frequencyString) ?? .daily
        let time = defaults.object(forKey: timeKey) as? Date ?? Schedule.default.time

        return Schedule(isEnabled: isEnabled, frequency: frequency, time: time)
    }

    var nextScheduledDate: Date? {
        guard isEnabled else { return nil }

        let calendar = Calendar.current
        let now = Date()
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var nextDate: Date?

        switch frequency {
        case .daily:
            // Schedule for today at the specified time
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            nextDate = calendar.date(from: components)

            // If that time has passed today, schedule for tomorrow
            if let date = nextDate, date <= now {
                nextDate = calendar.date(byAdding: .day, value: 1, to: date)
            }

        case .weekly:
            // Schedule for next week at the same day and time
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            if let todayAtTime = calendar.date(from: components) {
                if todayAtTime > now {
                    nextDate = todayAtTime
                } else {
                    nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: todayAtTime)
                }
            }

        case .monthly:
            // Schedule for next month at the same day and time
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            if let todayAtTime = calendar.date(from: components) {
                if todayAtTime > now {
                    nextDate = todayAtTime
                } else {
                    nextDate = calendar.date(byAdding: .month, value: 1, to: todayAtTime)
                }
            }
        }

        return nextDate
    }
}
