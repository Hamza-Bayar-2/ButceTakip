import 'package:butcekontrol/classes/language.dart';
import 'package:butcekontrol/constans/material_color.dart';
import 'package:butcekontrol/riverpod_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Generalinfo extends ConsumerWidget {
  //statelesswidget
  const Generalinfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> months = [
      translation(context).january,
      translation(context).february,
      translation(context).march,
      translation(context).april,
      translation(context).may,
      translation(context).june,
      translation(context).july,
      translation(context).august,
      translation(context).september,
      translation(context).october,
      translation(context).november,
      translation(context).december
    ];
    List<String> years = [
      "2020",
      "2021",
      "2022",
      "2023",
      "2024",
      "2025",
      "2026",
      "2027",
      "2028",
      "2029",
      "2030"
    ];
    var readhome = ref.read(homeRiverpod);
    var watchhome = ref.watch(homeRiverpod);
    var readdb = ref.read(databaseRiverpod);
    var readSettings = ref.read(settingsRiverpod);
    var size = MediaQuery.of(context).size;
    CustomColors renkler = CustomColors();
    watchhome.refrestst;
    int indexyear = watchhome.indexyear;
    int indexmounth = watchhome.indexmounth;
    return StreamBuilder<Map<String, dynamic>>(
        stream: readdb.myMethod(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //var dailyTotals = snapshot.data!['dailyTotals'];
          var items = snapshot.data!['items'];
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: double
                      .infinity, //container in boyutunu içindekiler belirliyor.
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: renkler.yesilRenk,
                        ),
                        height: 62,
                        width: 6,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  translation(context).monthlyIncome,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: 15,
                                      fontFamily: 'Nexa3',
                                      color: Theme.of(context).canvasColor),
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            color: renkler.sariRenk
                                        ),
                                        width: 208,
                                        height: 26,
                                      ),
                                    ),
                                    Row(
                                      //Tarih bilgisini değiştirebilme
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 2),
                                          child: RotatedBox(
                                            quarterTurns: 0,
                                            child: InkWell(
                                              //alignment: Alignment.topCenter,
                                              //padding: EdgeInsets.zero,
                                              onTap: () {
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
                                                    years[indexyear]);
                                              },
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  "assets/icons/arrow.png",
                                                  height: 18,
                                                  color: renkler.koyuuRenk,
                                                ),
                                              )
                                            ),
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: readSettings.localChanger() == const Locale("ar") ? TextDirection.rtl : TextDirection.ltr,
                                          child: ClipRRect(
                                            // yuvarlıyorum ay değişimi barını
                                            borderRadius:
                                            const BorderRadius.all(Radius.circular(50)),
                                            child: Container(
                                              height: 32,
                                              width: 164,
                                              color: Theme.of(context).highlightColor,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      months[readhome.indexmounth],
                                                      style: TextStyle(
                                                        color: renkler.arkaRenk,
                                                        fontSize: 17,
                                                        fontFamily: 'Nexa3',
                                                      ),
                                                    ),
                                                    // Ay gösterge
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      years[readhome.indexyear],
                                                      style: TextStyle(
                                                        color: renkler.arkaRenk,
                                                        fontSize: 17,
                                                        fontFamily: 'Nexa4',
                                                      ),
                                                    ),
                                                    // Yıl gösterge
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 2),
                                          child: RotatedBox(
                                            quarterTurns: 2,
                                            child: InkWell(
                                              //padding: EdgeInsets.zero,
                                              //alignment: Alignment.topCenter,
                                              onTap: () {
                                                if (indexmounth < months.length - 1) {
                                                  indexmounth += 1;
                                                } else if (indexyear <
                                                    years.length - 1) {
                                                  indexmounth = 0;
                                                  indexyear += 1;
                                                }
                                                readhome.changeindex(indexmounth, indexyear);
                                                readdb.setMonthandYear(
                                                    (indexmounth + 1).toString(),
                                                    years[indexyear]);
                                              },
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  "assets/icons/arrow.png",
                                                  height: 18,
                                                  color: renkler.koyuuRenk,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                                Text(
                                  translation(context).monthlyExpenses,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: 15,
                                      fontFamily: 'Nexa3',
                                      color: Theme.of(context).canvasColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: readdb
                                            .getTotalAmountPositive(items),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Nexa3',
                                          color: renkler.yesilRenk,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ₺',
                                        style: TextStyle(
                                          fontFamily: 'TL',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: renkler.yesilRenk,
                                        ),
                                      ),
                                    ])),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: readdb.getTotalAmount(items),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Nexa3',
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ₺',
                                        style: TextStyle(
                                          fontFamily: 'TL',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                    ])),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: readdb
                                            .getTotalAmountNegative(items),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Nexa3',
                                          color: renkler.kirmiziRenk,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ₺',
                                        style: TextStyle(
                                          fontFamily: 'TL',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: renkler.kirmiziRenk,
                                        ),
                                      ),
                                    ])),
                                  ),
                                ), // gider bilgisi
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          color: renkler.kirmiziRenk,
                        ),
                        height: 62,
                        width: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  InlineSpan textChange(String text, String value, amount) {
    return amount <= 99999
        ? TextSpan(text: '$text ')
        : TextSpan(text: '$value ');
  }
}
