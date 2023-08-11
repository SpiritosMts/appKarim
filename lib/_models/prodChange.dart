import 'buySellProd.dart';

class ProdChange {
  String? time;
  double? price;
  int? qty;

  ProdChange({
    this.time='',
    this.price=0.0,
    this.qty=0,
  });

  factory ProdChange.fromJson(Map<String, dynamic> json) {
    return ProdChange(
      time: json['time'],
      price: json['price'].toDouble(),
      qty: json['qty'].toInt(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'price': price,
      'qty': qty,
    };
  }
}
