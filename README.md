# Medical Reports App

Welcome to our innovative medical reports app, a comprehensive solution designed to revolutionize the way you manage your health. With an array of powerful features and intuitive functionality, our app empowers users to take control of their well-being like never before.

## Key Features

### Secure Medical Records Management
- Effortlessly upload, organize, and retrieve medical records anytime, anywhere.
- Advanced encryption and security measures ensure complete confidentiality of sensitive information.

### Personalized Symptom Tips
- When adding a medical report, users are prompted to enter symptoms.
- Utilize the symptoms provided by users to generate tailored advice and recommendations for better understanding and managing their health.
- Receive insights based on the reported symptoms, helping users make informed decisions about their health.

### Sophisticated Symptom Analysis
- Identify patterns and trends in symptoms, with alerts for potential concerns and highlighting of serious symptoms.

### Medical Expense Tracking
- Keep track of healthcare spending for better financial planning and management.

### Integrated Health Calendar
- Visual representation of health history for better monitoring and management, enabling tracking of progress over time.

## Installation

1. Clone the repository to your local machine:

```bash
git clone https://github.com/Shubham-Zone/Heal-snap
```

2. Navigate to the project directory:

```bash
cd Heal-snap
```

3. Install dependencies:

```bash
flutter pub get
```

### Configuration

1. **Set up Firebase**:
   - Go to the Firebase console and create a new project.
   - Download the configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) from Firebase for your project.
   - Place the configuration files in the respective directories:
     - For Android: `android/app/google-services.json`
     - For iOS: `ios/Runner/GoogleService-Info.plist`

2. **Configure the Gemini API**:
   - Obtain API keys from the Gemini API platform.
   - Replace the placeholder API key in the `gemini_api.dart` file with your own API key.

   ```dart
   // lib/Helpers/gemini_api.dart

   String url = 'YOUR_GEMINI_API_KEY';
   ```

3. **Update Firebase Keys**:
   - Replace the placeholder Firebase keys in the Firebase configuration files (`google-services.json` and `GoogleService-Info.plist`) with your own keys obtained from the Firebase console.

### Usage

Follow the instructions below to run the application:

1. **Ensure you have an emulator/device set up for testing.**

2. **Run the application**:

   ```bash
   flutter run
   ```

3. **Access the app** through your emulator/device.

### Additional Notes

- Make sure to replace `YOUR_GEMINI_API_KEY` in `gemini_api.dart` with your actual Gemini API key.
- Ensure that the Firebase configuration files are correctly placed in the specified directories for both Android and iOS.
- For any further inquiries or feedback, users can contact your team at [devshubham652@gmail.com](mailto:devshubham652@gmail.com).

By following these steps, users should be able to configure the app with their own Gemini API key and Firebase credentials successfully.
## Technologies Used

- Flutter
- Firebase (Authentication, Firestore)
- Gemini API
- Other dependencies managed via pubspec.yaml
- 

## Contact Us

For any inquiries or feedback, please contact our team at [devshubham652@gmail.com](mailto:devshubham652@gmail.com).
