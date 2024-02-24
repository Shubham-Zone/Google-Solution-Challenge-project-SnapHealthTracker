import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {

  String userid = FirebaseAuth.instance.currentUser!.uid;

  final DatabaseReference appointment = FirebaseDatabase.instance.ref().child("Appointments");

  // Future<List<Appointment>> _gettingAppointments() async {
  //   Completer<List<Appointment>> completer = Completer<List<Appointment>>();
  //
  //   appointment.child(userid).onValue.listen((DatabaseEvent event) {
  //     Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
  //     List<Appointment> appointments = data.entries.map((e) => Appointment(e.key, e.value)).toList();
  //     completer.complete(appointments);
  //   });
  //
  //   return completer.future;
  // }


  @override
  void initState() {
    // _gettingAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.teal, // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: FirebaseAnimatedList(
                  query: appointment.child(userid),
                  defaultChild: const Center(child: CircularProgressIndicator(color: Colors.teal,),),
                  itemBuilder: (context, DataSnapshot snapshot, Animation<double> animation, int index){
                    return GestureDetector(
                      onLongPress: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Do you wish to delete ${snapshot.child("Doctor").value} appointment ?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    appointment.child(userid).child(snapshot.key.toString()).remove();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${snapshot.child("Doctor").value} appointment deleted successfully"),backgroundColor: Colors.green,));
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: Colors.teal,
                                value: snapshot.child("Status").value == "1",
                                onChanged: (bool? value) {
                                  setState(() {
                                    String key = snapshot.key.toString();
                                    String val = snapshot.child("Status").value.toString();
                                    appointment.child(userid).child(key).child("Status").set(val == "1" ? "0" : "1");
                                  });
                                },
                              ),
                              Expanded(
                                flex: 5, // Adjust flex as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.child("Doctor").value}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.teal, // Custom text color
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Location: ${snapshot.child("Location").value}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800], // Dark grey text color
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Time: ${snapshot.child("Time").value}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800], // Dark grey text color
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    Text(
                                      'Date: ${snapshot.child("Date").value}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800], // Dark grey text color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("Do you wish to delete ${snapshot.child("Doctor").value} appointment ?"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              appointment.child(userid).child(snapshot.key.toString()).remove();
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${snapshot.child("Doctor").value} appointment deleted successfully"),backgroundColor: Colors.green,));
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed:() => Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const AddAppointment(),
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
              ),),
              icon: const Icon(Icons.add, color:Colors.white),
              label: const Text('Add Appointment', style:TextStyle(color:Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ), // Custom button color
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class AddAppointment extends StatefulWidget {
  const AddAppointment({super.key});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  String userid = FirebaseAuth.instance.currentUser!.uid;

  final DatabaseReference appointment = FirebaseDatabase.instance.ref().child("Appointments");

  void _saveAppointment() {

    String id = DateTime.now().millisecondsSinceEpoch.toString();

    final doctor = _doctorController.text;
    final location = _locationController.text;

    if (doctor.isNotEmpty && location.isNotEmpty) {
      Map<String, String> data = {
        "Doctor": doctor,
        "Location": location,
        "Date": dateInput.text,
        "Time": "${time.hour>12 ? time.hour - 12 : time.hour}:${time.minute.toString()} ${time.hour > 12 ? "pm" : "am"}",
        "Status": "0"
      };

      appointment.child(userid).child(id).set(data).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment booked successfully'), backgroundColor: Colors.green,),));

    }

  }

  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController dateInput = TextEditingController();
  TimeOfDay time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book an Appointment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal, // Title color
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _doctorController,
                  decoration: InputDecoration(
                    labelText: 'Doctor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateInput,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Time: ${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal, // Time text color
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (newTime != null) {
                          setState(() {
                            time = newTime;
                          });
                        }
                      },
                      child: const Text(
                        'Select Time',
                        style: TextStyle(
                          color: Colors.teal, // Button text color
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_doctorController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        dateInput.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all fields',
                            style: TextStyle(color: Colors.white), // SnackBar text color
                          ),
                          backgroundColor: Colors.red, // SnackBar background color
                        ),
                      );
                    } else {
                      _saveAppointment();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white), // Button text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

class Appointment {

  final dynamic key;
  final dynamic value;

  Appointment(this.key, this.value);
}
