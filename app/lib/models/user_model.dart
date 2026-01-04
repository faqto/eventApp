class User {
  final String id;
  final String name;
  final String email;
  String? profilePictureUrl;
  String? bio;
  bool isLoggedIn;

  final String passwordHash;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.bio,
    this.isLoggedIn = false,
    this.passwordHash = '',
  });
    factory User.empty() => User(
        id: '',
        name: '',
        email: '',
        passwordHash: '',
      );
}
