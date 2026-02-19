// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app.dart';

// ------------------------------
// DataSources
// ------------------------------
import 'data/datasources/firebase_auth_ds.dart';
import 'data/datasources/firestore_ds.dart';

// ------------------------------
// Repositories (interfaces)
// ------------------------------
import 'data/repositories/auth_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/todo_repository.dart';
import 'data/repositories/notice_repository.dart';

// ------------------------------
// Repositories (implementations)
// ------------------------------
import 'data/repositories_impl/auth_repository_impl.dart';
import 'data/repositories_impl/user_repository_impl.dart';
import 'data/repositories_impl/todo_repository_impl.dart';
import 'data/repositories_impl/notice_repository_impl.dart';

// ------------------------------
// ViewModels
// ------------------------------
import 'features/home/home_view_model.dart';
import 'features/auth/login_view_model.dart';
import 'features/notices/notices_view_model.dart';
import 'features/todos/my_todos_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const _Root());
}

/// 앱 최상단 Root 위젯을 분리해두면,
/// Provider 트리 변경 시에도 구조가 안정적이고 디버깅이 쉽습니다.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // =========================================================
        // 1) DataSources (Firebase SDK wrapper)
        // =========================================================
        Provider<FirebaseAuthDataSource>(
          create: (_) => FirebaseAuthDataSource(FirebaseAuth.instance),
        ),
        Provider<FirestoreDataSource>(
          create: (_) => FirestoreDataSource(FirebaseFirestore.instance),
        ),

        // =========================================================
        // 2) Repositories (interface -> impl)
        //    ⚠️ ViewModel에서 ctx.read<Repo>()를 쓰려면 반드시 위에 있어야 함
        // =========================================================
        Provider<AuthRepository>(
          create: (ctx) => AuthRepositoryImpl(
            ctx.read<FirebaseAuthDataSource>(),
          ),
        ),
        Provider<UserRepository>(
          create: (ctx) => UserRepositoryImpl(
            ctx.read<FirestoreDataSource>(),
            ctx.read<AuthRepository>(),
          ),
        ),
        Provider<TodoRepository>(
          create: (ctx) => TodoRepositoryImpl(
            ctx.read<FirestoreDataSource>(),
          ),
        ),
        Provider<NoticeRepository>(
          create: (ctx) => NoticeRepositoryImpl(
            ctx.read<FirestoreDataSource>(),
          ),
        ),

        // =========================================================
        // 3) ViewModels (ChangeNotifier)
        // =========================================================

        /// 앱 부팅 시 authUidChanges()를 구독하고 users/{uid} 문서 bootstrap 수행
        ChangeNotifierProvider<HomeViewModel>(
          create: (ctx) => HomeViewModel(
            ctx.read<AuthRepository>(),
            ctx.read<UserRepository>(),
          )..start(),
        ),

        /// 로그인 화면에서 사용(이메일/구글 로그인)
        ChangeNotifierProvider<LoginViewModel>(
          create: (ctx) => LoginViewModel(
            ctx.read<AuthRepository>(),
          ),
        ),

        /// 공지 목록 스트림 구독(앱 시작부터 붙여도 되고, 화면 진입 시 start()로 바꿔도 됨)
        ChangeNotifierProvider<NoticesViewModel>(
          create: (ctx) => NoticesViewModel(
            ctx.read<NoticeRepository>(),
          )..start(),
        ),

        /// 내 할 일은 myUid가 필요해서, 화면에서 start(myUid: ...) 호출하는 구조
        ChangeNotifierProvider<MyTodosViewModel>(
          create: (ctx) => MyTodosViewModel(
            ctx.read<TodoRepository>(),
          ),
        ),
      ],
      child: const App(),
    );
  }
}
