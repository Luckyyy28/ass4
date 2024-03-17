
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_try/firebase_options.dart';
import 'package:firebase_try/screens/client_screen.dart';
import 'package:firebase_try/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            String userId = snapshot.data!.uid;
            return client_screen(uid: userId);
          }
          return HomeScreen();
        },
      ),
      builder: EasyLoading.init(),
      theme: ThemeData(
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }
}