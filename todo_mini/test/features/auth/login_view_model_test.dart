import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mini/core/ui/async_state.dart';
import 'package:todo_mini/features/auth/login_view_model.dart';
import 'package:todo_mini/data/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  bool shouldFailEmail = false;
  bool shouldFailGoogle = false;

  @override
  Stream<String?> authUidChanges() => const Stream.empty();

  @override
  String? currentUid() => null;

  @override
  Future<String> signIn({required String email, required String password}) async {
    if (shouldFailEmail) throw Exception('email fail');
    return 'uid_1';
  }

  @override
  Future<String> signUp({required String email, required String password}) async {
    return 'uid_1';
  }

  @override
  Future<String> signInWithGoogle() async {
    if (shouldFailGoogle) throw Exception('google fail');
    return 'uid_1';
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  test('LoginViewModel signInWithEmail success', () async {
    final repo = FakeAuthRepository();
    final vm = LoginViewModel(repo);

    vm.setEmail('a@a.com');
    vm.setPassword('1234');

    await vm.signInWithEmail();

    expect(vm.state.status, AsyncStatus.success);
  });

  test('LoginViewModel signInWithEmail failure', () async {
    final repo = FakeAuthRepository()..shouldFailEmail = true;
    final vm = LoginViewModel(repo);

    vm.setEmail('a@a.com');
    vm.setPassword('1234');

    await vm.signInWithEmail();

    expect(vm.state.status, AsyncStatus.error);
    expect(vm.state.message, contains('이메일 로그인 실패'));
  });

  test('LoginViewModel signInWithGoogle success', () async {
    final repo = FakeAuthRepository();
    final vm = LoginViewModel(repo);

    await vm.signInWithGoogle();
    expect(vm.state.status, AsyncStatus.success);
  });

  test('LoginViewModel signInWithGoogle failure', () async {
    final repo = FakeAuthRepository()..shouldFailGoogle = true;
    final vm = LoginViewModel(repo);

    await vm.signInWithGoogle();
    expect(vm.state.status, AsyncStatus.error);
    expect(vm.state.message, contains('Google 로그인 실패'));
  });
}
