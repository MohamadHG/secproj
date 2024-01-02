import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({Key? key}) : super(key: key);

  @override
  _VolunteerPageState createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  List<Map<String, dynamic>> volunteerDetails = [];
  List<Map<String, dynamic>> filteredVolunteerDetails = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVolunteerDetails();
  }

  Future<void> showSuccessAlert() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
            'You have successfully volunteered!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchVolunteerDetails() async {
    final Uri url = Uri.https('presentable-recruit.000webhostapp.com', 'fetch_events.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          volunteerDetails =
              List<Map<String, dynamic>>.from(json.decode(response.body)) ?? [];
          filteredVolunteerDetails = volunteerDetails;
        });
      } else {
        print(
            'Failed to fetch volunteer details. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching volunteer details: $error');
    }
  }

  Future<void> volunteerForEvent(String eventId, String eventName) async {
    final Uri url = Uri.https('presentable-recruit.000webhostapp.com', 'create_volunteer.php');

    try {
      final response = await http.post(
        url,
        body: {'event_id': eventId, 'event_name': eventName},
      );

      if (response.statusCode == 200) {
        print('Volunteering successful');
        showSuccessAlert();
      } else {
        print('Failed to volunteer. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error volunteering: $error');
    }
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> searchList = [];
    searchList.addAll(volunteerDetails);

    if (query.isNotEmpty) {
      List<Map<String, dynamic>> resultList = [];
      searchList.forEach((item) {
        if (item['event_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          resultList.add(item);
        }
      });
      setState(() {
        filteredVolunteerDetails = resultList;
      });
    } else {
      setState(() {
        filteredVolunteerDetails = volunteerDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Volunteer',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              cursorColor: Colors.black,
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 8.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextButton(
                              onPressed: () {
                                filterSearchResults(searchController.text);
                              },
                              child: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredVolunteerDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = filteredVolunteerDetails[index];
                      final title = event['event_name'];
                      final date = event['event_date'];
                      final time = event['event_time'];
                      final eventId = event['id'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          'Date: ${DateFormat.yMMMMd().format(DateTime.parse(date))}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          'Time: ${DateFormat.jm().format(DateFormat('HH:mm').parse(time))}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showVolunteerAlert(eventId, title);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 20.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        'Volunteer',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Moved the "Remove" button to the new Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showRemoveConfirmation(eventId, title);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 26.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
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
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2024 A & M. All Rights Reserved.',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ],
        ),
        height: 30.0,
        color: Colors.black,
      ),
    );
  }

  Future<void> showVolunteerAlert(
      String eventId, String eventName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Volunteering',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Do you want to volunteer for $eventName?',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18.0)),
            ),
            TextButton(
              onPressed: () {
                volunteerForEvent(eventId, eventName);
                Navigator.of(context).pop();
              },
              child: const Text('Volunteer',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18.0)),
            ),
          ],
        );
      },
    );
  }

  Future<void> showRemoveConfirmation(
      String eventId, String eventName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Do you want to remove $eventName?',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18.0)),
            ),
            TextButton(
              onPressed: () {
                removeEvent(eventId);
                Navigator.of(context).pop();
              },
              child: const Text('Remove',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18.0)),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeEvent(String eventId) async {
    final Uri url = Uri.https('presentable-recruit.000webhostapp.com', 'delete_event.php');

    try {
      final response = await http.post(
        url,
        body: {'id': eventId},
      );

      if (response.statusCode == 200) {
        print('Event removed successfully');
        fetchVolunteerDetails();
      } else {
        print('Failed to remove event. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing event: $error');
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: VolunteerPage(),
  ));
}
