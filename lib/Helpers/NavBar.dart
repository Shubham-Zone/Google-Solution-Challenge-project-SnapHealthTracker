import 'package:flutter/material.dart';
import 'package:heal_snap/Pages/Appointments.dart';
import 'package:heal_snap/Pages/HeartBeat.dart';
import '../Pages/Home.dart';
import '../Pages/Profile.dart';
import '../Pages/Records.dart';

class NavBar extends StatefulWidget {

  final int idx;

  const NavBar({super.key, required this.idx});

  @override
  State<NavBar> createState() => _NavBarState();

}

class _NavBarState extends State<NavBar> {

  late int index;

  // List of pages
  List pages = [
    const Home(),
    const Records(),
    const Appointments(),
    const Profile(),
    // const HomePage()
  ];

  @override
  void initState() {
    index = widget.idx;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.teal.withOpacity(0.7),
        ), child: NavigationBar(
        selectedIndex: index,
        elevation: 8,
        height: MediaQuery.of(context).size.height * 0.085,
        onDestinationSelected: (index) =>
        setState(()=> this.index = index),
        destinations:const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.medical_information), label: "Records"),
          NavigationDestination(icon: Icon(Icons.people_alt), label: "Appointments"),
          NavigationDestination(icon: Icon(Icons.person_2), label: "Profile"),
          // NavigationDestination(icon: Icon(Icons.monitor_heart), label: "HeartBeat"),
        ],
      ),
      ),
    );
  }
}
