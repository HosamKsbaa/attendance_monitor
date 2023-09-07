import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Core/sign_in.dart';

class LectureDetailsPages extends StatefulWidget {
  final String lectureCode;

  LectureDetailsPages({required this.lectureCode});

  @override
  _LectureDetailsPagesState createState() => _LectureDetailsPagesState();
}

class _LectureDetailsPagesState extends State<LectureDetailsPages> {
  late DocumentSnapshot lectureSnapshot;
  bool lectureExists = true;
  bool isLoading = true; // Added to track loading state

  @override
  void initState() {
    super.initState();
    // Retrieve lecture details based on the lecture code entered by the student.
    FirebaseFirestore.instance
        .collection('lectures')
        .doc(widget.lectureCode) // Use the lecture code as the document ID
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          lectureSnapshot = documentSnapshot;
          isLoading = false; // Set loading state to false when data is received
        });
      } else {
        setState(() {
          lectureExists = false;
          isLoading =
              false; // Set loading state to false even if lecture doesn't exist
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture Details'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Display loading indicator
            )
          : lectureExists
              ? lectureSnapshot != null
                  ? Column(
                      children: [
                        ListTile(
                          title: Text(
                              'Lecture Name: ${lectureSnapshot['lectureName']}'),
                        ),
                        // Add more lecture details here as needed.

                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // Create a new student document with a unique ID.
                              final newStudentDocRef = FirebaseFirestore
                                  .instance
                                  .collection('lectures')
                                  .doc(widget.lectureCode)
                                  .collection('students')
                                  .doc();

                              // Define the student data you want to store. You can add more fields as needed.
                              final studentData = {
                                'name': getid()
                                    .displayName, // Replace with the student's name.
                                'studentId': getid()
                                    .uid, // Replace with the student's ID.
                                'timestamp': FieldValue
                                    .serverTimestamp(), // Record the timestamp when the student joined.
                              };

                              // Set the data for the new student document.
                              await newStudentDocRef.set(studentData);

                              // Inform the user that they have successfully joined the lecture.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'You have successfully joined the lecture.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // Close the dialog.
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              print('Error joining lecture: $e');
                              // Handle any errors that occur during the process.
                            }
                          },
                          child: const Text('Join Lecture'),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'The lecture with code "${widget.lectureCode}" does not exist.'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Go back to the previous page
                        },
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
