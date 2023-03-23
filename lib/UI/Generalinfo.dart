import 'package:butcekontrol/constans/MaterialColor.dart';
import 'package:flutter/material.dart';

class Generalinfo extends StatefulWidget {
  const Generalinfo({Key? key}) : super(key: key);

  @override
  State<Generalinfo> createState() => _GeneralinfoState();
}

class Calender_Bka {
  List <String> Mounths = ["Ocak", "Subat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Agustos", "Eylül", "Ekim", "Kasım", "Aralık" ];
  List <String> Years = ["2020","2021","2022","2023","2024","2025", "2026", "2027", "2028", "2029", "2030"];
  List <String> Days = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
}

class _GeneralinfoState extends State<Generalinfo> {
  var gelir = 6950.0 ;
  var gider = 440.5 ;
  var toplam = "+255.4" ;
  var renkler = CustomColors();
  int indexyear  = Calender_Bka().Years.indexOf(DateTime.now().year.toString());
  int indexmounth = DateTime.now().month - 1;
  @override
  Widget build(BuildContext context) {
    final double devicedata = MediaQuery.of(context).size.width;
    Calender_Bka calender = new Calender_Bka();  // aşağıdaki classı tanımladık.
    return Container(
      constraints: const BoxConstraints(
        maxHeight: double.infinity, //container in boyutunu içindekiler belirliyor.
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column( //Tarih bilgisini değiştirebilme
            children: [
              IconButton(
                icon: const Icon(
                  Icons.expand_less_sharp,
                  size: 30,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minHeight: 28,
                  minWidth: 25,
                ),
                onPressed: () {
                    if (indexmounth > 0 ) {
                      indexmounth -= 1 ;
                    } else {
                      if (indexyear != 0) {
                        indexyear -= 1 ;
                        indexmounth = 11 ;
                      }
                    }
                    setState(() {

                    });
                },
              ),
              ClipRRect( // yuvarlıyorum ay değişimi barını
                borderRadius: BorderRadius.only(topRight:Radius.circular(50),bottomRight: Radius.circular(50)),
                child: Container(
                  height: 24,
                  width: 120 ,
                  color: CustomColors.koyuuRenk,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          calender.Mounths[indexmounth],
                          style: const TextStyle(
                            color:  Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Ay gösterge
                        const SizedBox(width: 6), // bunu verdim çünkü yıl ile ay arsnıdna boşluk yapmam gereiyordu.
                        Text(
                          calender.Years[indexyear],
                         style: const TextStyle(
                           color:  Colors.white,
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                         ),
                        ), // Yıl gösterge
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                    Icons.expand_more,
                    size: 30,
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.topRight,
                constraints: const BoxConstraints(
                  minHeight: 28,
                  minWidth: 25,
                ),
                onPressed: () {
                  if (indexmounth < calender.Mounths.length - 1 ){
                    indexmounth += 1 ;
                  } else if(indexyear < calender.Years.length - 1){
                    indexmounth = 0 ;
                    indexyear += 1 ;
                  }
                  setState(() {
                  });
                },
              ),
            ],
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0,left: 11),
              child: SizedBox(
                width: devicedata - 132.0 ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Gelir",
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "100" ,
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ), //Gelir bilgisi
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          "Gider",
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Text(
                        "500" ,
                        style: TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.normal,
                          color: Colors.red,
                          ),
                        ),
                        ],
                      ), // gider bilgisi
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Toplam",
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          toplam ,
                          style: const TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),//Toplam bilgi
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 35  ,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                      ),
                      onPressed: () {  },
                    ), //Ayrıntılı gösterme butonu
                  ],
                ),
              ),
            ),
          ),//Aylık özet bilgileri
        ],
      ),
    );
  }
}
