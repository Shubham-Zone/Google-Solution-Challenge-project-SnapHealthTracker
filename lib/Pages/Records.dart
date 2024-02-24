import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'ReportDetail.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();

}

class _RecordsState extends State<Records> {
  
  String userid = FirebaseAuth.instance.currentUser!.uid;
  
  DatabaseReference db = FirebaseDatabase.instance.ref().child("Reports");

  String data = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:const Center(child: Text("Medical records", style: TextStyle(fontWeight: FontWeight.bold),)),
      ),
      body:FirebaseAnimatedList(
          query: db.child(userid).orderByChild("Date"),
          reverse: true,
          defaultChild: const Center(child: CircularProgressIndicator(color: Colors.teal,),),
          itemBuilder: (context, DataSnapshot snapshot, Animation<double> animation, int index){
           return GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) =>
                   MedicalRecordPage(date: snapshot.child("Date").value.toString(), doctorName: snapshot.child("Doctor name").value.toString(), symptoms: snapshot.child("Symptom").value.toString(), medicines: snapshot.child("Medicines").value.toString(), expenses: snapshot.child("Total expense").value.toString(), imageLinks: getImageLinks(snapshot),)));
             },
             onLongPress: (){
                         showDialog(
                             context: context,
                             builder: (BuildContext context){
                               return AlertDialog(
                                 content: Text("Do you wish to delete ${snapshot.child("Symptom").value} report"),
                                 actions: [
                                   ElevatedButton(
                                       onPressed: (){
                                         db.child(userid).child(snapshot.key.toString()).remove().whenComplete(() { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${snapshot.child("Symptom").value} report deleted successfully"), backgroundColor: Colors.green,));
                                         Navigator.pop(context);
                                         });
                                       },
                                       child: const Text("Yes")
                                   ),
                                   ElevatedButton(
                                       onPressed: (){
                                         Navigator.pop(context);
                                       },
                                       child: const Text("No")
                                   )
                                 ],
                               );

                       }
               );
             },
             child: Card(
               elevation: 10,
               margin: const EdgeInsets.all(10),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15),
               ),
               child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   gradient: LinearGradient(
                     colors: [Colors.teal.shade400, Colors.teal.shade700],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                 ),
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Text(
                             "Symptom",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           const SizedBox(height: 12),
                           Text(
                             "${snapshot.child("Symptom").value}",
                             style: const TextStyle(
                               color: Colors.white,
                               fontSize: 18,
                             ),
                           ),
                           const SizedBox(height: 20),
                           RichTextWidget(
                             icon: Icons.calendar_today,
                             label: "Date",
                             value: "${snapshot.child("Date").value}",
                           ),
                           const SizedBox(height: 12),
                           RichTextWidget(
                             icon: Icons.person,
                             label: "Doctor",
                             value: "${snapshot.child("Doctor name").value}",
                           ),
                           const SizedBox(height: 12),
                           RichTextWidget(
                             icon: Icons.local_pharmacy,
                             label: "Medicines",
                             value: "${snapshot.child("Medicines").value}",
                           ),
                           const SizedBox(height: 12),
                           RichTextWidget(
                             icon: Icons.attach_money,
                             label: "Expenses",
                             value: "${snapshot.child("Total expense").value}",
                           ),

                         ],
                       ),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         mainAxisSize: MainAxisSize.max,
                         children: [
                           // Icon(
                           //   Icons.local_hospital,
                           //   color: Colors.white,
                           // ),
                           GestureDetector(
                             onTap: (){
                               showDialog(
                                   context: context,
                                   builder: (BuildContext context){
                                     return AlertDialog(
                                       content: Text("Do you wish to delete ${snapshot.child("Symptom").value} report"),
                                       actions: [
                                         ElevatedButton(
                                             onPressed: (){
                                               db.child(userid).child(snapshot.key.toString()).remove().whenComplete(() { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${snapshot.child("Symptom").value} report deleted successfully"), backgroundColor: Colors.green,));
                                               Navigator.pop(context);
                                               });
                                             },
                                             child: const Text("Yes")
                                         ),
                                         ElevatedButton(
                                             onPressed: (){
                                               Navigator.pop(context);
                                             },
                                             child: const Text("No")
                                         )
                                       ],
                                     );

                                   }
                               );
                             },
                             child: const Icon(
                               Icons.delete,
                               color: Colors.white,
                               size: 50,
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                 ),
               ),
             ),
           );

          }
      )
    );
  }
}

class RichTextWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const RichTextWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: "$label: ",
                style:const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    );
  }
}

List<String> getImageLinks(DataSnapshot snapshot) {
  List<String> imageLinks = [];

  // Assuming 'Images' is a child in the snapshot
  var imagesData = snapshot.child("Images").value as List<dynamic>?;

  if (imagesData != null) {
    // Check if it's a List
    for (var value in imagesData) {
      if (value is String) {
        imageLinks.add(value);
      }
    }
  }

  return imageLinks;
}

