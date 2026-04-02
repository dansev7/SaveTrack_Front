class AuthResponse {
  final String token;
  final String name;
  final String email;
  final String userId;

  AuthResponse({
    required this.token,
    required this.name,
    required this.email,
    required this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      name: json['name'],
      email: json['email'],
      userId: json['userId'],
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;

  UserProfile({required this.id, required this.name, required this.email});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}