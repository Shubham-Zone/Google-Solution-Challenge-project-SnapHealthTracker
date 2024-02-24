import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DataEntryPage extends StatelessWidget {
  const DataEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: BottomSheetContent(),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  DatabaseReference db = FirebaseDatabase.instance.ref().child("Reports");
  String userid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController symptom = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController doctorName = TextEditingController();
  TextEditingController medicines = TextEditingController();
  TextEditingController totalExpenses = TextEditingController();

  List<String> imageUrls = [];

  bool showImgBtn = true;
  bool processing = false;
  bool buttonProcessing = false;

  hideBtn() {
    setState(() {
      showImgBtn = !showImgBtn;
      processing = !processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Enter your medical detail",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: symptom,
            decoration: InputDecoration(
              labelText: "Enter your symptom",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: dateInput,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today),
              labelText: "Enter Date",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                String formattedDate =
                DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  dateInput.text = formattedDate;
                });
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: doctorName,
            decoration: InputDecoration(
              labelText: "Doctor name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: medicines,
            decoration: InputDecoration(
              labelText: "Medicines",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: totalExpenses,
            decoration: InputDecoration(
              labelText: "Total expense",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: showImgBtn,
            child: ElevatedButton(
              onPressed: () async {
                List<XFile>? files =
                await ImagePicker().pickMultiImage();

                if (files != null && files.isNotEmpty) {
                  setState(() {
                    processing = true;
                  });
                  for (XFile file in files) {
                    await uploadImage(file);
                  }
                  hideBtn();
                }
              },
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      processing ? "Image is uploading.." : "Upload reports pictures",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    processing ? const CircularProgressIndicator(color: Colors.white,) : const Icon(Icons.camera_alt_outlined, size: 40),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  Map<String, dynamic> data = {
                    "Symptom": symptom.text.trim(),
                    "Date": dateInput.text.trim(),
                    "Doctor name": doctorName.text.trim(),
                    "Medicines": medicines.text.trim(),
                    "Total expense": totalExpenses.text.trim(),
                    "Images": imageUrls,
                  };

                  if (symptom.text.isNotEmpty &&
                      dateInput.text.isNotEmpty &&
                      doctorName.text.isNotEmpty &&
                      medicines.text.isNotEmpty &&
                      totalExpenses.text.isNotEmpty &&
                      imageUrls.isNotEmpty) {
                    setState(() {
                      buttonProcessing = true;
                    });
                    await db.child(userid).child(id).set(data).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Report added successfully"),
                      backgroundColor: Colors.green,
                    )));
                    symptom.clear();
                    dateInput.clear();
                    doctorName.clear();
                    medicines.clear();
                    totalExpenses.clear();
                    imageUrls.clear();
                    setState(() {
                      processing = false;
                      buttonProcessing = false;
                      showImgBtn = true;
                    });

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please fill all the details and upload at least one image"),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: buttonProcessing ? const CircularProgressIndicator(color: Colors.white,) : const Text(
                  "Add",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
          Column(
            children: imageUrls
                .map(
                  (url) => Visibility(
                visible: !showImgBtn,
                child: SizedBox(
                  width: double.infinity,
                    child: Image.network(url)),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage(XFile file) async {

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference refenceroot = FirebaseStorage.instance.ref();
    Reference refImgtoUpload = refenceroot.child(uniqueFileName);

    try {
      await refImgtoUpload.putFile(File(file.path));
      String imageUrl = await refImgtoUpload.getDownloadURL();
      setState(() {
        imageUrls.add(imageUrl);
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong"),
        ));
      }
    }
  }

}
