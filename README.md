# Nitya Dāsa

This repository will host the source code for **Nitya Dāsa**, a Flutter-based mobile application to help practitioners manage and track their daily devotional activities.

## Project Overview

The goal of this project is to provide a simple tool that supports regular spiritual practice. The app will help users plan and follow daily routines, keep notes, and stay motivated in their sadhana.

Key planned features include:

- **Personalized daily schedules** with reminders for key practices
- **Japa counter** and progress tracking
- **Scripture reading plans** and references
- **Event calendar** for temple or community activities
- **Push notifications** for important updates

For a more detailed overview, see [docs/features.md](docs/features.md).

## Notifications

Daily reminders help keep you on track. The app uses
`flutter_local_notifications` to schedule a morning and evening reminder.
By default these fire at **7:00 AM** and **7:00 PM**. You can adjust these
times from the **Settings** page inside the app.
Note: On Android 12+ the app needs the `SCHEDULE_EXACT_ALARM` permission and you may have to allow exact alarms in system settings.

## Installation

1. Ensure you have the [Flutter SDK](https://flutter.dev/) installed.
2. Install the Android NDK version `27.0.12077973` and make sure `android/app/build.gradle.kts` sets `ndkVersion` to this value.
3. Clone this repository:
   ```bash
   git clone <repository-url>
   ```
4. Navigate to the project directory and get the dependencies:
   ```bash
   flutter pub get
   ```
   The generated `pubspec.lock` file is checked into version control so
   that all developers work with the same dependency versions.
5. Run the application on an emulator or connected device:
   ```bash
   flutter run
   ```

## Running Tests

Widget tests can be executed using:

```bash
flutter test
```

For more details, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Usage Notes

At this stage the project is in early development. After cloning and installing dependencies, you can run the default Flutter app as a starting point. As new features are implemented, this README will be updated with additional instructions.

Please check back for future updates and feel free to submit issues or pull requests to contribute.

## License

This project is licensed under the [MIT License](LICENSE).
