class User {
  final int? id;
  final String username;
  final String password;
  final String email;
  final String dateNaissance;

  const User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.dateNaissance,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'email': email,
        'dateNaissance': dateNaissance,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int?,
        username: map['username'] as String,
        password: map['password'] as String,
        email: map['email'] as String,
        dateNaissance: map['dateNaissance'] as String,
      );
}
