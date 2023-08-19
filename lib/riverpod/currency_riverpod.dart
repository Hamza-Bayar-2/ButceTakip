import 'package:butcekontrol/models/currency_info.dart';
import 'package:butcekontrol/models/settings_info.dart';
import 'package:butcekontrol/utils/firestore_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ntp/ntp.dart';
import '../models/spend_info.dart';
import '../riverpod_management.dart';
import '../utils/db_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/security_file.dart';


class CurrencyRiverpod extends ChangeNotifier {
  int ?id;
  String ?BASE;
  String ?TRY;
  String ?USD;
  String ?EUR;
  String ?GBP;
  String ?KWD;
  String ?JOD;
  String ?IQD;
  String ?SAR;
  String ?lastApiUpdateDate;
  List<currencyInfo> currrenciesFirestoreList = [];
  List<currencyInfo>  currencySqlList = [];

  double calculateRealAmount(double Amount, String moneyType, String prefix){ // amount moneytype kaç Prefix ?
    double realAmount;
    try{
      if(double.tryParse(currencySqlList![currencySqlList.length -1].toMap()[moneyType])! > 0.0){
        realAmount = double.parse((Amount * (double.tryParse(currencySqlList[currencySqlList.length -1].toMap()[prefix])! / double.tryParse(currencySqlList[currencySqlList.length -1].toMap()[moneyType])!)).toStringAsFixed(2))!;
      }else{
        realAmount = Amount ;
      }
    }catch(e){
      realAmount = Amount;
    }
    return realAmount ?? 0.0;
  }
  double calculateRate(double Amount, String moneyType, String prefix){
    double ?rate;
    if(double.tryParse(currencySqlList![currencySqlList.length -1].toMap()[moneyType])! > 0.0){
      rate = double.parse(((double.tryParse(currencySqlList[currencySqlList.length -1].toMap()[prefix])! / double.tryParse(currencySqlList[currencySqlList.length -1].toMap()[moneyType])!)).toStringAsFixed(5))!;
    }else{
      rate = 0.0 ;
    }
    return rate ;
  }

  void calculateAllSQLRealTime(WidgetRef ref) async { //Bütün kayıtları dolaşıp realAmount güncellenmesi yapıyor.
    List<SpendInfo> AllData = await SQLHelper.getItems();
    List<SettingsInfo> settingsList = await SQLHelper.settingsControl();
    AllData.forEach((info) async {
      if(info.moneyType == "0"){
        info.moneyType = "TRY";
      }

      if(info.moneyType == settingsList[0].prefix! ){
        info.realAmount = info.amount;
        await SQLHelper.updateItem(info).then((value) => print("SABİT KAYIT ===>>>${info.category} eski miktar ${info.amount} ${info.moneyType} realAmount miktar ====>> ${info.realAmount} ${settingsList[0].prefix!} İD => ${info.id}")).then((value) => ref.read(settingsRiverpod).setisuseinsert());
      }else{
        info.realAmount = calculateRealAmount(info.amount!, info.moneyType! , settingsList[0].prefix!); // amount moneytype kaç Prefix ?
        await SQLHelper.updateItem(info).then((value) => print("GÜNCELLENMİŞ KAYIT ===>>>${info.category} eski miktar ${info.amount} ${info.moneyType} realAmount miktar ====>> ${info.realAmount} ${settingsList[0].prefix!} İD => ${info.id}")).then((value) => ref.read(settingsRiverpod).setisuseinsert());
      }
    });
  }

  Future readDb() async{
    List<currencyInfo> currency = await SQLHelper.currencyControl() ;
    id = currency[currency.length - 1].id ;
    BASE = currency[currency.length - 1].BASE ;
    TRY = currency[currency.length - 1].TRY;
    USD = currency[currency.length - 1].USD;
    EUR = currency[currency.length - 1].EUR;
    GBP = currency[currency.length - 1].GBP;
    KWD = currency[currency.length - 1].KWD;
    JOD = currency[currency.length - 1].JOD;
    IQD = currency[currency.length - 1].IQD;
    SAR = currency[currency.length - 1].SAR;

    lastApiUpdateDate = currency[currency.length -1].lastApiUpdateDate;
    print("""
      id  : ${currency[currency.length - 1].id}
      BASE: ${currency[currency.length - 1].BASE}
      TRY : ${currency[currency.length - 1].TRY}               USD : ${currency[currency.length - 1].USD}
      EUR : ${currency[currency.length - 1].EUR}        GBP : ${currency[currency.length - 1].GBP}
      KWD : ${currency[currency.length - 1].KWD}        JOD : ${currency[currency.length - 1].JOD}
      IQD : ${currency[currency.length - 1].IQD}       SAR : ${currency[currency.length - 1].SAR}
      lastApiUpdateDate :${currency[currency.length - 1].lastApiUpdateDate}
      """);
    notifyListeners();
  }

