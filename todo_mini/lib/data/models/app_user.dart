import 'package:cloud_firestore/cloud_firestore.dart';

/// 유저 역할
/// - user: 일반 사용자(공지 읽기, 내 todo 읽기/상태 변경)
/// - admin: 관리자(todo/notice CRUD)
enum UserRole { user, admin }

/// Firestore 컬렉션: users
/// 문서 ID: uid
///
/// 필드(스펙):
/// - name: string (필수)
/// - role: "admin" | "user" (필수)
/// - createdAt: timestamp (필수; serverTimestamp 권장)
class AppUser {
  final String id; // Firestore 문서 ID = Firebase Auth uid
  final String name;
  final UserRole role;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  /// Firestore DocumentSnapshot -> AppUser 변환
  /// - createdAt이 없거나 잘못된 경우 대비: DateTime.now() fallback
  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('AppUser.fromDoc: document data is null (${doc.id})');
    }

    final roleStr = (data['role'] ?? 'user') as String;

    return AppUser(
      id: doc.id,
      name: (data['name'] ?? '') as String,
      role: roleStr == 'admin' ? UserRole.admin : UserRole.user,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// 저장/업데이트에 쓰는 JSON.
  /// createdAt/updatedAt 같은 서버 타임스탬프는 Repository에서 serverTimestamp로 넣는 것을 권장.
  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role == UserRole.admin ? 'admin' : 'user',
  };

  /// 테스트/디버깅에 유용한 생성자(선택)
  factory AppUser.fromJson(String id, Map<String, dynamic> json) {
    final roleStr = (json['role'] ?? 'user') as String;
    return AppUser(
      id: id,
      name: (json['name'] ?? '') as String,
      role: roleStr == 'admin' ? UserRole.admin : UserRole.user,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
