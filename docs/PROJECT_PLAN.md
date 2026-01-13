# HealthData Export App - Project Plan

## Project Overview
Native iOS application that allows users to export selected Apple Health data points on a schedule and share them as markdown files to other devices (laptop).

## Requirements Summary
- **Primary Goal**: Quick export and share health data from iPhone to laptop
- **UI/UX**: Modern iOS native app following Material Design principles (adapted for iOS)
- **Core Features**:
  - Select specific health data points for export
  - Schedule regular exports via calendar
  - Generate markdown formatted output
  - Automatic sharing on schedule

## Technical Architecture

### Platform & Technology Stack
- **Platform**: iOS (native)
- **Language**: Swift
- **UI Framework**: SwiftUI (modern, off-the-shelf)
- **Health Framework**: HealthKit
- **Storage**: UserDefaults for preferences, FileManager for export files
- **Sharing**: Share Sheet / Files app integration / iCloud Drive

### Key Components
1. **HealthKit Integration Layer**
   - Request health data permissions
   - Query selected health metrics
   - Handle data access and privacy

2. **Data Selection Module**
   - UI for browsing available health metrics
   - Multi-select interface for choosing data points
   - Save user preferences

3. **Scheduling System**
   - Calendar-based export scheduling
   - Background task execution (BackgroundTasks framework)
   - Notification system for export completion

4. **Export Engine**
   - Format health data into markdown
   - Template system for markdown output
   - File generation and management

5. **Sharing Module**
   - Integration with iOS Share Sheet
   - iCloud Drive sync capability
   - AirDrop support

## Implementation Phases

### Phase 1: Project Setup & Core Infrastructure
**Tasks:**
- Set up Xcode project with SwiftUI
- Configure HealthKit capabilities and permissions
- Design app architecture and folder structure
- Set up version control and GitHub repository
- Create basic app navigation structure

**Deliverables:**
- Working Xcode project
- HealthKit permissions flow
- Basic navigation framework

### Phase 2: Health Data Access & Selection
**Tasks:**
- Implement HealthKit data query functionality
- Build UI for displaying available health metrics
- Create selection interface for choosing data points
- Implement data fetching for selected metrics
- Add data preview functionality

**Deliverables:**
- Functional health data browser
- Working selection system
- Real-time data preview

### Phase 3: Markdown Export System
**Tasks:**
- Design markdown template structure
- Implement markdown generation logic
- Create file management system
- Build export preview UI
- Add manual export functionality

**Deliverables:**
- Working markdown export
- File storage system
- Export preview feature

### Phase 4: Scheduling System
**Tasks:**
- Implement calendar-based scheduling UI
- Set up BackgroundTasks framework
- Create scheduled export logic
- Implement notification system
- Add schedule management UI

**Deliverables:**
- Working scheduled exports
- Background execution capability
- User notifications

### Phase 5: Sharing & Integration
**Tasks:**
- Integrate iOS Share Sheet
- Implement iCloud Drive sync
- Add AirDrop support
- Create sharing history/log
- Build settings/preferences screen

**Deliverables:**
- Multiple sharing options
- Cloud sync functionality
- Complete settings interface

### Phase 6: Polish & Release
**Tasks:**
- UI/UX refinement
- Performance optimization
- Testing (unit, integration, UI)
- Bug fixes
- App Store preparation (icons, screenshots, description)
- Documentation

**Deliverables:**
- Production-ready app
- Test coverage
- App Store submission materials

## Data Model

### Health Metrics (Examples)
- Steps
- Heart Rate
- Sleep Analysis
- Active Energy
- Exercise Minutes
- Blood Oxygen
- Blood Pressure
- Weight
- Body Mass Index
- Nutrition data

### User Preferences
```swift
struct ExportPreferences {
    var selectedMetrics: [HealthMetricType]
    var exportSchedule: Schedule
    var exportFormat: ExportFormat
    var sharingDestination: SharingDestination
}
```

