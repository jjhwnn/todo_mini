import 'package:flutter/foundation.dart';
import '../../core/ui/async_state.dart';
import '../../data/repositories/auth_repository.dart';

/// LoginViewModel 책임:
/// - 이메일/비밀번호 로그인
/// - Google 로그인
/// - 로딩/에러 상태 관리(AsyncState)
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _auth;

  LoginViewModel(this._auth);

  String email = '';
  String password = '';

  AsyncState<void> state = const AsyncState.idle();

  void setEmail(String v) {
    email = v.trim();
    notifyListeners();
  }

  void setPassword(String v) {
    password = v;
    notifyListeners();
  }

  bool get canSubmit => email.isNotEmpty && password.isNotEmpty && !state.isLoading;

  Future<void> signInWithEmail() async {
    state = const AsyncState.loading();
    notifyListeners();

    try {
      await _auth.signIn(email: email, password: password);
      state = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      state = AsyncState.error(message: '이메일 로그인 실패: $e');
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncState.loading();
    notifyListeners();

    try {
      await _auth.signInWithGoogle();
      state = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      state = AsyncState.error(message: 'Google 로그인 실패: $e');
      notifyListeners();
    }
  }

  void resetError() {
    if (state.isError) {
      state = const AsyncState.idle();
      notifyListeners();
    }
  }
}
