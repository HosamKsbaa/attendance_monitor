import 'dart:async';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Core/ConstColors.dart';
import 'Core/UserDataEntryPage.dart';
import 'Core/sign_in.dart';
import 'package:attendance_monitor/Student%20/Student.dart';
import 'package:attendance_monitor/Teacher/Teacher.dart';
import 'package:attendance_monitor/Core/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
            "1069861418777-2s8g26net91nqc8s44vminus1v913tsm.apps.googleusercontent.com"),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getTheme(),
      home: SignInScreen(actions: [
        AuthStateChangeAction<SignedIn>(

          (context, state) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const MyHomePage(title: 'aaa')));
//
          },
        )
      ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late SharedPreferences _prefs;
  bool _hasUserData = false;



  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    final hasUserData = _prefs.getBool('hasUserData') ?? false;
    setState(() {
      _hasUserData = hasUserData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal, title: const Center(child: Text('Home'))),
      body: Center(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Login as :', style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: button(
                ico: Icons.account_balance,
                str: "Teacher",
                iconColor: Colors.white70,

                onPressed: () {

                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => teacher(teacherId: getid().uid),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        final tween = Tween(begin: begin, end: end);
                        final offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      // You can specify the transition duration as needed (e.g., 300 milliseconds).
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );


                },

              ),
            ),
            button(
              ico: Icons.account_box,
              str: "Student",
              iconColor: Colors.white70,
                onPressed: () {
                  if (_hasUserData) {
                    // User data exists, navigate directly
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Student(),
                      ),
                    );
                  } else {
                    // User data doesn't exist, navigate to the data entry page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDataEntryPage(),
                      ),
                    );
                  }
                }
            ),
          ]),
        ),
      ),
    );
  }
}

class button extends StatelessWidget {
  button(
      {Key? key,
      required this.ico,
      required this.str,
      this.onPressed,
      required this.iconColor})
      : super(key: key);
  final IconData? ico;
  final String str;
  final void Function()? onPressed;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      onTap: onPressed,
      child: Card(
        color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 10, top: 0),
                  child: Icon(ico, color: iconColor),
                ),
                Text(str)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
