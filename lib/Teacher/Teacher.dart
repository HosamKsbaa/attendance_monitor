import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'Add_Course.dart';
import 'CourseDetailsPage.dart';

class teacher extends StatefulWidget {
  final String teacherId; // Pass the teacher's ID as a parameter
  const teacher({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<teacher> createState() => _teacherState();
}

class Mod {
  final String x;

  Mod({required this.x});
}

class _teacherState extends State<teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const add_course()),
          );
        },
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Create a stream that listens for changes in the courses collection
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('teacherId', isEqualTo: widget.teacherId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator(); // Loading indicator
          }

          // Extract the list of courses from the snapshot
          final courses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final courseData = courses[index].data() as Map<String, dynamic>;
              final courseName = courseData['name'] as String;

              // Inside your teacher widget's ListView.builder
              return GestureDetector(
                onTap: () {
                  final courseId =
                      courses[index].id; // Get the course document ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider(
                          create: (_) => Mod(x: courseName),
                          child: CourseDetailsPage(courseId: courseId)),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(courseName),
                      // Add more information about the course here if needed
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
