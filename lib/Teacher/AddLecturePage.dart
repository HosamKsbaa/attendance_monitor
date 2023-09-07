import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLecturePage extends StatefulWidget {
  final String courseId;

  AddLecturePage({required this.courseId});

  @override
  _AddLecturePageState createState() => _AddLecturePageState();
}

class _AddLecturePageState extends State<AddLecturePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lectureNameController = TextEditingController();
  DateTime? _selectedDate;

  FutureOr<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lecture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _lectureNameController,
                decoration: InputDecoration(labelText: 'Lecture Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a lecture name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
/*              Text(
                _selectedDate == null
                    ? 'Select Lecture Date'
                    : 'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                style: TextStyle(fontSize: 16),
              ),*/

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() ) {
                    // Save lecture details to Firestore
                    FirebaseFirestore.instance.collection('lectures').add({
                      'courseId': widget.courseId,
                      'lectureName': _lectureNameController.text,

                    });

                    Navigator.pop(context); // Close the page after adding a lecture
                  }
                },
                child: Text('Add Lecture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
