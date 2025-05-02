class User {
  final int id;
  final String name;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
        id: jsonData['id'],
        name: jsonData['name'],
        email: jsonData['email'],
        role: jsonData['role'],
       );
  }
}