  Future<currencyInfo> fetchExchangeRates()  async {
    DateTime globalNow = await NTP.now();
    const String apiBaseUrl = 'https://api.apilayer.com/exchangerates_data';
    const String endpoint = '/latest';
    String apiKey = securityFile().api_key ?? "request API for currency rates";
    Map<String, dynamic> ?responseMap;
    final response = await http.get(Uri.parse("https://api.apilayer.com/exchangerates_data/latest?base=TRY&symbols=TRY,USD,EUR,GBP,KWD,JOD,IQD,SAR"),
        headers: {
          "apikey" : apiKey
        });

    if(response.statusCode == 200){
      //başarılı
      responseMap = jsonDecode(response.body);
      print("***********************");
    }else if (response.statusCode == 104){
      //Aylık istenilen max isteğe ulaşıldı
      print("c");
    }else{
      print("b");
      print(response.statusCode);
      //başarısız
    }
    print("veri databaseye kaydoldu");

    if (responseMap != null) {
      return currencyInfo(
        "TRY",
        responseMap["rates"]["TRY"].toString(),
        responseMap["rates"]["USD"].toString(),
        responseMap["rates"]["EUR"].toString(),
        responseMap["rates"]["GBP"].toString(),
        responseMap["rates"]["KWD"].toString(),
        responseMap["rates"]["JOD"].toString(),
        responseMap["rates"]["IQD"].toString(),
        responseMap["rates"]["SAR"].toString(),
        globalNow.add(Duration(hours: 3)).toString(),
      );
    }else{
      return currencyInfo("noInternet", "1", "1", "1", "1", "1", "1", "1", "1", DateTime.now().toString()); //bir kişide olan bir sıkıntı milyonları etkileyebilir.
    }
  }

  Future controlCurrency(WidgetRef ref) async{ //currency Kayıt değerlendiriyoruz.
    DateTime ?globalNow;
    currencySqlList = await SQLHelper.currencyControl();
    try{
      currrenciesFirestoreList = await firestoreHelper.readCurrenciesFirestore();
      globalNow = await NTP.now();
      print("GLOBAL SAAT =>${globalNow}");
      if(currrenciesFirestoreList.isNotEmpty){
        DateTime? date = DateTime.tryParse(currrenciesFirestoreList[currrenciesFirestoreList.length -1].lastApiUpdateDate!);
        if(date!.isBefore(globalNow)){ // son kullanma tarihi geçmiş diye kontrol ediyorum.
          print("3 saat veya daha önce güncellenmiş");
          await fetchExchangeRates().then((info) {
            if(info.BASE != 'noInternet'){
              firestoreHelper.createCurrencyFirestore(info);
              if(currencySqlList.isNotEmpty){
                var dateSQL = DateTime.tryParse(currencySqlList[currencySqlList.length - 1].lastApiUpdateDate!);
                if(dateSQL!.isBefore(globalNow!)){
                  print("yerel database ile firestore daki veriler arasında 3 saatten den fazla zaman gecikmiş");
                  firestoreHelper.readCurrenciesFirestore().then((currrenciesFirestoreList) {
                    SQLHelper.addItemCurrency(currrenciesFirestoreList[currrenciesFirestoreList.length - 1]).then((value) {
                      calculateAllSQLRealTime(ref);
                      readDb();
                    });
                  },);
                }else{
                  print("Bugün zaten veriler senkronizeee");
                  readDb();
                }
              }else {
                print("bulutta veri var sql de yoktu ekledik");
                SQLHelper.addItemCurrency(currrenciesFirestoreList[currrenciesFirestoreList.length - 1]).then((value) {
                  SQLHelper.currencyControl().then((value) => currencySqlList = value);
                  calculateAllSQLRealTime(ref);
                  readDb();
                });
              }
            }
          });
        }else{
          print("Firestore DataBase zaten güncel");
          if(currencySqlList.isNotEmpty){
            var dateSQL = DateTime.tryParse(currencySqlList[currencySqlList.length - 1].lastApiUpdateDate!);
            if(dateSQL!.isBefore(globalNow)){
              print("yerel database ile firestore daki veriler arasında 3 saatten den fazla zaman gecikmiş");
              firestoreHelper.readCurrenciesFirestore().then((currrenciesFirestoreList) {
                SQLHelper.addItemCurrency(currrenciesFirestoreList[currrenciesFirestoreList.length - 1]).then((value) {
                  calculateAllSQLRealTime(ref);
                  readDb();
                });
              },);
            }else{
              print("Bugün zaten veriler senkronize");
              readDb();
            }
          }else {
            print("bulutta veri var sql de yoktu ekledik");
            SQLHelper.addItemCurrency(currrenciesFirestoreList![currrenciesFirestoreList!.length - 1]).then((value) {
              SQLHelper.currencyControl().then((value) => currencySqlList = value);
              calculateAllSQLRealTime(ref);
              readDb();
            });
          }
        }
      }else{ //buraya düşmesiz imkansız gbi bir şey? //okuyamzasa düşer
        await fetchExchangeRates().then((info) {
          firestoreHelper.createCurrencyFirestore(info);
          //SQLHelper.addItemCurrency(info);
          readDb();
        });
      }
    }catch(e){
      print("INTERNET BULUNAMADI(DİD FOUND INTERNET TAKED DEFAULT INFORMATION [$e]");
      if(currencySqlList.isNotEmpty){
        readDb();
      }else{
        await SQLHelper.addItemCurrency(currencyInfo("noInternet", "1", "1", "1", "1", "1", "1", "1", "1", "00.00.0000"));
        readDb();
      }
      //varsayılan değerleri aldırsana abi tekrar kontrol gerekiyor.
      //fetchExchangeRates().then((value) => readDb()); =>
      ///zaten internet yok tekrar Api çekmeye gerek yok
    }
  }

  Future Updating() async {
    final info = currencyInfo.withId(
      id,
      BASE,
      TRY,
      USD,
      EUR,
      GBP,
      KWD,
      JOD,
      IQD,
      SAR,
      lastApiUpdateDate,
    );
    await SQLHelper.updateCurrency(info);
  }

  void setBASE(String? prefix) {
    BASE = prefix;
    Updating();
  }
}