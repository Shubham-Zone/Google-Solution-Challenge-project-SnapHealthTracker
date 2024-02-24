import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heal_snap/Helpers/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentication/Phone.dart';
import 'Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    // Navigate to the Home page after a delay
    Timer(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool? repeat = prefs.getBool('repeat');
      if (repeat == true) {
        if(mounted){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const NavBar(idx: 0)));
        }

      } else {
        if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Phone()));
      }
  });

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.teal,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "HealSnap",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
