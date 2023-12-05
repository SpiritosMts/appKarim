class Invoice {
  String? id;
  String? deliveryName;
  String? deliveryTruckNum;
  String? deliveryPhone;
  String? deliveryEmail;
  String? deliveryAddress;
  String? type;
  String? index;
  String? deliveryMatFis;

  String? timeOut;//time when inv added at first (means when you add the inv after choosing its type 'multiple,client or delivery')
  String? timeReturn;//time when inv added when check (here timeOut == timeReturn)

  Map<String, dynamic>? productsOut;//products added to inv at first
  double? outTotal;//the total at first


  Map<String, dynamic>? productsReturned;
  double? returnTotal;//the total when check the inv
  double? income;

  bool? verified;//false at pending // check at the end
  bool? totalChanged; //if outTotal != returnTotal its 'true' it means the total changed
  bool? isBuy;//if inv


  Invoice({
    this.id='no-id',
    this.deliveryName='',
    this.timeOut='',
    this.timeReturn='',
    this.deliveryMatFis='',
    this.index='',
    this.verified=false,
    this.totalChanged=false,
    this.isBuy=false,
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
      'index': index,
      'deliveryMatFis': deliveryMatFis,

      'totalChanged': totalChanged,

      'timeOut': timeOut,
      'timeReturn': timeReturn,
      'verified': verified,
      'isBuy': isBuy,

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
      isBuy: json['isBuy']?? false,//this is used when field do not exist in db
      totalChanged: json['totalChanged'],
      timeReturn: json['timeReturn'],
      verified: json['verified'],
      deliveryMatFis: json['deliveryMatFis'],
      index: json['index'],
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
