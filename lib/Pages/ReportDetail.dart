import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MedicalRecordPage extends StatelessWidget {
  final String date;
  final String doctorName;
  final String symptoms;
  final String medicines;
  final String expenses;
  final List<String> imageLinks;

  const MedicalRecordPage({super.key,
    required this.date,
    required this.doctorName,
    required this.symptoms,
    required this.medicines,
    required this.expenses,
    required this.imageLinks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Medical Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(date),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Doctor Name'),
              subtitle: Text(doctorName),
            ),
            ListTile(
              leading: const Icon(Icons.healing),
              title: const Text('Symptoms'),
              subtitle: Text(symptoms),
            ),
            ListTile(
              leading: const Icon(Icons.local_pharmacy),
              title: const Text('Medicines'),
              subtitle: Text(medicines),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Expenses'),
              subtitle: Text('\₹$expenses'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Images',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: imageLinks
                  .map(
                    (link) => GestureDetector(
                  onTap: () {
                    // Implement image zooming here
                  },
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: link,
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeIn,
                    fadeOutCurve: Curves.easeInOut,
                    fadeInDuration: const Duration(seconds: 1),
                    fadeOutDuration: const Duration(seconds: 1),
                    placeholder: (context, url) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("loading", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),), SizedBox(width: 10,), CircularProgressIndicator()],),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red,),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

