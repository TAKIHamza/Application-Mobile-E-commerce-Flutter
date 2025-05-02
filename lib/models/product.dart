

class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final String description;
  late int cartQuantity = 0;

  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.category,
      required this.image,
      required this.description});

  factory Product.fromJson(Map<String, dynamic> jsonData) {
    return Product(
        id: jsonData['id'],
        title: jsonData['title'],
        price: jsonData['price'].toDouble(),
        category: jsonData['catigory'],
        description: jsonData['description'],
        image: jsonData['image']);
  }
}
