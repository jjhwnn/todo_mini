import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/firestore_ds.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final FirestoreDataSource _fs;
  TodoRepositoryImpl(this._fs);

  @override
  Stream<List<Todo>> watchMyTodos(String myUid) {
    // 정렬은 단순화: status + createdAt (인덱스 부담 최소화)
    return _fs
        .todos()
        .where('assigneeId', isEqualTo: myUid)
        .orderBy('status')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(Todo.fromDoc).toList());
  }

  @override
  Future<void> updateMyTodoStatus({
    required String todoId,
    required String myUid,
    required TodoStatus status,
  }) async {
    // ✅ USER API는 status만 수정하도록 제한(1차 방어)
    // 최종 방어는 Firestore rules에서 status/updatedAt만 변경 가능하게 제한해야 함.
    await _fs.todos().doc(todoId).update({
      'status': status == TodoStatus.done ? 'done' : 'open',
      'updatedAt': _fs.serverTimestamp(),
    });
  }

  @override
  Stream<List<Todo>> watchAllTodos() {
    return _fs
        .todos()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(Todo.fromDoc).toList());
  }

  @override
  Future<void> createTodo(TodoCreateInput input) async {
    await _fs.todos().add({
      'title': input.title,
      'description': input.description,
      'dueDate': input.dueDate == null ? null : Timestamp.fromDate(input.dueDate!),
      'status': 'open',
      'assigneeId': input.assigneeId,
      'createdAt': _fs.serverTimestamp(),
      'updatedAt': _fs.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _fs.todos().doc(todoId).delete();
  }
}
