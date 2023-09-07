import 'package:flutter/material.dart';
import '../Teacher/LectureDetailsPage.dart';
import 'LectureDetailsPage_student.dart';

class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  TextEditingController lectureCodeController = TextEditingController();

  String errorMessage = ''; // Add a variable to store the error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: lectureCodeController,
              decoration: InputDecoration(
                labelText: "Enter Lecture Code",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Get the entered lecture code from lectureCodeController.text
                String lectureCode = lectureCodeController.text;

                // Check if the lecture code is not empty
                if (lectureCode.isNotEmpty) {
                  // Navigate to the lecture details page with the entered lecture code.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LectureDetailsPages(lectureCode: lectureCode),
                    ),
                  );
                } else {
                  // Show an error message if the lecture code is empty
                  setState(() {
                    errorMessage = 'Please enter a valid lecture code.';
                  });
                }
              },
              child: Text("Find Lecture"),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
