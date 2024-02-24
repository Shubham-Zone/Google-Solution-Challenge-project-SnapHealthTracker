import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:heal_snap/Helpers/gemini_api.dart';
import 'package:lottie/lottie.dart';

class SymptomTipsScreen extends StatefulWidget {
  const SymptomTipsScreen({Key? key}) : super(key: key);

  @override
  _SymptomTipsScreenState createState() => _SymptomTipsScreenState();
}

class _SymptomTipsScreenState extends State<SymptomTipsScreen> {

  bool _isLoading = true;
  List<dynamic> symptoms = [];
  String userid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db = FirebaseDatabase.instance.ref().child("Reports");
  RxString result = "".obs;
  List<TextSpan> textSpans = [];

  void gettingSymptomsList() async {
    setState(() {
      _isLoading = true;
    });

    db.child(userid).onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> symptomsList = [];

      data.forEach((key, userData) {
        if (userData != null && userData.containsKey("Symptom") && userData.containsKey("Date")) {
          symptomsList.add({
            "symptom": userData["Symptom"],
            "date": userData["Date"]
          });
        }
      });

      // Sort symptomsList based on date in descending order
      symptomsList.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

      symptoms.clear();

      // Extract symptoms from sorted list
      symptoms = symptomsList.map((entry) => entry["symptom"]).toList();

      String symp = symptoms.join(',');

      GeminiApi.getGeminiData("Tell me the tips for the following symptoms $symp").then((value) {
        setState(() {
          result.value = value;
          _isLoading = false;
          processResult();
        });
      });
    });
  }

  @override
  void initState() {
    gettingSymptomsList();
    super.initState();
  }

  void processResult() {

    textSpans.clear();

    // Split text into phrases enclosed within "**"
    List<String> phrases = result.value.split('**');

    // Initialize a boolean flag to track if the current phrase is bold
    bool isBold = false;

    // Iterate through phrases
    for (String phrase in phrases) {
      // Toggle the flag for each phrase
      isBold = !isBold;

      // Apply different style if the phrase is bold
      textSpans.add(
        (phrase.trim() == '*') ? TextSpan(text: phrase, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.teal)) :
        TextSpan(
          text: phrase,
          style: isBold
              ? const TextStyle(
              fontSize: 18,
              color: Colors.black
          )
              : const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
            fontSize: 22,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Symptom Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: Lottie.asset("assets/lottie/loading.json", height: 300, fit: BoxFit.cover))
          : result.isNotEmpty
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: textSpans),
              )
            ],
          ),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No tips available.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                gettingSymptomsList();
              },
              child: const Text("Retry"),
            )
          ],
        ),
      ),
    );
  }
}
