import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NearbyPlacesScreen extends StatefulWidget {
  const NearbyPlacesScreen({super.key});

  @override
  _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  List<dynamic> _places = [];

  @override
  void initState() {
    super.initState();
    fetchNearbyPlaces();
  }

  Future<void> fetchNearbyPlaces() async {
    const apiKey = 'YOUR_API_KEY';
    const latitude = 37.7749; // Your current latitude
    const longitude = -122.4194; // Your current longitude
    const radius = 5000; // Search radius in meters
    const type = 'pharmacy'; // Type of place you're searching for

    const url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$latitude,$longitude'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _places = data['results'];
      });
    } else {
      throw Exception('Failed to load nearby places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Medical Stores'),
      ),
      body: ListView.builder(
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index];
          return Card(
            child: ListTile(
              title: Text(place['name']),
              subtitle: Text(place['vicinity']),
              // You can add more details or functionality here
            ),
          );
        },
      ),
    );
  }
}
