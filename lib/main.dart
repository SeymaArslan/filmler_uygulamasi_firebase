import 'package:filmler_uygulamasi_firebase/FilmlerSayfa.dart';
import 'package:filmler_uygulamasi_firebase/Kategoriler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  // firebase yapısında foreign key olmadığı için kategori id ile değil kategori adları ile filtreleme işlemi yapacağız

  var refKategoriler = FirebaseDatabase.instance.ref().child("kategoriler");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategoriler"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refKategoriler.onValue,
        builder: (context, event){
          if(event.hasData){
            var kategoriListesi = <Kategoriler>[]; // listemizi oluşturduk

            var gelenDegerler = event.data!.snapshot.value as dynamic;  // değerlerimizi aldık

            if(gelenDegerler != null){  // doluysa çalış dedik
              gelenDegerler.forEach((key, nesne){ // döngü ile veritabanındaki kayıtları key ve nesne olarak aldık
                var gelenKategori = Kategoriler.fromJson(key, nesne); // aldığımız key ve nesneleri buraya aktardık ve Kategoriler sınıfında parse ederek bize nesne olarak verdi
                kategoriListesi.add(gelenKategori); // gelen kategorileri listeye ekledik
              });
            }

            return ListView.builder(
              itemCount: kategoriListesi!.length,
              itemBuilder: (context, indeks){
                var kategori = kategoriListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilmlerSayfa(kategori: kategori )));
                  },
                  child: Card(
                    child: SizedBox( height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(kategori.kategori_ad),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else  {
            return Center();
          }
        },
      ),
    );
  }
}
