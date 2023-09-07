import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'StudentListPage.dart';

class LectureDetailsPage extends StatelessWidget {
  final String lectureId;

  LectureDetailsPage({required this.lectureId});

  Future<List<String>> getStudentNames() async {
    final lectureDoc = await FirebaseFirestore.instance
        .collection('lectures')
        .doc(lectureId)
        .get();
    final lectureData = lectureDoc.data() as Map<String, dynamic>;
    final numberOfStudents = lectureData['numberOfStudents'] as int;

    final studentNames = <String>[];

    if (numberOfStudents > 0) {
      final studentIds = List<String>.from(lectureData['studentIds']);
      for (final studentId in studentIds) {
        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();
        final studentData = studentDoc.data() as Map<String, dynamic>;
        final studentName = studentData['name'] as String;
        studentNames.add(studentName);
      }
      studentNames.sort(); // Sort student names alphabetically
    }

    return studentNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecture Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lectures')
            .doc(lectureId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final lectureData = snapshot.data!.data() as Map<String, dynamic>;
          final lectureName = lectureData['lectureName'] as String;

          return Column(
            children: [
              ListTile(
                title: Text('Lecture Name: $lectureName'),
              ),
              QrImage(
                data: lectureId, // You can use lectureId as QR data
                version: QrVersions.auto,
                size: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentListPage(lectureId: lectureId),
                    ),
                  );
                },
                child: Text('Show Student List'),
              ),
              Visibility(
                visible: lectureId.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Lecture Code: $lectureId"),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () async {
                        await FlutterClipboard.copy(
                            lectureId); // Copy the lecture code
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lecture code copied")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
