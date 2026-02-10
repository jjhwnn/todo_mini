import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../core/ui/async_state.dart';
import '../../data/models/notice.dart';
import '../../data/repositories/notice_repository.dart';

/// NoticesViewModel 책임:
/// - NoticeRepository.watchNotices() 스트림 구독
/// - loading/empty/error/success 상태를 AsyncState로 표준화
class NoticesViewModel extends ChangeNotifier {
  final NoticeRepository _repo;

  NoticesViewModel(this._repo);

  AsyncState<List<Notice>> state = const AsyncState.loading();

  StreamSubscription<List<Notice>>? _sub;

  void start() {
    // 중복 구독 방지
    _sub?.cancel();

    state = const AsyncState.loading();
    notifyListeners();

    _sub = _repo.watchNotices().listen(
      (items) {
        if (items.isEmpty) {
          state = const AsyncState.empty();
        } else {
          state = AsyncState.success(items);
        }
        notifyListeners();
      },
      onError: (e) {
        state = AsyncState.error(message: '공지 로딩 실패: $e');
        notifyListeners();
      },
    );
  }

  void retry() => start();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
