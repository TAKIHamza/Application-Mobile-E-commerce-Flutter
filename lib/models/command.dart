class Command {
  final int id;
  final int userId;
  final String userName;
  final String email;
  final int productId;
  final String productTitle;
  final double productPrice;
  final String image;
  final String adresse;
  final String telephone;
  final int quantity;
  final int isValidate;
  final int received;
  final String dateCommand;
  Command({
    required this.id,
    required this.userId,
    required this.userName,
    required this.email,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.image,
    required this.adresse,
    required this.telephone,
    required this.quantity,
    required this.isValidate,
    required this.received,
    required this.dateCommand
  });

  factory Command.fromJson(Map<String, dynamic> jsonData) {
    return Command(
      id: jsonData['id_command'],
      userId: jsonData['user_id'],
      userName: jsonData['user_name'],
      email: jsonData['email'],
      productId: jsonData['product_id'],
      productTitle: jsonData['product_title'],
      productPrice: jsonData['product_price'].toDouble(),
      image: jsonData['image'],
      adresse: jsonData['adresse'],
      telephone: jsonData['telephone'],
      quantity: jsonData['quantity'],
      isValidate: jsonData['is_validate'],
      received: jsonData['received'],
      dateCommand :jsonData['created_date'],
    );
  }
}
