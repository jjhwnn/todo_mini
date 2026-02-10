import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../core/ui/async_state.dart';
import '../../data/models/app_user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';

/// HomeViewModel의 책임:
/// 1) 로그인 상태(authUidChanges) 구독
/// 2) 로그인되어 있으면 users/{uid} 문서 보장(getOrCreateCurrentUser)
/// 3) role(user/admin) 로딩 → 이후 UI에서 분기 가능
class HomeViewModel extends ChangeNotifier {
  final AuthRepository _auth;
  final UserRepository _users;

  HomeViewModel(this._auth, this._users);

  /// meState 성공이면 현재 사용자(AppUser)가 준비된 상태
  AsyncState<AppUser> meState = const AsyncState.loading();

  StreamSubscription<String?>? _sub;

  bool get isSignedIn => meState.isSuccess;
  bool get isAdmin => meState.data?.role == UserRole.admin;

  /// 앱 시작 시 1회 호출.
  /// auth 상태 변화를 구독해서 로그인/로그아웃에 반응합니다.
  void start() {
    _sub?.cancel();

    meState = const AsyncState.loading();
    notifyListeners();

    _sub = _auth.authUidChanges().listen(
      (uid) async {
        if (uid == null) {
          // 로그아웃 상태(또는 아직 로그인 전)
          meState = const AsyncState.error(message: '로그인이 필요합니다.');
          notifyListeners();
          return;
        }

        // 로그인 상태면 users 문서 확보
        await bootstrap();
      },
      onError: (e) {
        meState = AsyncState.error(message: '인증 상태를 확인할 수 없습니다: $e');
        notifyListeners();
      },
    );
  }

  /// 로그인된 사용자의 users 문서를 가져오거나(없으면 생성) meState에 저장합니다.
  Future<void> bootstrap() async {
    meState = const AsyncState.loading();
    notifyListeners();

    try {
      final me = await _users.getOrCreateCurrentUser(defaultName: 'New User');
      meState = AsyncState.success(me);
      notifyListeners();
    } catch (e) {
      meState = AsyncState.error(message: '유저 정보를 불러오지 못했습니다: $e');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
