import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;
}

class UserProfileStore extends ChangeNotifier {
  UserProfileStore._();

  static final UserProfileStore instance = UserProfileStore._();

  UserProfile? _current;

  UserProfile? get current => _current;

  void register({
    required String name,
    required String email,
    required String phone,
  }) {
    _current = UserProfile(
      name: name.trim().isEmpty ? 'Utilisateur' : name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    notifyListeners();
  }

  void signIn({required String email}) {
    final normalizedEmail = email.trim();
    final localPart = normalizedEmail.split('@').first;
    final name = localPart
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');

    _current = UserProfile(
      name: name.isEmpty ? 'Utilisateur' : name,
      email: normalizedEmail,
      phone: '',
    );
    notifyListeners();
  }

  void update(UserProfile profile) {
    _current = profile;
    notifyListeners();
  }

  void clear() {
    _current = null;
    notifyListeners();
  }
}
