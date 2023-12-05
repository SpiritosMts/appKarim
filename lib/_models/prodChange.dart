import 'buySellProd.dart';

class ProdChange {
  String? time;
  double? sellPrice;
  double? buyPrice;
  int? qty;

  ProdChange({
    this.time='',
    this.sellPrice=0.0,
    this.buyPrice=0.0,
    this.qty=0,
  });

  factory ProdChange.fromJson(Map<String, dynamic> json) {
    return ProdChange(
      time: json['time'],
      sellPrice: json['price'].toDouble(),
      buyPrice: (json['buyPrice']??88888.0).toDouble(),//if this field doesnt exist in db make it zero
      qty: json['qty'].toInt(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'price': sellPrice,
      'buyPrice': buyPrice,
      'qty': qty,
    };
  }
}
