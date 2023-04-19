import 'package:butcekontrol/constans/material_color.dart';
import 'package:butcekontrol/riverpod_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class CalenderBka {
  List <String> mounths = ["Ocak", "Subat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Agustos", "Eylül", "Ekim", "Kasım", "Aralık" ];
  List <String> years = ["2020","2021","2022","2023","2024","2025", "2026", "2027", "2028", "2029", "2030"];
  List <String> days = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
}

class Generalinfo extends ConsumerWidget {
  //statelesswidget
  const Generalinfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var readhome = ref.read(homeRiverpod);
    var watchhome = ref.watch(homeRiverpod);
    var readdb = ref.read(databaseRiverpod);
    CustomColors renkler = CustomColors();
    watchhome.refrestst;
    int indexyear = watchhome.indexyear;
    int indexmounth = watchhome.indexmounth;
    final double devicedata = MediaQuery
        .of(context)
        .size
        .width;
    CalenderBka calender = CalenderBka(); // aşağıdaki classı tanımladık.
    return StreamBuilder<Map<String, dynamic>>(
        stream: readdb.myMethod(),
        builder:
            (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //var dailyTotals = snapshot.data!['dailyTotals'];
          var items = snapshot.data!['items'];
          return Container(
            constraints: const BoxConstraints(
              maxHeight: double
                  .infinity, //container in boyutunu içindekiler belirliyor.
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
                        if (indexmounth > 0) {
                          indexmounth -= 1;
                        } else {
                          if (indexyear != 0) {
                            indexyear -= 1;
                            indexmounth = 11;
                          }
                        }
                        readhome.changeindex(indexmounth, indexyear);
                        readdb.setMonthandYear(
                            (indexmounth + 1).toString(),
                            calender.years[indexyear]);
                      },
                    ),
                    ClipRRect( // yuvarlıyorum ay değişimi barını
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      child: Container(
                        height: 24,
                        width: 120,
                        color: renkler.koyuuRenk,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5,top: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                calender.mounths[readhome.indexmounth],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Ay gösterge
                              const SizedBox(width: 6),
                              // bunu verdim çünkü yıl ile ay arsnıdna boşluk yapmam gereiyordu.
                              Text(
                                calender.years[readhome.indexyear],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Yıl gösterge
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
                        if (indexmounth < calender.mounths.length - 1) {
                          indexmounth += 1;
                        } else if (indexyear < calender.years.length - 1) {
                          indexmounth = 0;
                          indexyear += 1;
                        }
                        readhome.changeindex(indexmounth, indexyear);
                        readdb.setMonthandYear(
                            (indexmounth + 1).toString(),
                            calender.years[indexyear]);
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
                    padding: const EdgeInsets.only(bottom: 12.0, left: 11),
                    child: SizedBox(
                      width: devicedata - 132.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Gelir",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                readdb.getTotalAmountPositive(items),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ), //Gelir bilgisi
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:  [
                              const Text(
                                "Gider",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                readdb.getTotalAmountNegative(items),
                                style: const TextStyle(
                                  fontSize: 20,
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
                                readdb.getTotalAmount(items),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          )//Toplam bilgi
                        ],
                      ),
                    ),
                  ),
                ), //Aylık özet bilgileri
              ],
            ),
          );
        }
    );
  }
}