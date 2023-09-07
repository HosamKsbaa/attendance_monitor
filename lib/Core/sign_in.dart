import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

User getid() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user;
  } else {
    throw Exception('User is not logged in.');
  }
}

