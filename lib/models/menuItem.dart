class MenuItemModel {
  final String id;
  final String name;
  final String price;
  final String userId;

  MenuItemModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.userId});

  factory MenuItemModel.fromJson(Map<String, dynamic> json, String id) {
    return MenuItemModel(
      id: id,
      name: json['name'],
      price: json['price'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'userId': userId,
    };
  }
}
