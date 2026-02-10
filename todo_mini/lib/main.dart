import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app.dart';

// Firebase SDK
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DataSources
import 'data/datasources/firebase_auth_ds.dart';
import 'data/datasources/firestore_ds.dart';

// Repositories (interfaces)
import 'data/repositories/auth_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/todo_repository.dart';
import 'data/repositories/notice_repository.dart';

// Repositories (impl)
import 'data/repositories_impl/auth_repository_impl.dart';
import 'data/repositories_impl/user_repository_impl.dart';
import 'data/repositories_impl/todo_repository_impl.dart';
import 'data/repositories_impl/notice_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        // -----------------------------
        // 1) DataSource (Firebase SDK wrapper)
        // -----------------------------
        Provider(
          create: (_) => FirebaseAuthDataSource(FirebaseAuth.instance),
        ),
        Provider(
          create: (_) => FirestoreDataSource(FirebaseFirestore.instance),
        ),

        // -----------------------------
        // 2) Repository (interface -> impl)
        // -----------------------------
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
      ],
      child: const App(),
    ),
  );
}
