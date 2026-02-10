import '../datasources/firebase_auth_ds.dart';
import '../repositories/auth_repository.dart';

/// AuthRepository 구현체.
/// - FirebaseAuthDataSource에 위임
/// - ViewModel에서는 FirebaseAuth를 직접 모르도록 분리
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _ds;

  AuthRepositoryImpl(this._ds);

  @override
  Stream<String?> authUidChanges() => _ds.authStateChanges().map((u) => u?.uid);

  @override
  String? currentUid() => _ds.currentUser?.uid;

  @override
  Future<String> signIn({required String email, required String password}) async {
    final cred = await _ds.signIn(email, password);
    return cred.user!.uid;
  }

  @override
  Future<String> signUp({required String email, required String password}) async {
    final cred = await _ds.signUp(email, password);
    return cred.user!.uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final cred = await _ds.signInWithGoogle();
    return cred.user!.uid;
  }

  @override
  Future<void> signOut() => _ds.signOut();
}
