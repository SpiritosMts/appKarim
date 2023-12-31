


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../_manager/bindings.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import 'invoice.dart';

class Product {
  String? id;
  String? name;
  String? imageUrl;
  String? addedTime;
  double? currPrice;
  double? currBuyPrice;
  int? currQty;
  int? currQtyReduced;
  String? qtyPerUnit;
  Map<String, dynamic> prodChanges;
  Map<String, dynamic> buyHis;
  Map<String, dynamic> sellHis;
  Map<String, dynamic> allItems;

  Product({
    this.id = 'no-id',
     this.name= '',
     this.imageUrl= '',
     this.addedTime= '',
     this.qtyPerUnit= '',
     this.currPrice= 0.0,
     this.currBuyPrice= 0.0,
     this.currQty= 0,
     this.currQtyReduced= 0,
     this.prodChanges= const{},
     this.allItems= const{},
     this.buyHis= const{},
     this.sellHis= const{},
  });



  factory Product.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> sellHis = Map<String, dynamic>.from(json['sellHis']);
    Map<String, dynamic> buyHis = Map<String, dynamic>.from(json['buyHis']);
    Map<String, dynamic> prodChanges = Map<String, dynamic>.from(json['prodChanges']);

    sellHis = addCaracterAtStartIfKeys('0s', sellHis);
    buyHis = addCaracterAtStartIfKeys('0b', buyHis);
    prodChanges = addCaracterAtStartIfKeys('0m', prodChanges);

    Map<String, dynamic> mapList = {...sellHis, ...buyHis, ...prodChanges};// merge
    Map<String, dynamic> allItems = {};

    /// //////////////////////////////////

    //if(json['name'] == 'baya 2'){
      //  order by time ///// new -> old
      List<MapEntry<String, dynamic>> list = mapList.entries.toList();
      list.sort((a, b) {
        DateTime timeA = dateFormatHM.parse(a.value['time']);
        DateTime timeB = dateFormatHM.parse(b.value['time']);
        return timeB.compareTo(timeA);
      });
      // ///////////////////////////////

      Map<String, dynamic> monthItems = {};
      String monthKey = '';
      double monthTotalBuy = 0.0;
      double monthTotalSell = 0.0;
      double monthIncome = 0.0;
      int monthQtySelled = 0;
      int monthQtyPurchased = 0;
      List<String> monthTotalList = [];
      List<String> monthIncomeList = [];
      List<String> monthQtyList = [];
      List<String> monthTimeList = [];

      // ADD CARD CALCs ////////////////////////////////////////////////////////
      addToMonthsMap(String key, dynamic entr) {
        monthItems[entr.key] = entr.value;


        double singleTotal = (entr.value['total'] ?? 0).toDouble();
        double singleIncome = (entr.value['income'] ?? 0).toDouble();
        int monthQty = (entr.value['qty'] ?? 0);

        if(key.startsWith("0s")) {
          monthTotalSell += singleTotal; //double
          monthQtySelled += monthQty;//double
          monthIncome += singleIncome;//double
          monthTotalList.add(singleTotal.toString());//list
          monthIncomeList.add(singleIncome.toString());//list
        }else{
          monthTotalList.add('0.0');//list
          monthIncomeList.add('0.0');//list

        }

        if(key.startsWith("0b")) {
          monthTotalBuy += singleTotal; //double
          monthQtyPurchased += monthQty; //double
           }


        // to all cards
        String singleQty = entr.value[key.startsWith("0m")? 'qty':'restQty'].toString()??'-';
         monthQtyList.add(singleQty);

        monthTimeList.add(entr.value['time']);
      }
      // ////////////////////////////////////////////////////////

