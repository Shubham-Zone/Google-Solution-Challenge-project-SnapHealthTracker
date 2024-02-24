import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:heal_snap/Helpers/gemini_api.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String userid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db = FirebaseDatabase.instance.ref().child("Reports");
  DatabaseReference user = FirebaseDatabase.instance.ref().child("Users");
  List<String> symptoms = [];
  List<String> dates = [];
  String dob = "";
  int age = 0;
  bool isLoading = true;
  int totalExpense = 0;
  String symp = "";
  List<TextSpan> textSpans = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    // Get symptoms and dates
    db.child(userid).onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        data.forEach((key, value) {
          symptoms.add(value["Symptom"]);
          dates.add(value["Date"]);
          totalExpense += int.parse(value["Total expense"].toString());
        });
      }
      setState(() {
        isLoading = false; // Move this inside onDataChange
        symp = symptoms.join(",");
      });
    });

    user.child(userid).onValue.listen((event) {
      setState(() {
        dob = event.snapshot.child("DOB").value.toString();
      });
      calculateAge();
    });
  }

  void calculateAge() {
    DateTime now = DateTime.now();
    DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
    age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
  }

  void processResult(String result) {

    textSpans.clear();

    // Split text into phrases enclosed within "**"
    List<String> phrases = result.split('**');

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

  List<String> findRapidlyRepeatingSymptoms(List<String> symptoms, List<String> dates) {
    List<String> rapidlyRepeatingSymptoms = [];
    for (int i = 0; i < symptoms.length; i++) {
      for (int j = i + 1; j < symptoms.length; j++) {
        if (symptoms[i] == symptoms[j]) {
          DateTime date1 = DateFormat("yyyy-MM-dd").parse(dates[i]);
          DateTime date2 = DateFormat("yyyy-MM-dd").parse(dates[j]);
          Duration difference = date1.difference(date2).abs();
          if (difference.inDays <= 60) {
            if (!rapidlyRepeatingSymptoms.contains(symptoms[i])) {
              rapidlyRepeatingSymptoms.add(symptoms[i]);
            }
          }
        }
      }
    }
    return rapidlyRepeatingSymptoms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Total Medical Expenses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
                subtitle: Text('Total Expenses: ₹$totalExpense'),
              ),
            ),

            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Rapidly Repeating Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
                subtitle: symptoms.isEmpty
                    ? const Text('No rapidly repeating symptoms')
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(symptoms.toSet().length, (index) {
                    String symptom = symptoms.toSet().toList()[index];
                    if (findRapidlyRepeatingSymptoms(symptoms, dates).contains(symptom)) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          symptom,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
              ),
            ),

            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: const Text('Tips for Age-Related Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),),
                subtitle: symp.isNotEmpty
                    ? FutureBuilder(
                  future: GeminiApi.getGeminiData("$symp Are these symptoms serious for age $age? if yes show some tips else just show no serious issue"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Fetching...");
                    } else if (snapshot.hasError) {
                      return const Text('Failed to fetch tips');
                    } else {
                      processResult(snapshot.data.toString());
                      return RichText(
                        text: TextSpan(children: textSpans),
                      );
                      // return FutureBuilder(
                      //   future: GeminiApi.getGeminiData("Tips to fix age-related symptoms: $symptoms"),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return const Text("Fetching...");
                      //     } else if (snapshot.hasError) {
                      //       return const Text('Failed to fetch tips');
                      //     } else {
                      //       processResult(snapshot.data.toString());
                      //       return RichText(
                      //         text: TextSpan(children: textSpans),
                      //       );
                      //     }
                      //   },
                      // );
                    }
                  },
                )
                    : const Text('No tips available'),
              ),
            ),

          ],
        ),
      ),
    );
  }

}
