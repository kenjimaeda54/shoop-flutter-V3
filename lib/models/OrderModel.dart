import "CartProductModel.dart";

class OrderModel {
  final String id;
  final double total;
  final List<CartProductModel> products;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}
