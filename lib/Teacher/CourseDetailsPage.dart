import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'AddLecturePage.dart';
import 'LectureDetailsPage.dart';
import 'Teacher.dart'; // Import your LectureDetailsPage if not already imported

class CourseDetailsPage extends StatelessWidget {
  final String courseId;

  CourseDetailsPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Mod>().x),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final courseData = snapshot.data!.data() as Map<String, dynamic>;
          final courseName = courseData['name'] as String;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('lectures')
                .where('courseId', isEqualTo: courseId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final lectures = snapshot.data!.docs;

              return ListView.builder(
                itemCount: lectures.length,
                itemBuilder: (context, index) {
                  final lectureData =
                  lectures[index].data() as Map<String, dynamic>;
                  final lectureName = lectureData['lectureName'] as String;
                  final lectureId = lectures[index].id;

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the lecture details page when the lecture is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LectureDetailsPage(lectureId: lectureId),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.meeting_room_sharp),
                          title: Text('Lecture ${index + 1}: $lectureName'),
                          // Add more lecture information here if needed
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to a page to add new lectures
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLecturePage(courseId: courseId),
            ),
          );
        },
      ),
    );
  }
}
