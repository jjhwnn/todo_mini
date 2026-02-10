import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../core/ui/async_state.dart';
import '../../data/models/todo.dart';
import '../../data/repositories/todo_repository.dart';

/// MyTodosViewModel 책임:
/// - 내 todo 스트림 구독
/// - 리스트 상태(loading/empty/error/success) 관리
class MyTodosViewModel extends ChangeNotifier {
  final TodoRepository _repo;

  MyTodosViewModel(this._repo);

  AsyncState<List<Todo>> state = const AsyncState.loading();
  StreamSubscription<List<Todo>>? _sub;

  String? _myUid;

  /// 내 uid가 정해진 뒤에 start를 호출해야 합니다.
  /// - HomeBootstrap 성공 후(me.id) 화면에서 호출하는 구조가 깔끔합니다.
  void start({required String myUid}) {
    if (_myUid == myUid && _sub != null) return;

    _myUid = myUid;
    _sub?.cancel();

    state = const AsyncState.loading();
    notifyListeners();

    _sub = _repo.watchMyTodos(myUid).listen(
      (items) {
        if (items.isEmpty) {
          state = const AsyncState.empty();
        } else {
          state = AsyncState.success(items);
        }
        notifyListeners();
      },
      onError: (e) {
        state = AsyncState.error(message: '내 할 일 로딩 실패: $e');
        notifyListeners();
      },
    );
  }

  void retry() {
    final uid = _myUid;
    if (uid != null) start(myUid: uid);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
