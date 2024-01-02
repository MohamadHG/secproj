import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'dart:convert';

const String _baseURL = 'presentable-recruit.000webhostapp.com';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const CreateEventPage(),
    ),
  );
}

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Color eventIconColor = Colors.grey;
  Color dateIconColor = Colors.grey;
  Color timeIconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _eventController.addListener(_updateEventIconColor);
    _dateController.addListener(_updateDateIconColor);
    _timeController.addListener(_updateTimeIconColor);
  }

  void _updateEventIconColor() {
    setState(() {
      eventIconColor =
          _eventController.text.isNotEmpty ? Colors.black : Colors.grey;
    });
  }

  void _updateDateIconColor() {
    setState(() {
      dateIconColor =
          _dateController.text.isNotEmpty ? Colors.black : Colors.grey;
    });
  }

  void _updateTimeIconColor() {
    setState(() {
      timeIconColor =
          _timeController.text.isNotEmpty ? Colors.black : Colors.grey;
    });
  }

  Future<void> _insertDataToDatabase() async {
    final String event = _eventController.text;
    final String date = _dateController.text;
    final String time = _timeController.text;
    String formattedTime = DateFormat('HH:mm:ss').format(
      DateFormat('h:mm a').parse(time),
    );

    final url = Uri.https(_baseURL, 'create_event.php');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'event_name': event,
        'event_date': date,
        'event_time': time,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      _eventController.clear();
      _dateController.clear();
      _timeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event Created Successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      print('Event inserted successfully');
    } else {
      print('Error inserting event: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _eventController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create Event',
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextFieldWithTitle(
                    'Event', _eventController, Icons.event, eventIconColor),
                const SizedBox(height: 20.0),
                _buildDatePickerTextField(
                    'Date', _dateController, Icons.calendar_today, dateIconColor),
                const SizedBox(height: 20.0),
                _buildTimePickerTextField(
                    'Time', _timeController, Icons.access_time, timeIconColor),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _insertDataToDatabase();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        minimumSize: const Size(80.0, 40.0),
                      ),
                      child: const Text(
                        'Create',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 30.0,
        color: Colors.black,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2024 A & M. All Rights Reserved.',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithTitle(String title,
      TextEditingController controller, IconData prefixIcon, Color iconColor) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          if (controller.text.isEmpty) {
            if (title == 'Event') {
              eventIconColor = Colors.black;
            } else if (title == 'Date') {
              dateIconColor = Colors.black;
            } else if (title == 'Time') {
              timeIconColor = Colors.black;
            }
          }
        });
      },
      onExit: (_) {
        setState(() {
          if (controller.text.isEmpty) {
            if (title == 'Event') {
              eventIconColor = Colors.grey;
            } else if (title == 'Date') {
              dateIconColor = Colors.grey;
            } else if (title == 'Time') {
              timeIconColor = Colors.grey;
            }
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Container(
            width: 500,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.text.isNotEmpty ? Colors.black : Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              cursorColor: Colors.black,
              controller: controller,
              onChanged: (text) {
                if (text.isEmpty) {
                  if (title == 'Event') {
                    eventIconColor = Colors.grey;
                  } else if (title == 'Date') {
                    dateIconColor = Colors.grey;
                  } else if (title == 'Time') {
                    timeIconColor = Colors.grey;
                  }
                } else {
                  if (title == 'Event') {
                    eventIconColor = Colors.black;
                  } else if (title == 'Date') {
                    dateIconColor = Colors.black;
                  } else if (title == 'Time') {
                    timeIconColor = Colors.black;
                  }
                }
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Enter $title...',
                hintStyle: const TextStyle(fontSize: 16.0),
                contentPadding: const EdgeInsets.all(18.0),
                border: InputBorder.none,
                prefixIcon: Icon(
                  prefixIcon,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerTextField(String title,
      TextEditingController controller, IconData prefixIcon, Color iconColor) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          if (controller.text.isEmpty) {
            dateIconColor = Colors.black;
          }
        });
      },
      onExit: (_) {
        setState(() {
          if (controller.text.isEmpty) {
            dateIconColor = Colors.grey;
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              if (title == 'Date') {
                _selectDate(context, controller);
              }
            },
            child: AbsorbPointer(
              child: Container(
                width: 500,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.text.isNotEmpty ? Colors.black : Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter $title...',
                    hintStyle: const TextStyle(fontSize: 16.0),
                    contentPadding: const EdgeInsets.all(18.0),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      prefixIcon,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white70, 
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white, 
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Widget _buildTimePickerTextField(String title,
      TextEditingController controller, IconData prefixIcon, Color iconColor) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          if (controller.text.isEmpty) {
            timeIconColor = Colors.black;
          }
        });
      },
      onExit: (_) {
        setState(() {
          if (controller.text.isEmpty) {
            timeIconColor = Colors.grey;
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              if (title == 'Time') {
                _selectTime(context, controller);
              }
            },
            child: AbsorbPointer(
              child: Container(
                width: 500,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        controller.text.isNotEmpty ? Colors.black : Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter $title...',
                    hintStyle: const TextStyle(fontSize: 16.0),
                    contentPadding: const EdgeInsets.all(18.0),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      prefixIcon,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white, 
              onPrimary: Colors.white, 
              surface: Colors.black, 
              onSurface: Colors.white, 
            ),
            dialogBackgroundColor: Colors.black,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String formattedTime = picked.format(context);
      setState(() {
        controller.text =
            formattedTime; 
      });
    }
  }


}
