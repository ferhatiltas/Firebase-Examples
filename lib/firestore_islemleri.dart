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
    
      void _veriSil() {
    // Belge (kişi) silme
    _firestore.doc("users/S3KloVRitbTFeU1DFVvI").delete().then((value) {
      print("S3KloVRitbTFeU1DFVvI  kişisi silindi");
    }).catchError((Object error) {
      print("Kişi silinirken hata oluştu $error");
    });


    // Belli kişiye ait alan silme
    _firestore.doc("users/barış_ak")
        .update({'cismi': FieldValue.delete()})
        .then((value) => print("Kişiye ait alan silindi"))
        .catchError((onError) {
      print("Kişiye ait alan silinirken hata oluştu : " + onError.toString());
    });
  }

  Future _veriOku() async {
    // Kişiye ait tüm verileri çekip üzerinde işlemler yapabiliriz
    DocumentSnapshot documentSnapshot = await _firestore.doc(
        "users/ferhat_iltas").get();
    print("Kişi idsi : " + documentSnapshot.id);
    print("Kişi ismi : " + documentSnapshot.data()['ad']);
    print(
        "Kişi öğrenci mi : " + documentSnapshot.data()['ogrenciMi'].toString());
    print("Kişi parası : " + documentSnapshot.data()['para'].toString());
    print("Kişi yaşı : " + documentSnapshot.data()['yas'].toString());
    print("Kişi kayıt zamanı : " + documentSnapshot.data()['zaman'].toString());
    print("documentSnapshot.data().toString() : " +
        documentSnapshot.data().toString());
    print("documentSnapshot.toString() : " + documentSnapshot.toString());
    documentSnapshot.data().forEach((key,
        value) { // forech ile tüm key value leri çek
      print("Key : $key - Value : $value");
    });


    // Bir kolleksiyondaki eleman sayısı
    _firestore.collection("users").get().then((querySnapshots) {
      print("users kolleksiyonundaki eleman sayısı : " +
          querySnapshots.docs.length.toString());

      // Tüm kişilerin tüm verilerini getir
      for (int i = 0; i < querySnapshots.docs.length; i++) {
        print("$i . kişinin bilgileri : " +
            querySnapshots.docs[i].data().toString());
      }

      // Değiştirilen verilerin anlık olarak gözükmesi
      var ref = _firestore.collection("users").doc("ferhat_iltas");
      ref.snapshots().listen((anlikDegisenVeri) {
        print("Anlık değişen veri : " + anlikDegisenVeri.data().toString());
      });

      // Kişi sayısını anlık olarak göster
      _firestore.collection("users").snapshots().listen((anlikKisiSayisi) {
        print("Anlık kişi sayısı : " + anlikKisiSayisi.docs.length.toString());
      });
    });
  }
    
      void _veriSorgula() async {
    // İsimi Bilimeyen olanları getir
    var dokumanlar=await _firestore.collection("users").where("isim",isEqualTo: 'Bilinmeyen').get();
    for(var dokuman in dokumanlar.docs){
      print("İsmi Bilinmeyen yazanlar : "+dokuman.data().toString());
    }

    // Limitli kullanıcı getir (kaç kişi istersen o kadar veri getirecek) faturalandırmadan dolayı yap.,
    var limitliGEtir=await _firestore.collection("users").limit(2).get();
    for(var limitli in limitliGEtir.docs){
      print("Limitli getirilenler : "+limitli.data().toString());
    }
  }

  void _galeriResimUpload() async {

    var _picker = ImagePicker();
    var resim = await _picker.getImage(source: ImageSource.gallery); // galeriden seçilen resmin ekranda gözükmesiniz sağlar
    setState(() {
      _secilenResim = File(resim.path); // galeriden seçilen resmin ekranda gözükmesiniz sağlar
    });


    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user")
        .child("emre")
        .child("profil.png");
    UploadTask  uploadTask = ref.putFile(File(_secilenResim.path)); // resmi veritabanında üstteki yola at
    var url = await (await uploadTask).ref.getDownloadURL(); // yüklendikten sonra url olutur
    debugPrint("upload edilen resmin urlsi : " + url);
  }
  void _kameraResimUpload() async {
    final picker = ImagePicker();
    var resim = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _secilenResim = File(resim.path);
    });
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user")
        .child("hasan")
        .child("profil.png");
    UploadTask  uploadTask = ref.putFile(File(_secilenResim.path));
    var url = await (await uploadTask).ref.getDownloadURL();
    debugPrint("upload edilen resmin urlsi : " + url);
  }
    
    
  }
