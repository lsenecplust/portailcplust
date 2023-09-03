# portail_canalplustelecom_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Debug over Wifi

- Connect your device to your machine using USB
- Open terminal and type the following
- adb kill-server
- adb tcpip 5555
- adb connect <YOUR_IP>:5555

# Release a Version
flutter build apk --release -t ./lib/main.recette.dart
or
flutter build apk --release -t ./lib/main.production.dart

# Release a Store Version
flutter build appbundle --release -t ./lib/main.production.dart

