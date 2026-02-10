import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:todo_mini/data/models/app_user.dart';
import 'package:todo_mini/data/repositories/auth_repository.dart';
import 'package:todo_mini/features/home/home_placeholder_screen.dart';

class SpyAuthRepository implements AuthRepository {
  bool signedOut = false;

  @override
  Future<void> signOut() async {
    signedOut = true;
  }

  // 이 테스트에서 사용하지 않는 메서드
  @override
  Stream<String?> authUidChanges() => const Stream.empty();
  @override
  String? currentUid() => null;
  @override
  Future<String> signIn({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<String> signUp({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<String> signInWithGoogle() => throw UnimplementedError();
}

void main() {
  testWidgets('Logout button should call AuthRepository.signOut', (tester) async {
    final spy = SpyAuthRepository();

    final me = AppUser(
      id: 'uid_1',
      name: 'Kim',
      role: UserRole.user,
      createdAt: DateTime(2026, 2, 10),
    );

    await tester.pumpWidget(
      Provider<AuthRepository>.value(
        value: spy,
        child: MaterialApp(
          home: HomePlaceholderScreen(me: me),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('btn_logout')));
    await tester.pump();

    expect(spy.signedOut, true);
  });
}
