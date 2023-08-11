class Invoice {
  String? id;
  String? deliveryName;
  String? deliveryTruckNum;
  String? deliveryPhone;
  String? deliveryEmail;
  String? deliveryAddress;
  String? type;

  String? timeOut;
  Map<String, dynamic>? productsOut;
  double? outTotal;


  String? timeReturn;
  Map<String, dynamic>? productsReturned;
  double? returnTotal;
  double? income;

  bool? verified;//false at pending // check at the end
  bool? totalChanged;


  Invoice({
    this.id='no-id',
    this.deliveryName='',
    this.timeOut='',
    this.timeReturn='',
    this.verified=false,
    this.totalChanged=false,
    this.deliveryAddress='',
    this.type='',
    this.deliveryTruckNum='',
    this.deliveryPhone='',
    this.deliveryEmail='',
    this.productsOut=const{},
    this.productsReturned = const{},
    this.outTotal=0.0,
    this.returnTotal=0.0,
    this.income=0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliveryName': deliveryName,
      'deliveryTruckNum': deliveryTruckNum,
      'deliveryPhone': deliveryPhone,
      'deliveryEmail': deliveryEmail,
      'deliveryAddress': deliveryAddress,
      'type': type,

      'totalChanged': totalChanged,

      'timeOut': timeOut,
      'timeReturn': timeReturn,
      'verified': verified,

      'productsOut': productsOut,
      'productsReturned': productsReturned,

      'outTotal': outTotal,
      'returnTotal': returnTotal,
      'income': income,
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      deliveryName: json['deliveryName'],
      timeOut: json['timeOut'],
      type: json['type'],
      totalChanged: json['totalChanged'],
      timeReturn: json['timeReturn'],
      verified: json['verified'],
      deliveryAddress: json['deliveryAddress'],
      deliveryTruckNum: json['deliveryTruckNum'],
      deliveryPhone: json['deliveryPhone'],
      deliveryEmail: json['deliveryEmail'],
      productsOut: json['productsOut'],
      productsReturned: json['productsReturned'],
      outTotal: json['outTotal'].toDouble(),
      returnTotal: json['returnTotal'].toDouble(),
      income: json['income'].toDouble(),
    );
  }
}
