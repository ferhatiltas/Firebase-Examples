import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File _secilenResim;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore İşlemleri"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RaisedButton(
              child: Text(
                "Veri Ekle",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.purple,
              onPressed: _veriEkle,
            ),
            RaisedButton(
              child: Text(
                "Transaction Ekle",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.cyan,
              onPressed: _transactionEkle,
            ),
            RaisedButton(
              child: Text(
                "Veri Sil",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.red,
              onPressed: _veriSil,
            ),
            RaisedButton(
              child: Text(
                "Veri Oku",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.green.shade900,
              onPressed: _veriOku,
            ),
            RaisedButton(
              child: Text(
                "Veri Sorgula",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.yellow.shade800,
              onPressed: _veriSorgula,
            ),
            RaisedButton(
              child: Text(
                "Kameradan Resim Yükle",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.pinkAccent,
              onPressed: _kameraResimUpload,
            ),
            RaisedButton(
              child: Text(
                "Galeriden Resim Yükle",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
              color: Colors.blue,
              onPressed: _galeriResimUpload,
            ),
            Expanded(child: _secilenResim==null ? Text("Resim Yok",style: TextStyle(fontSize: 22),) : Image.file(_secilenResim as File))
          ],
        ),
      ),
    );
    
      void _veriEkle() {
    // Kolleksiyonlar oluşturup kolleksiyonlar altında dökümanlar oluşturup istersek dökümanın altında da farklı kolleksiyonlar oluşturabiliriz.
    Map<String, dynamic> ferhatEkle = Map();
    ferhatEkle['ad'] = "Ferhat";
    ferhatEkle['ogrenciMii'] = true;

    _firestore // 1. ekleme yöntemi = users adında collection oluşturup ilk dökümanı ferhat_iltas ve veriler de map dan atadık
        .collection("users")
        .doc("ferhat_iltas")
        .set(
        ferhatEkle,
        SetOptions(
            merge:
            true)) // SetOptions(merge: true) sayesinde bir veri yerine başka veri eklediğimizde eski veriyi silmiyor yani eski veriyi silip üzerine yeni veriyi yazmasını engelliyoruz. Eski verilerde tutuluyor
        .then((value) => print("Ferhat Eklendi "));

    // 2. ekleme yöntemi
    _firestore
        .collection("users")
        .doc("barış_ak")
        .set({'ismi': "Barış", 'cismi': "İnsan"}).whenComplete(
            () => print("Barış Eklendi"));

    // 3. ekleme yöntemi
    _firestore.doc("/users/jhony_deep").set({'Name': "Jhony"});

    // eklenen belge id si sistem tarafından otomatik olsun istersek
    _firestore.collection("users").add({'isim': "Ahmet"});

    // rastgele belge (kullanıcı) id oluşturup bunu veri girenlere atayabiliriz
    String yeniKullaniciID = _firestore
        .collection("users")
        .doc()
        .id; // id oluşacak ama veri tabanında gözükmez çünkü veri girişi daha olmadı
    print("Yeni kullanıcı id si : $yeniKullaniciID");

    // yeniKullaniciID idsi olan kişiye veri atayalım
    _firestore
        .doc("users/$yeniKullaniciID")
        .set({'yeni İsim': "ALi", 'userID': "$yeniKullaniciID"});

    // Girilen veriyi güncelle + olmayan veri güncellenmek istendiğinde olmadığı için yeni veri girişi oluyor
    _firestore.doc("users/ferhat_iltas").update({
      'ad': "ferhad",
      'para': 500,
      'zaman': FieldValue.serverTimestamp()
    }).then((value) => print("Ferhat ismi güncellendi"));
  }

  void _transactionEkle() {
    final DocumentReference ferhatRef = _firestore.doc("users/ferhat_iltas");
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot ferhatData = await ferhatRef.get();
      if (ferhatData.exists) {
        // böyle biri var ise
        var ferhatinParasi = ferhatData.data()['para'];
        if (ferhatinParasi > 10) {
          // butona tıkladığı zaman ferhatın parası 10 liradan fazla ise hesaptan 10 lira azalt
          await transaction.update(ferhatRef, {
            'para': ferhatinParasi - 10
          }); // ferhatın parasından 10 lira çıkar
          await transaction.update(_firestore.doc("users/barış_ak"), {
            'para': FieldValue.increment(10)
          }); // barış_ak adlı kişiye 10 lira ekle
          print("Para gönderildi");
        } else {
          print("Yetersiz bakiye ");
        }
      } else {
        print("Böyle bir id e sahip kimse yok");
      }
    });
  }
    
    
    
    
  }
