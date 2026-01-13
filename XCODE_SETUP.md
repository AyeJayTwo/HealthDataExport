# Xcode Project Setup Instructions

The Swift source files have been created in the `HealthDataExport/` directory. To create the Xcode project:

## Option 1: Create Project in Xcode (Recommended)

1. Open Xcode
2. Select **File > New > Project**
3. Choose **iOS > App** template
4. Configure the project:
   - **Product Name**: HealthDataExport
   - **Team**: Select your development team
   - **Organization Identifier**: com.ayejaytwo (or your own)
   - **Bundle Identifier**: com.ayejaytwo.HealthDataExport
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Use Core Data**: No
   - **Include Tests**: Yes (optional)
5. Save the project to: `~/Developer/HealthDataExport/`

6. **Delete the auto-generated files** that Xcode creates:
   - Delete `HealthDataExportApp.swift` (we have our own)
   - Delete `ContentView.swift` (we have our own)

7. **Add the existing source files**:
   - In Xcode, right-click on the `HealthDataExport` group
   - Select **Add Files to "HealthDataExport"...**
   - Navigate to `~/Developer/HealthDataExport/HealthDataExport/`
   - Select all the folders: `Models`, `Services`, `ViewModels`, `Views`
   - Select the files: `HealthDataExportApp.swift`, `Info.plist`, `HealthDataExport.entitlements`
   - Make sure **"Copy items if needed"** is UNCHECKED (files are already in place)
   - Click **Add**

8. **Configure HealthKit Capability**:
   - Select the project in the Project Navigator
   - Select the **HealthDataExport** target
   - Go to **Signing & Capabilities** tab
   - Click **+ Capability**
   - Add **HealthKit**

9. **Set Custom Info.plist**:
   - In the target settings, go to **Build Settings**
   - Search for "Info.plist"
   - Set **Info.plist File** to: `HealthDataExport/Info.plist`

10. **Set Entitlements File**:
    - In target settings > **Build Settings**
    - Search for "Code Signing Entitlements"
    - Set to: `HealthDataExport/HealthDataExport.entitlements`

## Option 2: Use Command Line (Advanced)

If you're comfortable with command-line tools, you can also generate a project using tools like `swift package` or manually create the `.xcodeproj` structure. However, Option 1 is recommended for most users.

## Building and Running

1. **Select a target device**: You must use a **physical iOS device** for HealthKit functionality. The iOS Simulator does not support HealthKit.

2. **Configure Signing**:
   - Go to **Signing & Capabilities**
   - Select your Team
   - Xcode will automatically manage signing

3. **Build and Run**:
   - Press **⌘+R** or click the Play button
   - The app will install on your device

## First Launch

On first launch, the app will:
1. Request HealthKit permissions for all supported metrics
2. Allow you to grant or deny access to each metric type
3. Load the Export tab where you can immediately create an export

## Testing Background Tasks

Background scheduled exports require additional setup:
1. Enable the schedule in the app
2. Background tasks are controlled by iOS and may not run immediately
3. For testing, you can use Xcode's debug menu: **Debug > Simulate Background Fetch**

## Troubleshooting

### "No such module 'HealthKit'"
- Ensure HealthKit capability is added in Signing & Capabilities
- Clean build folder (⌘+Shift+K) and rebuild

### "HealthKit not available"
- You must use a physical iOS device
- HealthKit is not available in the Simulator

### Build errors about missing files
- Verify all source files are added to the target
- Check that file paths are correct in the project navigator

### Code signing issues
- Select your development team in Signing & Capabilities
- You may need to register your device in the Apple Developer Portal

## File Structure

The project should have this structure:
```
HealthDataExport/
├── HealthDataExport.xcodeproj/
├── HealthDataExport/
│   ├── Models/
│   │   ├── HealthMetricType.swift
│   │   ├── HealthDataPoint.swift
│   │   ├── ExportPreferences.swift
│   │   └── Schedule.swift
│   ├── Services/
│   │   ├── HealthKitManager.swift
│   │   ├── MarkdownGenerator.swift
│   │   ├── ExportEngine.swift
│   │   └── SchedulingService.swift
│   ├── ViewModels/
│   │   ├── ExportViewModel.swift
│   │   └── ScheduleViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── ExportView.swift
│   │   ├── ScheduleView.swift
│   │   └── SettingsView.swift
│   ├── HealthDataExportApp.swift
│   ├── Info.plist
│   └── HealthDataExport.entitlements
├── README.md
└── docs/
```

## Next Steps

After setting up the Xcode project:
1. Build and run on your device
2. Grant HealthKit permissions
3. Test creating a manual export
4. Configure a schedule if desired
5. Verify markdown files are created in the Documents folder

For more information, see the [Project Plan](docs/PROJECT_PLAN.md) and [Requirements](docs/REQUIREMENTS.md).
