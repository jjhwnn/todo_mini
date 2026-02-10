import '../models/todo.dart';

class TodoCreateInput {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String assigneeId;

  TodoCreateInput({
    required this.title,
    required this.assigneeId,
    this.description,
    this.dueDate,
  });
}

/// Todo 데이터 접근 추상화.
/// 핵심 포인트:
/// - USER는 "status만 변경"하도록 API를 분리해 1차 방어
/// - 최종 방어는 Firestore Security Rules에서 필드 제한
abstract class TodoRepository {
  // USER
  Stream<List<Todo>> watchMyTodos(String myUid);

  /// ✅ USER 전용 API: status만 수정 가능
  Future<void> updateMyTodoStatus({
    required String todoId,
    required String myUid,
    required TodoStatus status,
  });

  // ADMIN
  Stream<List<Todo>> watchAllTodos();
  Future<void> createTodo(TodoCreateInput input);
  Future<void> deleteTodo(String todoId);
}
