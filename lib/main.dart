import 'package:flutter/material.dart';
import 'package:heal_snap/Helpers/Provider.dart';
import 'package:heal_snap/Pages/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ReportsProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Medical records",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
          // colorScheme: const ColorScheme.light().copyWith(primary: Colors.teal),
          // primaryColor: Colors.teal,
          // indicatorColor: Colors.teal,
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          // ···
          brightness: Brightness.light,
        ),
          // primarySwatch: Colors.teal,
          // appBarTheme: const AppBarTheme(
          //   color: Colors.teal, // Set app bar background color to teal
          //   iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
          //   titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Set app bar text color to white
          // ),
          // bottomNavigationBarTheme: BottomNavigationBarThemeData(
          //   backgroundColor: Colors.teal, // Set bottom navigation bar background color to teal
          //   selectedItemColor: Colors.teal.withOpacity(0.7), // Set selected item text/icon color to white
          // ),
        //   navigationBarTheme: NavigationBarThemeData(
        //   backgroundColor: Colors.teal,
        //   indicatorColor: Colors.teal.withOpacity(0.7),
        // ),
        //   buttonTheme: const ButtonThemeData(
        //   buttonColor: Colors.teal,
        //
        // ),
          //   textTheme: const TextTheme(
        //     bodyLarge: TextStyle(color: Colors.white)
        // ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal, // Text color
            ),
          ),
          //   floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //   backgroundColor: Colors.teal,
        // ),
        //   primaryTextTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
        //   iconTheme: const IconThemeData(color: Colors.teal, size: 60),
        //   focusColor: Colors.tealAccent
      ),
    );
  }

}
