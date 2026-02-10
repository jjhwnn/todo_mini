import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:todo_mini/data/datasources/firebase_auth_ds.dart';
import 'package:todo_mini/data/repositories_impl/auth_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AuthRepositoryImpl should emit uid changes', () async {
    final mockAuth = MockFirebaseAuth();
    final ds = FirebaseAuthDataSource(mockAuth);
    final repo = AuthRepositoryImpl(ds);

    // 초기에는 로그아웃 상태일 수 있음(null)
    final first = await repo.authUidChanges().first;
    expect(first, isNull);
  });
}