      passToNewMonth() {
        //double
        monthItems['totalBuy'] = monthTotalBuy;
        monthItems['totalIncome'] = monthIncome;
        monthItems['totalSell'] = monthTotalSell;
        //int
        monthItems['totalSelledQty'] = monthQtySelled;
        monthItems['totalPurchasedQty'] = monthQtyPurchased;
        //lists
        monthItems['sellList'] = monthTotalList;
        monthItems['incomeList'] = monthIncomeList;
        monthItems['qtyList'] = monthQtyList;
        monthItems['timeList'] = monthTimeList;
        //print('## [$monthKey] => ${monthItems.length-9}');
        allItems[monthKey] = monthItems; //add month

        // //// CLEAR //////////////////////
        monthKey = '';
        monthTotalSell = 0.0;
        monthTotalBuy = 0.0;
        monthIncome = 0.0;
        monthQtySelled = 0;
        monthQtyPurchased = 0;

        monthQtyList =[];
        monthIncomeList =[];
        monthTotalList =[];
        monthTimeList =[];

        monthItems ={};

      }

      /// ////////////////////////////////////////////////////////:
      Map map = list.asMap();
      map.forEach((index, entry) {

        String entryMonth = getMonthString(entry.value['time']);
        String entryYear = getYearString(entry.value['time']);
        String key = entry.key;
        if (index == 0) {// first card /last time
          monthKey = '$entryMonth $entryYear';
          addToMonthsMap(key, entry); //
        } else {
          MapEntry<String, dynamic> prevEntry = list[index - 1];

          String currMonth =getMonthString(entry.value['time']) ;
          String prevMonth = getMonthString(prevEntry.value['time']);
          if ( currMonth == prevMonth ) {//same month
            ///print('## INDEX [ $index ] SAME month [ $currMonth - $prevMonth ]');
            addToMonthsMap(key, entry); //
            if(index == list.length - 1){
              ///print('## LAST-CARD ');
              passToNewMonth();

            }
          } else {//new month //pass to new month
            ///print('## INDEX [ $index ] DIFF month ********** [ $currMonth - $prevMonth ]');

            passToNewMonth();

            // //////////////////////

            monthKey = '$entryMonth $entryYear';
            addToMonthsMap(key, entry); //
          }
        }
      });
      ///debugPrint('## ${json['name']} => (${list.length}) ##  ${printFormattedJson(allItems)}');


    // sub the not verified invoices products qty /////////////////
    int currQty = json['currQty'].toInt();
    int qtyToSub = 0;

      List listOfAllInvoices = [];

      for (int i = 0; i < invCtr.notCheckedSellInvoices.length; i++) {//gather all products out of unverified invoices
        Invoice inv = invCtr.notCheckedSellInvoices[i];
        Map<String,dynamic> productsOut = inv.productsOut!;
        //List<Map<String,dynamic>> listOfOneInvoice = inv.productsOut!.values.toList();
        //List<Map<String, dynamic>> listOfOneInvoice = productsOut.values.toList();
        listOfAllInvoices.addAll(productsOut.values.toList());
      }
     /// print('## listOfAllInvoices [${listOfAllInvoices.length}] : ${(listOfAllInvoices)}');


      for (var map in listOfAllInvoices) {
        if (map['name'] == json['name']) {
          int q = (map['qty'] as int).toInt();
          qtyToSub += q; // Explicitly cast to int before using .toInt()
        }
      }
      // print('## currQty: ${currQty}');
      // print('## qty to sub: ${qtyToSub}');


    // MAP TO RETUEN ///
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      qtyPerUnit: json['qtyPerUnit'],
      addedTime: json['addedTime'],
      //currPrice: getLastIndexMap(prodChanges)['price'],
      currPrice: json['currPrice'].toDouble(),
      currBuyPrice: json['currBuyPrice'].toDouble(),
      //currQty:  getLastIndexMap(prodChanges)['qty'],
      currQtyReduced:  currQty - qtyToSub,
      currQty:  currQty ,
      prodChanges: prodChanges,
      buyHis: buyHis,
      sellHis: sellHis,
      allItems: allItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'qtyPerUnit': qtyPerUnit,
      'addedTime': addedTime,
      'currPrice': currPrice,
      'currBuyPrice': currBuyPrice,
      'currQty': currQty,
      'prodChanges': prodChanges,
      'buyHis': buyHis,
      'sellHis': sellHis,
    };
  }
}
