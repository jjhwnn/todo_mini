import 'package:cloud_firestore/cloud_firestore.dart';

/// Todo 상태
enum TodoStatus { open, done }

/// Firestore 컬렉션: todos
///
/// 필드(스펙):
/// - title: string (필수, 1~50)
/// - description: string? (선택)
/// - dueDate: timestamp? (선택)
/// - status: "open" | "done" (필수)
/// - assigneeId: string (필수: users.uid)
/// - createdAt: timestamp (필수)
/// - updatedAt: timestamp (필수)
class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TodoStatus status;
  final String assigneeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.assigneeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Todo.fromDoc: document data is null (${doc.id})');
    }

    final statusStr = (data['status'] ?? 'open') as String;

    return Todo(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      description: data['description'] as String?,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      status: statusStr == 'done' ? TodoStatus.done : TodoStatus.open,
      assigneeId: (data['assigneeId'] ?? '') as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Firestore write 용 JSON(필요한 필드만)
  /// - createdAt/updatedAt은 Repository에서 serverTimestamp 권장
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
    'status': status == TodoStatus.done ? 'done' : 'open',
    'assigneeId': assigneeId,
  };

  /// UI에서 토글 처리를 쉽게 하기 위한 헬퍼
  TodoStatus get toggledStatus => status == TodoStatus.done ? TodoStatus.open : TodoStatus.done;
}
