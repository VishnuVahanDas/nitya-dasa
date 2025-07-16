# Contributing to Nitya Dāsa

Thank you for your interest in contributing to **Nitya Dāsa**! This document explains how to set up your development environment, run tests, and submit pull requests.

## Setting up the Development Environment

1. **Install Flutter**
   - Follow the instructions at [flutter.dev](https://flutter.dev/docs/get-started/install) to install the Flutter SDK for your platform.
2. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd nitya-dasa
   ```
3. **Fetch Dependencies**
   ```bash
   flutter pub get
   ```
4. **Run the Application** (optional)
   ```bash
   flutter run
   ```

## Running Tests

This project currently has no automated tests. As tests are added, you can run them with:

```bash
flutter test
```

## Code Style

- Format your Dart code using `dart format .` or `flutter format .` before committing.
- Check for any issues with `flutter analyze`.

## Commit Messages

- Use clear, descriptive commit messages in the imperative mood (e.g., "Add feature" not "Added feature").
- Provide additional context in the body when necessary.

## Submitting a Pull Request

1. Fork the repository and create a new branch for your feature or bugfix.
2. Ensure your branch is up to date with the `main` branch.
3. Run `flutter format .` and `flutter analyze` to check for style issues.
4. (When tests exist) run `flutter test` and confirm all tests pass.
5. Push your branch and open a pull request on GitHub.
6. Describe your changes clearly in the pull request description.

## Contact

If you have questions, please open an issue on GitHub. Maintainers will respond as soon as possible.

