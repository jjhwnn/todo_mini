import 'package:flutter/foundation.dart';

import '../../core/ui/async_state.dart';
import '../../data/models/todo.dart';
import '../../data/repositories/todo_repository.dart';

/// TodoDetailViewModel 책임:
/// - status 토글 요청 처리
/// - USER는 status만 업데이트하도록 repository API 사용
class TodoDetailViewModel extends ChangeNotifier {
  final TodoRepository _repo;

  TodoDetailViewModel(this._repo);

  AsyncState<void> state = const AsyncState.idle();

  Future<void> toggleStatus({
    required Todo todo,
    required String myUid,
  }) async {
    state = const AsyncState.loading();
    notifyListeners();

    try {
      await _repo.updateMyTodoStatus(
        todoId: todo.id,
        myUid: myUid,
        status: todo.toggledStatus,
      );
      state = const AsyncState.success(null);
      notifyListeners();
    } catch (e) {
      state = AsyncState.error(message: '상태 변경 실패: $e');
      notifyListeners();
    }
  }

  void resetError() {
    if (state.isError) {
      state = const AsyncState.idle();
      notifyListeners();
    }
  }
}
