import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:google_fonts/google_fonts.dart'; 

class DisplayEventsPage extends StatefulWidget {
  const DisplayEventsPage({Key? key}) : super(key: key);

  @override
  _DisplayEventsPageState createState() => _DisplayEventsPageState();
}

class _DisplayEventsPageState extends State<DisplayEventsPage> {
  List<Map<String, String>> events = [];

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse('https://presentable-recruit.000webhostapp.com/display_volunteer.php'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((event) {
            return {
              'vid': event['vid'].toString(),
              'name': event['name'].toString(),
              'event_id': event['event_id'].toString(),
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  Future<void> _removeEvent(int index) async {
    final vidToRemove = events[index]['vid'];

    try {
      final response = await http.post(
        Uri.parse('https://presentable-recruit.000webhostapp.com/remove_volunteer.php'),
        body: {
          'vid': vidToRemove,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event Removed Successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        setState(() {
          events.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete event: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing event: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Display Events',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Event Title: ${event['name']}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _removeEvent(index);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'Remove',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 30.0,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2024 A & M. All Rights Reserved.',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
    ),
    home: const DisplayEventsPage(),
  ));
}
