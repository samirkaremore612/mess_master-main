class User {
  final String name;
  final int phone;
  final String reg;
  final int fee;
  final int plan;
  final String expiry;
  final String image;

  User({
    required this.name,
    required this.phone,
    required this.reg,
    required this.fee,
    required this.plan,
    required this.expiry,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'Name': name,
    'Phone': phone,
    'Registration Date': reg,
    'Fee Paid': fee,
    'Plan': plan,
    'Expiry Date': expiry,
    'Image': image
  };

  static User fromJson(Map<String, dynamic> json) => User(
    name: json['Name'],
    phone: json['Phone'],
    reg: json['Registration Date'],
    fee: json['Fee Paid'],
    plan: json['Plan'],
    expiry: json['Expiry Date'],
    image: json['Image']
  );
}