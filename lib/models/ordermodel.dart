class OrderModel {
  String id;
  String customerName;
  String address;
  String note;
  Map<String, int> items;
  double totalPrice;
  bool isConfirmed;
  String ownerId;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.address,
    required this.note,
    required this.items,
    required this.totalPrice,
    required this.isConfirmed,
    required this.ownerId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      customerName: json['customerName'] ?? '',
      address: json['address'] ?? '',
      note: json['note'] ?? '',
      items: Map<String, int>.from(json['items'] ?? {}),
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
      isConfirmed: json['isConfirmed'] ?? false,
      ownerId: json['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'address': address,
      'note': note,
      'items': items,
      'totalPrice': totalPrice,
      'isConfirmed': isConfirmed,
      'ownerId': ownerId,
    };
  }
}
