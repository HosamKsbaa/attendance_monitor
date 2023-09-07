import 'dart:async';

import 'package:attendance_monitor/Core/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FutureOr<void> createCourse(String courseName, String teacherId) async {
    try {
      await _firestore.collection('courses').add({
        'name': courseName,
        'teacherId': teacherId,
      });
    } catch (e) {
      print('Error creating course: $e');
    }
  }
}

class add_course extends StatefulWidget {
  const add_course({Key? key}) : super(key: key);

  @override
  State<add_course> createState() => _add_courseState();
}

class _add_courseState extends State<add_course> {
  final TextEditingController _courseNameController = TextEditingController();
  final CourseService _courseService = CourseService(); // Your Firebase service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add a new course')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _courseNameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final courseName = _courseNameController.text;
                final teacherId = getid().uid; // Replace with actual teacher ID
                if (courseName.isNotEmpty) {
                  _courseService.createCourse(courseName, teacherId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course created successfully')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a course name')),
                  );
                }
              },
              child: const Text('Create Course'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    super.dispose();
  }
}
