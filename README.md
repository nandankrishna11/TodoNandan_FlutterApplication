# TodoNandan Flutter

A modern task management application built with Flutter, featuring a beautiful UI and powerful functionality.

## Features

- 📱 Cross-platform support (iOS, Android, Web)
- 🎨 Material Design 3 with dynamic theming
- 📊 Task statistics and progress tracking
- 🔍 Advanced task filtering and search
- 📅 Due date management
- 🏷️ Task categorization and prioritization
- 💾 Local data persistence
- 🌙 Dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nandankrishna11/todo_nandan_flutter.git
   ```

2. Navigate to the project directory:
   ```bash
   cd todo_nandan_flutter
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # App screens
├── widgets/        # Reusable widgets
├── utils/          # Utility functions
├── services/       # Business logic
└── main.dart       # App entry point
```

## Dependencies

- provider: State management
- shared_preferences: Local storage
- intl: Internationalization
- flutter_local_notifications: Local notifications
- image_picker: Image selection
- path_provider: File system access
- sqflite: SQLite database
- uuid: Unique ID generation
- flutter_svg: SVG support
- google_fonts: Custom fonts
- flutter_staggered_animations: Animations
- table_calendar: Calendar widget
- flutter_slidable: Swipe actions
- flutter_animate: Animations

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Original TodoNandan web app
- Flutter team for the amazing framework
- All contributors and supporters

## App Screenshots

Screenshots of the app can be found in the `screenshots` folder.

![Home Screen](screenshots/home.png)
![Task List](screenshots/task_list.png)
