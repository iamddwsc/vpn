class SubscriptionModel {
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  SubscriptionModel({this.type, this.price});
  final String? type;
  final double? price;
}
