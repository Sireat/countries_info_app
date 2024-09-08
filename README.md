# Country Information App

A Flutter application that provides country information with features such as searching, filtering by region, pagination, and displaying country details. The app fetches data from a remote API and provides a user-friendly interface for exploring countries.

## Table of Contents

- [Dependencies](#dependencies)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)

## Dependencies

This project uses the following dependencies:

### Flutter SDK

- **Description**: The Flutter SDK is required to build and run the application.
- **Version**: Ensure you have the latest stable version of Flutter installed.

### `http`

- **Description**: A package for making HTTP requests. Used to fetch country data from the remote API.
- **Version**: `^0.15.0`
- **Usage**: Provides functionality to perform network operations such as GET and POST requests.

### `provider`

- **Description**: A state management package that provides a way to manage and expose state to the widget tree.
- **Version**: `^6.0.1`
- **Usage**: Manages the state of the country data and handles business logic for fetching, filtering, and paginating countries.

### `flutter_bloc`

- **Description**: A package for implementing the BLoC (Business Logic Component) pattern, providing a way to separate business logic from UI code.
- **Version**: `^8.0.0`
- **Usage**: Manages state and events related to country data and user interactions.

### `sqflite`

- **Description**: A package for SQLite database access in Flutter. Used to manage local storage of favorite countries.
- **Version**: `^2.2.0`
- **Usage**: Provides functionality for storing and retrieving data locally, such as user favorites.

### `flutter_localizations`

- **Description**: A Flutter package for internationalization and localization support.
- **Version**: `^1.10.0`
- **Usage**: Supports multiple languages and regional settings for the app.

### `dartz`

- **Description**: A package that provides functional programming utilities for Dart.
- **Version**: `^0.10.0`
- **Usage**: Provides utilities for handling errors and functional programming constructs.

### `json_serializable`

- **Description**: A code generation library for JSON serialization in Dart.
- **Version**: `^6.1.1`
- **Usage**: Automatically generates JSON serialization code for data models.

### `build_runner`

- **Description**: A build system for Dart that automates code generation tasks.
- **Version**: `^2.3.0`
- **Usage**: Runs code generation tasks for the `json_serializable` package.

### `flutter_test`

- **Description**: A package for testing Flutter widgets and applications.
- **Version**: Included with Flutter SDK
- **Usage**: Provides testing utilities for writing and running widget and integration tests.

## Project Structure

The project follows the Clean Architecture principles:

- `lib/`
  - `core/`: Contains core utilities, error handling, and constants.
  - `data/`: Includes data sources, models, and repository implementations.
  - `domain/`: Contains business logic, entities, and repositories.
  - `presentation/`: Holds UI components, providers, and screens.
- `test/`: Contains unit and widget tests for the application.

## How to Run

1. **Clone the Repository:**

   ```bash
   1.git clone https://github.com/sireat/country-information-app.git
   2.flutter pub get
   3.flutter run

## Sample Screenshoot

   ![Alt text](path/to/image)
