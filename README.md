# Project goal
This is a terminal application project in Dart. 
The main goal is to: 
* display the output of `dart test` or `flutter test` commands in a more developer-friendly way (as a TUI).
* allow easily (re)running tests with keyboard-driven input
* when tests fail because of mismatching excpect() assertions visually highlight the mismatching values

# Technical concept
* It's written in TUI style (like for example lazygit or top).
* the program starts sub-process like `flutter test` and controls input/output for it


# Non-functional requirements
* the program should stay responsive
* the program should inform the user of the actual state of subprocess
* Follow unix-philosofhy, allow for flexibility

# Tracking the progress
The tasks.md file tracks the progress of this project.
