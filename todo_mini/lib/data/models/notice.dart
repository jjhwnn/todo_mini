import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore 컬렉션: notices
///
/// 필드(스펙):
/// - title: string (필수, 1~80)
/// - content: string (필수, 1~2000)
/// - createdAt: timestamp (필수)
/// - updatedAt: timestamp (필수)
class Notice {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notice.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Notice.fromDoc: document data is null (${doc.id})');
    }

    return Notice(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      content: (data['content'] ?? '') as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
  };
}
