import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_mini/core/ui/async_state.dart';
import 'package:todo_mini/data/models/todo.dart';
import 'package:todo_mini/data/repositories/todo_repository.dart';
import 'package:todo_mini/features/todos/my_todos_view_model.dart';

class FakeTodoRepository implements TodoRepository {
  final controller = StreamController<List<Todo>>.broadcast();
  TodoStatus? lastUpdatedStatus;

  @override
  Stream<List<Todo>> watchMyTodos(String myUid) => controller.stream;

  @override
  Future<void> updateMyTodoStatus({
    required String todoId,
    required String myUid,
    required TodoStatus status,
  }) async {
    lastUpdatedStatus = status;
  }

  // admin 메서드는 이 테스트에서 사용하지 않음
  @override
  Stream<List<Todo>> watchAllTodos() => throw UnimplementedError();
  @override
  Future<void> createTodo(TodoCreateInput input) => throw UnimplementedError();
  @override
  Future<void> deleteTodo(String todoId) => throw UnimplementedError();

  void dispose() => controller.close();
}

void main() {
  test('MyTodosViewModel becomes empty when stream emits empty', () async {
    final repo = FakeTodoRepository();
    final vm = MyTodosViewModel(repo);

    vm.start(myUid: 'uid_1');
    repo.controller.add([]);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.status, AsyncStatus.empty);

    repo.dispose();
  });

  test('MyTodosViewModel becomes success when stream emits items', () async {
    final repo = FakeTodoRepository();
    final vm = MyTodosViewModel(repo);

    vm.start(myUid: 'uid_1');
    repo.controller.add([
      Todo(
        id: 't1',
        title: 'A',
        description: null,
        dueDate: null,
        status: TodoStatus.open,
        assigneeId: 'uid_1',
        createdAt: DateTime(2026, 2, 10),
        updatedAt: DateTime(2026, 2, 10),
      ),
    ]);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.status, AsyncStatus.success);
    expect(vm.state.data!.length, 1);

    repo.dispose();
  });
}
