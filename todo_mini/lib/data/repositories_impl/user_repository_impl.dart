import '../datasources/firestore_ds.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreDataSource _fs;
  final AuthRepository _auth;

  UserRepositoryImpl(this._fs, this._auth);

  @override
  Future<AppUser> getOrCreateCurrentUser({required String defaultName}) async {
    final uid = _auth.currentUid();
    if (uid == null) throw StateError('Not signed in');

    final ref = _fs.users().doc(uid);
    final snap = await ref.get();

    if (snap.exists) {
      return AppUser.fromDoc(snap);
    }

    // users 문서가 없으면 생성(과제 요구)
    await ref.set({
      'name': defaultName,
      'role': 'user',
      'createdAt': _fs.serverTimestamp(),
    });

    final created = await ref.get();
    return AppUser.fromDoc(created);
  }

  @override
  Future<AppUser> getUserById(String uid) async {
    final snap = await _fs.users().doc(uid).get();
    if (!snap.exists) throw StateError('User not found');
    return AppUser.fromDoc(snap);
  }

  @override
  Future<List<AppUser>> getUsers() async {
    final q = await _fs.users().orderBy('createdAt', descending: true).get();
    return q.docs.map(AppUser.fromDoc).toList();
  }
}
