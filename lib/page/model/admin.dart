class Admin {
  final String imagePath;
  final String name;
  final String email;

  const Admin({
    required this.imagePath,
    required this.name,
    required this.email
});

  Admin copy({
    String? imagePath,
    String? name,
    String? email,
    String? password,
}) => Admin(
    imagePath: imagePath ?? this.imagePath,
    name: name ?? this.name,
    email: email ?? this.email,
  );

  static Admin fromJson(Map<String, dynamic> json) => Admin(
    imagePath: json['imagePath'],
    name: json['name'],
    email: json['email']
  );

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'name': name,
    'email': email,
  };
}