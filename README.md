# Heal Snap App

Heal Snap is a mobile application designed to help users track their daily food intake, exercise, and mental well-being to promote a healthier lifestyle.

## Features

- Track daily food intake with a comprehensive database of foods and their nutritional information.
- Log exercise sessions with details like duration, type, and intensity.
- Record mental well-being through mood tracking and journal entries.
- View summary statistics to monitor progress towards health goals.
- Set reminders for meals, exercise sessions, and mindfulness practices.

## Installation

1. Clone the repository to your local machine:

```bash
git clone https://github.com/your-username/heal-snap-app.git
```

2. Navigate to the project directory:

```bash
cd heal-snap-app
```

3. Install dependencies:

```bash
flutter pub get
```

## Configuration

1. Set up Firebase for your project and obtain the necessary configuration files (google-services.json for Android, GoogleService-Info.plist for iOS).

2. Place the configuration files in the respective directories:

   - For Android: `android/app/google-services.json`
   - For iOS: `ios/Runner/GoogleService-Info.plist`

3. Configure the Gemini API:

   - Obtain API keys from the Gemini API platform.
   - Place the API keys in the appropriate location in your project.

## Usage

1. Ensure you have an emulator/device set up for testing.

2. Run the application:

```bash
flutter run
```

## Technologies Used

- Flutter
- Firebase (Authentication, Firestore)
- Gemini API
- Other dependencies managed via pubspec.yaml

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/my-feature`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature/my-feature`).
6. Create a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to customize this README file according to your project's specific details and requirements!
