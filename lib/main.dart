import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sampleapp/screens/home_screen.dart';
import 'package:sampleapp/screens/register_screen.dart';
import 'package:sampleapp/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sample App',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: StreamBuilder(
            stream: AuthService().firebaseAuth.authStateChanges(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Homescreen(snapshot.data);
              }
              return Registerscreen();
            }));
  }
}
