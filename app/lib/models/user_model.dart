class User {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profilePictureUrl; 

  User({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profilePictureUrl,
  });
  static User empty = User(
    id: '',
    name: '',
    email: '',
    bio: null,
    profilePictureUrl: null,
  );
  factory User.emptyFactory() => empty;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? profilePictureUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}