import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_mini/core/ui/async_state.dart';
import 'package:todo_mini/data/models/app_user.dart';
import 'package:todo_mini/features/home/home_view_model.dart';
import 'package:todo_mini/data/repositories/auth_repository.dart';
import 'package:todo_mini/data/repositories/user_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<String?>.broadcast();
  String? _uid;

  // 테스트 편의: 로그인/로그아웃 이벤트 발행
  void emitUid(String? uid) {
    _uid = uid;
    _controller.add(uid);
  }

  @override
  Stream<String?> authUidChanges() => _controller.stream;

  @override
  String? currentUid() => _uid;

  // 아래 메서드는 이 테스트에서 사용하지 않으므로 throw로 충분
  @override
  Future<String> signIn({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<String> signUp({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<String> signInWithGoogle() => throw UnimplementedError();
  @override
  Future<void> signOut() => throw UnimplementedError();

  void dispose() => _controller.close();
}

class FakeUserRepository implements UserRepository {
  AppUser? nextUser;
  Object? nextError;

  @override
  Future<AppUser> getOrCreateCurrentUser({required String defaultName}) async {
    if (nextError != null) throw nextError!;
    return nextUser ??
        AppUser(
          id: 'uid_1',
          name: defaultName,
          role: UserRole.user,
          createdAt: DateTime(2026, 2, 10),
        );
  }

  @override
  Future<AppUser> getUserById(String uid) => throw UnimplementedError();

  @override
  Future<List<AppUser>> getUsers() => throw UnimplementedError();
}

void main() {
  test('HomeViewModel should set error when logged out', () async {
    final auth = FakeAuthRepository();
    final users = FakeUserRepository();
    final vm = HomeViewModel(auth, users);

    vm.start();
    auth.emitUid(null);

    // Stream 처리 시간을 조금 줌
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(vm.meState.status, AsyncStatus.error);
    expect(vm.meState.message, contains('로그인이 필요'));
    auth.dispose();
  });

  test('HomeViewModel should bootstrap user when logged in', () async {
    final auth = FakeAuthRepository();
    final users = FakeUserRepository()
      ..nextUser = AppUser(
        id: 'uid_1',
        name: 'Kim',
        role: UserRole.admin,
        createdAt: DateTime(2026, 2, 10),
      );

    final vm = HomeViewModel(auth, users);

    vm.start();
    auth.emitUid('uid_1');

    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(vm.meState.status, AsyncStatus.success);
    expect(vm.meState.data!.name, 'Kim');
    expect(vm.isAdmin, true);

    auth.dispose();
  });

  test('HomeViewModel should set error when bootstrap fails', () async {
    final auth = FakeAuthRepository();
    final users = FakeUserRepository()..nextError = Exception('boom');
    final vm = HomeViewModel(auth, users);

    vm.start();
    auth.emitUid('uid_1');

    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(vm.meState.status, AsyncStatus.error);
    expect(vm.meState.message, contains('유저 정보를 불러오지 못했습니다'));
    auth.dispose();
  });
}
