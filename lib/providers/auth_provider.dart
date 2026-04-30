import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/user.dart';
import 'package:hayagsync_app/services/auth_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthState {
  final bool isLoading;
  final String? token;
  final User? user;
  final String? error;

  const AuthState({this.isLoading = false, this.token, this.user, this.error});

  AuthState copyWith({
    bool? isLoading,
    String? token,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => token != null;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _loadSession();
    return const AuthState();
  }

  Future<void> _loadSession() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    try {
      final data = await AuthService.profile(token);

      final user = User.fromJson(data['user'] ?? data);

      state = state.copyWith(token: token, user: user);
    } catch (_) {
      await TokenStorage.clearToken();
      state = const AuthState();
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final data = await AuthService.login(
        email: email,
        password: password,
        deviceToken: fcmToken,
      );

      final token = data['token'];
      final user = User.fromJson(data['user']);

      await TokenStorage.saveToken(token);

      state = state.copyWith(isLoading: false, token: token, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Future<void> register() async {}

  Future<void> logout() async {
    if (state.token != null) {
      await AuthService.logout(state.token!);
    }

    await TokenStorage.clearToken();
    state = const AuthState();
  }
}
