# codsoft_tasks
Completed 3 Android Application Development tasks as part of the CODSOFT Virtual Internship, gaining hands-on experience in Flutter, Dart, and mobile app development.

# To-Do List App (Flutter)

A simple to-do list app built with Flutter and Dart.

## Features

- Add, edit and delete tasks
- Optional task descriptions
- Priority levels (High / Medium / Low) with colored flags
- Due dates via a date picker
- Mark tasks as completed or active
- Clean Material 3 interface

## Run on DartPad

1. Open [dartpad.dev](https://dartpad.dev)
2. Choose **New > Flutter**
3. Paste the contents of `main.dart`
4. Click **Run**

## Run locally

```bash
flutter create todo_app
cd todo_app
# replace lib/main.dart with this repo's main.dart
flutter run
```

## Note

Tasks are held in memory, so they reset when the app restarts. For persistent local storage, add the `shared_preferences` package.

