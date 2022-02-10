class Order {
  String? paymentID;
  String? billID;
  String? total;
  String? paidStatus;
  String? date;

  Order({required this.paymentID,
      required this.billID,
      required this.total,
      required this.paidStatus,
      required this.date,
  });

Order.fromJson(Map<String, dynamic> json) {
  paymentID = json['paymentID'];
  billID = json['billID'];
  total = json['total'];
  paidStatus = json['paidStatus'];
  date = json['date'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['paymentID'] = paymentID;
  data['billID'] = billID;
  data['total'] = total;
  data['paidStatus'] = paidStatus;
  data['date'] = date;
  return data; } 
}