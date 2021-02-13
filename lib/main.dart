import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_examples/login_islemleri.dart';
import 'package:flutter/material.dart';

import 'firestore_islemleri.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Hata Çıktı : " + snapshot.error.toString()),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return FirestoreIslemleri();
        }

        return Scaffold(
          body: Center(
            child:CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