### Schedule Model
```swift
struct Schedule {
    var frequency: Frequency // daily, weekly, monthly
    var time: Date
    var enabled: Bool
}
```

## Markdown Output Format

```markdown
# Health Data Export
**Date**: [Export Date]
**Period**: [Start Date] - [End Date]

## Summary
- Total Steps: [value]
- Average Heart Rate: [value]
- Sleep Duration: [value]
...

## Detailed Metrics

### Steps
- [Date]: [value] steps
...

### Heart Rate
- Average: [value] bpm
- Min: [value] bpm
- Max: [value] bpm
...
```

## Technical Considerations

### HealthKit Permissions
- Request only necessary permissions
- Handle permission denials gracefully
- Provide clear permission rationale

### Background Execution
- Use BackgroundTasks framework
- Handle task expiration
- Ensure reliable scheduling

### Data Privacy
- All data processed locally
- No external data transmission (unless user initiates)
- Secure file storage

### Performance
- Efficient HealthKit queries
- Pagination for large datasets
- Async data processing

## Testing Strategy
- **Unit Tests**: Data formatting, schedule logic, export generation
- **Integration Tests**: HealthKit queries, file operations
- **UI Tests**: Navigation flows, selection interface
- **Manual Testing**: Background tasks, sharing flows

## Future Enhancements (Post-MVP)
- Custom markdown templates
- Data visualization/charts
- Export to other formats (CSV, JSON, PDF)
- Sync with Obsidian directly
- Widget support
- Watch app companion
- Share to specific apps (Dropbox, Google Drive)

## Development Environment Setup
1. Xcode 15+ (latest stable)
2. iOS 17+ deployment target
3. Swift 5.9+
4. SwiftUI for UI
5. Git for version control

## Repository Structure
```
HealthDataExport/
├── HealthDataExport/
│   ├── App/
│   │   ├── HealthDataExportApp.swift
│   │   └── ContentView.swift
│   ├── Models/
│   │   ├── HealthMetric.swift
│   │   ├── ExportPreferences.swift
│   │   └── Schedule.swift
│   ├── Views/
│   │   ├── MetricSelectionView.swift
│   │   ├── ScheduleView.swift
│   │   ├── ExportView.swift
│   │   └── SettingsView.swift
│   ├── ViewModels/
│   │   ├── HealthDataViewModel.swift
│   │   └── ExportViewModel.swift
│   ├── Services/
│   │   ├── HealthKitManager.swift
│   │   ├── ExportEngine.swift
│   │   ├── SchedulingService.swift
│   │   └── SharingService.swift
│   └── Utils/
│       ├── MarkdownGenerator.swift
│       └── Extensions.swift
├── HealthDataExportTests/
├── README.md
├── LICENSE
└── .gitignore
```

## Risk Management

### Risks & Mitigation
1. **HealthKit Permission Denial**
   - Mitigation: Clear onboarding, explain benefits, graceful degradation

2. **Background Task Limitations**
   - Mitigation: Document iOS limitations, provide manual export option

3. **Large Data Volume Performance**
   - Mitigation: Implement pagination, limit date ranges, optimize queries

4. **iOS Version Compatibility**
   - Mitigation: Target iOS 17+, test on multiple versions

## Success Metrics
- User can export health data in under 10 seconds
- Scheduled exports execute reliably (>99% success rate)
- App uses <50MB memory during typical operation
- Markdown files generated correctly with user-selected metrics
- Sharing completes successfully across different methods

## Timeline Estimate
- Phase 1: Core infrastructure setup
- Phase 2: Health data access implementation
- Phase 3: Export system development
- Phase 4: Scheduling functionality
- Phase 5: Sharing integration
- Phase 6: Polish and release preparation

## Next Steps
1. Set up GitHub repository
2. Initialize Xcode project
3. Configure HealthKit entitlements
4. Begin Phase 1 implementation
