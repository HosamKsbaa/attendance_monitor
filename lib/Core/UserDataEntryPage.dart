import 'package:attendance_monitor/Core/sign_in.dart';
import 'package:attendance_monitor/Student%20/Student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Teacher/Teacher.dart';

class UserDataEntryPage extends StatefulWidget {
  @override
  _UserDataEntryPageState createState() => _UserDataEntryPageState();
}

class _UserDataEntryPageState extends State<UserDataEntryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  late SharedPreferences _prefs;
  bool _hasUserData = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    final hasUserData = _prefs.getBool('hasUserData') ?? false;
    setState(() {
      _hasUserData = hasUserData;
    });
  }

  Future<void> _storeUserData() async {
    await _prefs.setBool('hasUserData', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Enter Your Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: "Enter Your ID",
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Future<void> x() async {
                  final String name = nameController.text;

                  // Store the user's name in shared_preferences
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('userName', name);
                  await prefs.setString('userid', name);

                  // Store that user data is available
                  await _storeUserData();
                }

                x();

                // Navigate to the teacher or student page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Student(),
                  ),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
