import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:todo_mini/features/auth/login_view_model.dart';
import 'package:todo_mini/features/auth/login_screen.dart';
import 'package:todo_mini/data/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<String?> authUidChanges() => const Stream.empty();
  @override
  String? currentUid() => null;

  @override
  Future<String> signIn({required String email, required String password}) async => 'uid';
  @override
  Future<String> signUp({required String email, required String password}) async => 'uid';
  @override
  Future<String> signInWithGoogle() async => 'uid';
  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('LoginScreen email button disabled until fields filled', (tester) async {
    final vm = LoginViewModel(FakeAuthRepository());

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    // 처음엔 비활성
    final emailBtnFinder = find.byKey(const Key('btn_signin_email'));
    ElevatedButton emailBtn = tester.widget(emailBtnFinder);
    expect(emailBtn.onPressed, isNull);

    // 이메일 입력
    await tester.enterText(find.byKey(const Key('login_email')), 'a@a.com');
    await tester.pump();

    // 비번 입력
    await tester.enterText(find.byKey(const Key('login_password')), '1234');
    await tester.pump();

    // 이제 활성
    emailBtn = tester.widget(emailBtnFinder);
    expect(emailBtn.onPressed, isNotNull);
  });
}
