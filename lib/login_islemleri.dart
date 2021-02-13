import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        print("*****************Kullanıcı oturumu kapattı");
      } else {
        print("*****************Kullanıcı oturum açtı");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login İşlemleri"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: _emailSifreKullaniciOlustur,
              child: Text("Email / Şifre User Create"),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed: _emailSifreGirisYap,
              child: Text("Email / Şifre User Login"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: _resetPassword,
              child: Text("Şifremi Unuttum"),
              color: Colors.purple,
            ),
            RaisedButton(
              onPressed: _updatePassword,
              child: Text("Şifremi Güncelle"),
              color: Colors.pinkAccent,
            ),
            RaisedButton(
              onPressed: _updateEmail,
              child: Text("Email Güncelle"),
              color: Colors.cyan,
            ),
            RaisedButton(
              onPressed: _signInWithGoogle,
              child: Text("Google il Giriş Yap"),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed: _telNoGiris,
              child: Text("TEL NO il Giriş Yap"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: _cikisYap,
              child: Text("Sign Out"),
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }

  
}
