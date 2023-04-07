import 'package:butcekontrol/Pages/Calculator.dart';
import 'package:butcekontrol/Pages/Home.dart';
import 'package:butcekontrol/Pages/calendar.dart';
import 'package:butcekontrol/Pages/more.dart';
import 'package:butcekontrol/Pages/statistics.dart';
import 'package:flutter/material.dart';

class BottomNavBarRiverpod extends ChangeNotifier { //statelesswidget
  int currentindex = 0 ;
  int ?current ;
  Color currentColor = Colors.white;
  void refreshbuidl(){
    currentindex = currentindex ;
  }
  void setcur(){
    current = currentindex;
    notifyListeners();
  }

  void setCurrentindex(int index) {
    currentindex = index ;
    notifyListeners();
  }
  void setBackColor(Color color){
    currentColor = color ;
  }

  Widget body(){
    switch(currentindex) {
      case 0 :
        return Home();
      case 1:
        return Statistics();
      case 2:
        return Calendar() ;
      case 3 :
        return Calculator();
      case 4 :
        return More();
      default :
        return Home();
    }
  }
}