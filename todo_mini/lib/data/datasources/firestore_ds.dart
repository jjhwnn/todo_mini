import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore SDK 접근을 캡슐화하는 DataSource입니다.
/// - 컬렉션 경로를 한 군데로 모아서 오타/중복을 줄입니다.
/// - Repository에서만 사용하도록 설계합니다.
class FirestoreDataSource {
  final FirebaseFirestore _db;

  FirestoreDataSource(this._db);

  /// users 컬렉션
  CollectionReference<Map<String, dynamic>> users() => _db.collection('users');

  /// todos 컬렉션
  CollectionReference<Map<String, dynamic>> todos() => _db.collection('todos');

  /// notices 컬렉션
  CollectionReference<Map<String, dynamic>> notices() => _db.collection('notices');

  /// 서버 시간 타임스탬프(권장)
  /// - createdAt/updatedAt에 사용
  FieldValue serverTimestamp() => FieldValue.serverTimestamp();
}
