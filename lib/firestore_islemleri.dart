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
  }
