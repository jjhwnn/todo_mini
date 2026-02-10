import 'package:flutter_test/flutter_test.dart';

import 'package:todo_mini/core/ui/async_state.dart';
import 'package:todo_mini/data/models/todo.dart';
import 'package:todo_mini/data/repositories/todo_repository.dart';
import 'package:todo_mini/features/todos/todo_detail_view_model.dart';

class SpyTodoRepository implements TodoRepository {
  TodoStatus? updatedTo;

  @override
  Future<void> updateMyTodoStatus({
    required String todoId,
    required String myUid,
    required TodoStatus status,
  }) async {
    updatedTo = status;
  }

  // 나머지 메서드는 사용 안 함
  @override
  Stream<List<Todo>> watchMyTodos(String myUid) => const Stream.empty();
  @override
  Stream<List<Todo>> watchAllTodos() => throw UnimplementedError();
  @override
  Future<void> createTodo(TodoCreateInput input) => throw UnimplementedError();
  @override
  Future<void> deleteTodo(String todoId) => throw UnimplementedError();
}

void main() {
  test('TodoDetailViewModel toggles status via status-only API', () async {
    final repo = SpyTodoRepository();
    final vm = TodoDetailViewModel(repo);

    final todo = Todo(
      id: 't1',
      title: 'A',
      description: null,
      dueDate: null,
      status: TodoStatus.open,
      assigneeId: 'uid_1',
      createdAt: DateTime(2026, 2, 10),
      updatedAt: DateTime(2026, 2, 10),
    );

    await vm.toggleStatus(todo: todo, myUid: 'uid_1');

    expect(vm.state.status, AsyncStatus.success);
    expect(repo.updatedTo, TodoStatus.done);
  });
}
