# HealthDataExport

A native iOS application for exporting Apple Health data on a schedule and sharing it as markdown files.

## Overview

HealthDataExport allows you to:
- Select specific health metrics from Apple Health
- Schedule automatic exports (daily, weekly, monthly)
- Generate markdown-formatted reports
- Share data seamlessly to your laptop or other devices

## Features

- **Custom Data Selection**: Choose which health metrics to export
- **Scheduled Exports**: Set up automatic exports via calendar
- **Markdown Output**: Clean, readable markdown format compatible with note-taking apps like Obsidian
- **Multiple Sharing Options**: iCloud Drive, AirDrop, Share Sheet integration
- **Privacy First**: All data processed locally on your device

## Technology Stack

- **Platform**: iOS 17+
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Health Integration**: HealthKit
- **Background Tasks**: BackgroundTasks framework

## Project Status

✅ **Implementation Complete** - All core features have been implemented and are ready for testing.

See [Project Plan](docs/PROJECT_PLAN.md) for detailed implementation phases and architecture.

## Supported Health Metrics

- Steps
- Heart Rate
- Sleep
- Active Energy
- Exercise Time
- Weight
- Body Mass Index (BMI)

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Physical iOS device (HealthKit not available in Simulator)
- Apple Health data on device

## Getting Started

### Setting Up the Xcode Project

The Swift source files are provided in the `HealthDataExport/` directory. To build the app:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AyeJayTwo/HealthDataExport.git
   cd HealthDataExport
   ```

2. **Create the Xcode project**:
   - See detailed instructions in [XCODE_SETUP.md](XCODE_SETUP.md)
   - Open Xcode and create a new iOS App project
   - Add the existing source files from the `HealthDataExport/` directory
   - Configure HealthKit capability

3. **Build and run**:
   - Connect your iOS device
   - Select your device as the build target
   - Press ⌘+R to build and run

### Using the App

1. **Grant Permissions**: On first launch, grant HealthKit access to the metrics you want to export

2. **Select Data**:
   - Choose which dates to export (default: yesterday)
   - Select which health metrics to include

3. **Export**:
   - Tap "Export Data" to create a markdown file
   - Use the share sheet to send the file to your laptop

4. **Schedule** (Optional):
   - Go to the Schedule tab
   - Enable scheduled exports
   - Choose frequency and time
   - Grant notification permissions

## Example Export

```markdown
# Health Data Export
**Export Date**: January 13, 2026
**Data for**: January 12, 2026

## Summary
- **Steps**: 8,432 steps
- **Heart Rate**: Avg 72 bpm (Min: 58, Max: 145)
- **Sleep**: 7h 23m
- **Active Energy**: 456.7 kcal
- **Exercise Time**: 45 min
- **Weight**: 165.2 lbs
- **BMI**: 23.4

## Detailed Data
...
```

## Documentation

- [Project Plan](docs/PROJECT_PLAN.md) - Detailed implementation phases and architecture
- [Requirements](docs/REQUIREMENTS.md) - Original requirements and user stories

## License

MIT License - See [LICENSE](LICENSE) for details

## Author

Built with Claude Code

---

**Note**: This app requires access to Apple Health data. All health data is processed locally and never transmitted to external servers without your explicit action.
