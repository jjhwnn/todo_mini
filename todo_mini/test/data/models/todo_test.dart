import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_mini/data/models/todo.dart';

void main() {
  test('Todo toJson should serialize dueDate/status', () {
    final todo = Todo(
      id: 't1',
      title: 'Read docs',
      description: 'project onboarding',
      dueDate: DateTime(2026, 2, 10),
      status: TodoStatus.open,
      assigneeId: 'uid_1',
      createdAt: DateTime(2026, 2, 1),
      updatedAt: DateTime(2026, 2, 1),
    );

    final json = todo.toJson();
    expect(json['title'], 'Read docs');
    expect(json['status'], 'open');
    expect(json['assigneeId'], 'uid_1');
    expect(json['dueDate'], isA<Timestamp>());
  });

  test('Todo toggledStatus should switch between open/done', () {
    final openTodo = Todo(
      id: 't',
      title: 't',
      description: null,
      dueDate: null,
      status: TodoStatus.open,
      assigneeId: 'u',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expect(openTodo.toggledStatus, TodoStatus.done);

    final doneTodo = Todo(
      id: 't',
      title: 't',
      description: null,
      dueDate: null,
      status: TodoStatus.done,
      assigneeId: 'u',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expect(doneTodo.toggledStatus, TodoStatus.open);
  });
}
