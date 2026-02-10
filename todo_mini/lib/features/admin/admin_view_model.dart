import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../core/ui/async_state.dart';
import '../../data/models/app_user.dart';
import '../../data/models/todo.dart';
import '../../data/models/notice.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/repositories/todo_repository.dart';
import '../../data/repositories/notice_repository.dart';

/// AdminViewModel 책임:
/// - admin 화면에서 필요한 데이터 스트림/리스트 로딩
/// - create/delete 같은 액션 처리
///
/// NOTE:
/// - users는 "목록 한번 로딩" (stream 필요 없음)
/// - todos/notices는 stream 기반으로 실시간 반영
class AdminViewModel extends ChangeNotifier {
  final UserRepository _users;
  final TodoRepository _todos;
  final NoticeRepository _notices;

  AdminViewModel(this._users, this._todos, this._notices);

  AsyncState<List<AppUser>> usersState = const AsyncState.loading();
  AsyncState<List<Todo>> todosState = const AsyncState.loading();
  AsyncState<List<Notice>> noticesState = const AsyncState.loading();

  AsyncState<void> actionState = const AsyncState.idle();

  StreamSubscription<List<Todo>>? _todoSub;
  StreamSubscription<List<Notice>>? _noticeSub;

  Future<void> start() async {
    await loadUsers();
    watchTodos();
    watchNotices();
  }

  Future<void> loadUsers() async {
    usersState = const AsyncState.loading();
    notifyListeners();

    try {
      final list = await _users.getUsers();
      usersState = list.isEmpty ? const AsyncState.empty() : AsyncState.success(list);
      notifyListeners();
    } catch (e) {
      usersState = AsyncState.error(message: '유저 로딩 실패: $e');
      notifyListeners();
    }
  }

  void watchTodos() {
    _todoSub?.cancel();
    todosState = const AsyncState.loading();
    notifyListeners();

    _todoSub = _todos.watchAllTodos().listen(
      (items) {
        todosState = items.isEmpty ? const AsyncState.empty() : AsyncState.success(items);
        notifyListeners();
      },
      onError: (e) {
        todosState = AsyncState.error(message: '전체 할 일 로딩 실패: $e');
        notifyListeners();
      },
    );
  }

  void watchNotices() {
    _noticeSub?.cancel();
    noticesState = const AsyncState.loading();
    notifyListeners();

    _noticeSub = _notices.watchNotices().listen(
      (items) {
        noticesState = items.isEmpty ? const AsyncState.empty() : AsyncState.success(items);
        notifyListeners();
      },
      onError: (e) {
        noticesState = AsyncState.error(message: '공지 로딩 실패: $e');
        notifyListeners();
      },
    );
  }

  Future<void> createTodo({
    required String title,
    String? description,
    DateTime? dueDate,
    required String assigneeId,
  }) async {
    actionState = const AsyncState.loading();
    notifyListeners();

    try {
      await _todos.createTodo(
        TodoCreateInput(
          title: title,
          description: description,
          dueDate: dueDate,
          assigneeId: assigneeId,
        ),
      );
      actionState = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      actionState = AsyncState.error(message: '할 일 생성 실패: $e');
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    actionState = const AsyncState.loading();
    notifyListeners();

    try {
      await _todos.deleteTodo(todoId);
      actionState = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      actionState = AsyncState.error(message: '할 일 삭제 실패: $e');
      notifyListeners();
    }
  }

  Future<void> createNotice({required String title, required String content}) async {
    actionState = const AsyncState.loading();
    notifyListeners();

    try {
      await _notices.createNotice(NoticeCreateInput(title: title, content: content));
      actionState = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      actionState = AsyncState.error(message: '공지 생성 실패: $e');
      notifyListeners();
    }
  }

  Future<void> deleteNotice(String noticeId) async {
    actionState = const AsyncState.loading();
    notifyListeners();

    try {
      await _notices.deleteNotice(noticeId);
      actionState = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      actionState = AsyncState.error(message: '공지 삭제 실패: $e');
      notifyListeners();
    }
  }

  void resetActionState() {
    if (actionState.isError || actionState.isSuccess) {
      actionState = const AsyncState.idle();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _todoSub?.cancel();
    _noticeSub?.cancel();
    super.dispose();
  }
}
