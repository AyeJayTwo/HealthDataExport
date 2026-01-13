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

🚧 **In Development** - This project is currently in the planning and initial development phase.

See [Project Plan](docs/PROJECT_PLAN.md) for detailed implementation roadmap.

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Apple Health data on device

## Getting Started

1. Clone the repository
2. Open `HealthDataExport.xcodeproj` in Xcode
3. Build and run on your iOS device (requires physical device for HealthKit)

## Documentation

- [Project Plan](docs/PROJECT_PLAN.md) - Detailed implementation phases and architecture
- [Requirements](docs/REQUIREMENTS.md) - Original requirements and user stories

## License

MIT License - See [LICENSE](LICENSE) for details

## Author

Built with Claude Code

---

**Note**: This app requires access to Apple Health data. All health data is processed locally and never transmitted to external servers without your explicit action.
