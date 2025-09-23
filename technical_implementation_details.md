# Technical Implementation Details

## Main Components

### 1. `lib/main.dart`
- **Responsibilities**: 
  - Entry point of the application.
  - Parses command-line arguments using the `args` package.
  - Initializes the console and sets it to raw mode for capturing key events.
  - Manages the lifecycle of the test runner and event processing.
  - Handles user input for controlling test execution (start, stop, quit).

### 2. `lib/test_runner.dart`
- **Responsibilities**: 
  - Manages the execution of test commands as subprocesses.
  - Parses test output using `TestEventParser`.
  - Streams parsed events to be processed by `TestEventMapper`.
  - Provides methods to start and stop test execution.

### 3. `lib/test_event_parser.dart`
- **Responsibilities**: 
  - Parses JSON lines from test output into specific event objects.
  - Supports various event types like `StartEvent`, `SuiteEvent`, `TestStartEvent`, etc.
  - Throws exceptions for unknown event types.

### 4. `lib/test_event_mapper.dart`
- **Responsibilities**: 
  - Maps parsed events to update the application state (`AppState`).
  - Tracks relationships between test IDs and suite IDs.
  - Updates the status line based on event processing.

### 5. `lib/app_state.dart`
- **Responsibilities**: 
  - Maintains the state of the application, including test results and status.
  - Provides methods to update test states based on events.

### 6. `lib/draw.dart`
- **Responsibilities**: 
  - Handles rendering of the console output.
  - Divides the console into top and bottom panes for test list and details view.
  - Uses ANSI codes for colored output based on test results.

### 7. `lib/test_events.dart`
- **Responsibilities**: 
  - Defines data structures for various test events.
  - Includes classes like `StartEvent`, `SuiteEvent`, `TestStartEvent`, etc.

### 8. `lib/test_state.dart`
- **Responsibilities**: 
  - Represents the state of individual tests.
  - Includes properties like test name, result, and skipped status.

### 9. `lib/key_event.dart`
- **Responsibilities**: 
  - Defines key event types and parsing logic.
  - Supports various key types like character keys, control keys, and function keys.

## Additional Information

- **Dependencies**: 
  - Uses `args` for argument parsing.
  - Uses `dart_console` for console manipulation and output.
  - Uses `lints` and `test` for development and testing purposes.

This document provides a high-level overview of the components and their roles, facilitating reimplementation in another programming language.
