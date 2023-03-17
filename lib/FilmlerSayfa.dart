import 'package:filmler_uygulamasi_firebase/DetaySayfa.dart';
import 'package:filmler_uygulamasi_firebase/Filmler.dart';
import 'package:filmler_uygulamasi_firebase/Kategoriler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FilmlerSayfa extends StatefulWidget {

  Kategoriler kategori;
  FilmlerSayfa({required this.kategori});

  @override
  State<FilmlerSayfa> createState() => _FilmlerSayfaState();
}

class _FilmlerSayfaState extends State<FilmlerSayfa> {

  var refFilmler = FirebaseDatabase.instance.ref().child("filmler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // kategori adı aynı olanları göstereceğiz equalTo metodu ile
        title: Text("Filmler : ${widget.kategori.kategori_ad}"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refFilmler.orderByChild("kategori_ad").equalTo(widget.kategori.kategori_ad).onValue, // refFilmler de ki kategori_ad ını KategorilerListesinde seçilen kategori_ad verisi ile karşılaştırarak film verilerini getir
        builder: (context, event){
          if(event.hasData){
            var filmlerListesi = <Filmler>[]; // listemizi oluşturduk

            var gelenDegerler = event.data!.snapshot.value as dynamic;  // değerlerimizi aldık

            if(gelenDegerler != null){  // doluysa çalış dedik
              gelenDegerler.forEach((key, nesne){ // döngü ile veritabanındaki kayıtları key ve nesne olarak aldık
                var gelenFilm = Filmler.fromJson(key, nesne); // aldığımız key ve nesneleri buraya aktardık ve Kategoriler sınıfında parse ederek bize nesne olarak verdi
                filmlerListesi.add(gelenFilm); // gelen kategorileri listeye ekledik
              });
            } // bütün liste elimizde
            return GridView.builder(  // listeyi gridview içerisinde göstereceğiz
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
              ),
              itemCount: filmlerListesi!.length,
              itemBuilder: (context, indeks){
                var film = filmlerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(film: film,)));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("fotolar/${film.film_resim}"), // http gibi internet üzerinden çekti bağlantım olmadığı için kod içindn çekeceğim
                        ),
                        Text(film.film_ad, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
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
