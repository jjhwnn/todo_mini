import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:todo_mini/data/datasources/firebase_auth_ds.dart';
import 'package:todo_mini/data/datasources/firestore_ds.dart';

import 'package:todo_mini/data/repositories/auth_repository.dart';
import 'package:todo_mini/data/repositories/user_repository.dart';
import 'package:todo_mini/data/repositories/todo_repository.dart';
import 'package:todo_mini/data/repositories/notice_repository.dart';

import 'package:todo_mini/data/repositories_impl/auth_repository_impl.dart';
import 'package:todo_mini/data/repositories_impl/user_repository_impl.dart';
import 'package:todo_mini/data/repositories_impl/todo_repository_impl.dart';
import 'package:todo_mini/data/repositories_impl/notice_repository_impl.dart';

/// Provider wiring이 깨지면 런타임에서 늦게 터질 수 있어서,
/// "Repo까지 DI가 생성 가능한가"만 확인하는 스모크 테스트를 둡니다.
/// (ViewModel은 다음 PR들에서 레이어가 생길 때 추가)
void main() {
  testWidgets('Provider DI should create datasources and repositories', (tester) async {
    final mockAuth = MockFirebaseAuth();
    final fakeDb = FakeFirebaseFirestore();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          // DataSources (Fake/Mock)
          Provider(create: (_) => FirebaseAuthDataSource(mockAuth)),
          Provider(create: (_) => FirestoreDataSource(fakeDb)),

          // Repositories
          Provider<AuthRepository>(create: (ctx) => AuthRepositoryImpl(ctx.read())),
          Provider<UserRepository>(create: (ctx) => UserRepositoryImpl(ctx.read(), ctx.read())),
          Provider<TodoRepository>(create: (ctx) => TodoRepositoryImpl(ctx.read())),
          Provider<NoticeRepository>(create: (ctx) => NoticeRepositoryImpl(ctx.read())),
        ],
        child: const MaterialApp(home: Scaffold(body: SizedBox())),
      ),
    );

    // pump 성공 + 위젯 존재 = wiring 성공(생성 중 예외 없었음)
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
