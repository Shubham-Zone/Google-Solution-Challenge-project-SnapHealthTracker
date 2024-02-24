import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:heal_snap/Helpers/Provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Helpers/Tips.dart';
import 'Analysis.dart';
import 'DataEntery.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String date = "";
  String time = "";

  DateTime _focusedDay = DateTime.now();

  final StreamController<DateTime> _dateTimeController = StreamController<DateTime>.broadcast();

  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);

    setState(() {
      date = formattedDate;
      time = formattedTime;
    });

    _dateTimeController.add(now);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  static String userid = FirebaseAuth.instance.currentUser!.uid;

  DateTime? parseDateString(String dateString) {
    try {
      List<String> parts = dateString.split('-');
      if (parts.length == 3) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);
        return DateTime(year, month, day);
      } else {
        // print("Invalid date format: $dateString");
        return null;
      }
    } catch (e) {
      // print("Error parsing date: $dateString, Error: $e");
      return null;
    }
  }

  DatabaseReference report = FirebaseDatabase.instance.ref().child("Reports").child(userid);

  List<DateTime> toHighlight = [];

  void getHighlightedDates() {
    report.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? reports =
            event.snapshot.value as Map<dynamic, dynamic>?; // Explicit cast
        if (reports != null) {
          reports.forEach((key, value) {
            String? dateString = value[
                "Date"]; // Adjust this according to your database structure
            if (dateString != null) {
              DateTime? date = parseDateString(dateString);
              if (date != null) {
                toHighlight.add(date);
              }
            } else {
              // print("Date is null for entry: $key");
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    getCurrentDateTime();
    getHighlightedDates();
    Timer.periodic(
        const Duration(seconds: 1), (Timer t) => getCurrentDateTime());
    super.initState();
  }

  @override
  void dispose() {
    _dateTimeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<ReportsProvider>(context);

    userProvider.getPatientDetail();

    userProvider.greeting();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DataEntryPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = TweenSequence([
                    TweenSequenceItem(
                        tween: Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve)),
                        weight: 1),
                  ]);

                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
                transitionDuration:
                    const Duration(seconds: 1), // Adjust the duration here too
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white,),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Consumer<ReportsProvider>(
                  builder: (context, user, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (user.gender == "female")
                                ? const Icon(
                                    Icons.female,
                                    color: Colors.pinkAccent,
                                    size: 50,
                                  )
                                : const Icon(
                                    Icons.male,
                                    size: 50,
                                  ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.greet,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                const SymptomTipsScreen(),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = TweenSequence([
                                    TweenSequenceItem(
                                        tween: Tween(begin: begin, end: end)
                                            .chain(CurveTween(curve: curve)),
                                        weight: 1),
                                  ]);

                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                      position: offsetAnimation, child: child);
                                },
                                transitionDuration:
                                const Duration(seconds: 1), // Adjust the duration here too
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates_outlined,
                                size: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Tips",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<DateTime>(
                  stream: _dateTimeController.stream,
                  builder: (context, snapshot) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade400,
                            Colors.teal.shade700
                          ], // Add a gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      for (DateTime d in toHighlight) {
                        if (day.day == d.day &&
                            day.month == d.month &&
                            day.year == d.year) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.all(4),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      }
                      return null;
                    },
                  ),
                  onPageChanged: (DateTime focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalysisPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bubble_chart_outlined,
                                color: Colors.teal,
                                size: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Analysis",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                // Card(
                //   elevation: 10,
                //   color: Colors.blueAccent,
                //   margin: const EdgeInsets.only(bottom: 10),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.all(16.0),
                //     child: Column(
                //       children: [
                //         Text(
                //           "Stay positive and spread good vibes!",
                //           style: TextStyle(
                //             fontSize: 18,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         SizedBox(height: 10),
                //         Text(
                //           "You are capable of amazing things.",
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.white
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

}
