import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentListPage extends StatelessWidget {
  final String lectureId;

  StudentListPage({required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lectures')
            .doc(lectureId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }

          final lectureData = snapshot.data!.data() as Map<String, dynamic>;
          final lectureName = lectureData['lectureName'] as String;

          final studentDocs = snapshot.data!.reference.collection('students');

          return  Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: studentDocs.snapshots(),
              builder: (context, studentSnapshot) {
                if (studentSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (studentSnapshot.hasError) {
                  return Center(
                    child: Card(
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Error: ${studentSnapshot.error}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final studentList = studentSnapshot.data!.docs;
                final studentNames = studentList
                    .map((doc) => {
                  'name': doc['name'] as String,
                  'studentId': doc['studentId'] as String,
                  'timestamp': doc['timestamp'] as Timestamp,
                })
                    .toList();

                // Sort students by submission date (timestamp)
                studentNames.sort(
                      (a, b) =>
                      (b['timestamp'] as Timestamp)
                          .toDate()
                          .compareTo((a['timestamp'] as Timestamp).toDate()),
                );

                return Column(
                  children: [
                    Text(
                      'Number of Students: ${studentNames.length}', // Add the student counter here
                      style: TextStyle(fontSize: 18),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: studentNames.length,
                        itemBuilder: (context, index) {
                          final student = studentNames[index];
                          final studentName = student['name'] as String;
                          final studentId = student['studentId'] as String;
                          final submissionDate =
                          (student['timestamp'] as Timestamp).toDate();

                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.all(7),
                            child: ListTile(
                              leading: Icon(Icons.person), // Add an icon here
                              title: Text(studentName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Submitted on: ${submissionDate.toString()}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
