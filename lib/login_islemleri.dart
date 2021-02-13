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
  Future<UserCredential> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("***********Google ile girişte hata çıktı : " + e.toString());
    }
  }

  void _emailSifreKullaniciOlustur() async {
    String _email = "iltasferhatt@gmail.com";
    String _password = "newPassword";

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User _newUser = _credential.user;
      await _newUser.sendEmailVerification();

      if (_auth.currentUser != null) {
        print(
            "*****************Size gönderdiğimiz maile tıklayıp hesabınızı onaylayınız...");
        await _auth.signOut();
        print("*****************Kullanıcıyı sistemden attık");
      }

      print(_newUser.toString());
    } catch (e) {
      print(
          " ------------------------- HATA ---------------------------------");
      print(e.toString());
    }
  }

  void _emailSifreGirisYap() async {
    String _email = "iltasferhatt@gmail.com";
    String _password = "newPassword";

    try {
      if (_auth.currentUser == null) {
        User _oturumAcanUser = (await _auth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;

        if (_oturumAcanUser.emailVerified) {
          print("*****************Mail onaylandı ana sayfaya gidiniz.");
        } else {
          print("*****************Mailinizi onaylayınız");
          _auth.signOut();
        }
      } else {
        print("*****************Zaten giriş yapmış bir kullanıcı var");
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  
  
  
}
