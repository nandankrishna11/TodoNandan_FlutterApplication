class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
} 