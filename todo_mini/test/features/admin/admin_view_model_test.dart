import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_mini/core/ui/async_state.dart';
import 'package:todo_mini/data/models/app_user.dart';
import 'package:todo_mini/data/models/todo.dart';
import 'package:todo_mini/data/models/notice.dart';

import 'package:todo_mini/data/repositories/user_repository.dart';
import 'package:todo_mini/data/repositories/todo_repository.dart';
import 'package:todo_mini/data/repositories/notice_repository.dart';

import 'package:todo_mini/features/admin/admin_view_model.dart';

class FakeUserRepo implements UserRepository {
  List<AppUser> users = [];

  @override
  Future<List<AppUser>> getUsers() async => users;

  @override
  Future<AppUser> getOrCreateCurrentUser({required String defaultName}) => throw UnimplementedError();
  @override
  Future<AppUser> getUserById(String uid) => throw UnimplementedError();
}

class FakeTodoRepo implements TodoRepository {
  final controller = StreamController<List<Todo>>.broadcast();
  bool created = false;
  bool deleted = false;

  @override
  Stream<List<Todo>> watchAllTodos() => controller.stream;

  @override
  Future<void> createTodo(TodoCreateInput input) async {
    created = true;
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    deleted = true;
  }

  // user methods unused
  @override
  Stream<List<Todo>> watchMyTodos(String myUid) => const Stream.empty();
  @override
  Future<void> updateMyTodoStatus({required String todoId, required String myUid, required TodoStatus status}) =>
      throw UnimplementedError();
}

class FakeNoticeRepo implements NoticeRepository {
  final controller = StreamController<List<Notice>>.broadcast();
  bool created = false;
  bool deleted = false;

  @override
  Stream<List<Notice>> watchNotices() => controller.stream;

  @override
  Future<void> createNotice(NoticeCreateInput input) async {
    created = true;
  }

  @override
  Future<void> deleteNotice(String noticeId) async {
    deleted = true;
  }
}

void main() {
  test('AdminViewModel loads users and watches todo/notice streams', () async {
    final usersRepo = FakeUserRepo()
      ..users = [
        AppUser(id: 'u1', name: 'A', role: UserRole.user, createdAt: DateTime(2026, 2, 10)),
      ];
    final todoRepo = FakeTodoRepo();
    final noticeRepo = FakeNoticeRepo();

    final vm = AdminViewModel(usersRepo, todoRepo, noticeRepo);
    await vm.start();

    expect(vm.usersState.status, AsyncStatus.success);

    // stream emit → state update
    todoRepo.controller.add([
      Todo(
        id: 't1',
        title: 'T',
        description: null,
        dueDate: null,
        status: TodoStatus.open,
        assigneeId: 'u1',
        createdAt: DateTime(2026, 2, 10),
        updatedAt: DateTime(2026, 2, 10),
      )
    ]);
    noticeRepo.controller.add([
      Notice(
        id: 'n1',
        title: 'N',
        content: 'C',
        createdAt: DateTime(2026, 2, 10),
        updatedAt: DateTime(2026, 2, 10),
      )
    ]);

    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(vm.todosState.status, AsyncStatus.success);
    expect(vm.noticesState.status, AsyncStatus.success);
  });

  test('AdminViewModel create/delete actions update actionState', () async {
    final vm = AdminViewModel(FakeUserRepo(), FakeTodoRepo(), FakeNoticeRepo());

    await vm.createNotice(title: 't', content: 'c');
    expect(vm.actionState.status, AsyncStatus.success);

    await vm.createTodo(title: 't', assigneeId: 'u1');
    expect(vm.actionState.status, AsyncStatus.success);
  });
}
