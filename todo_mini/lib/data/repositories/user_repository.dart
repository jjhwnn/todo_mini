import '../models/app_user.dart';

abstract class UserRepository {
  /// 로그인 직후 호출: users/{uid}가 없으면 생성하고 반환
  Future<AppUser> getOrCreateCurrentUser({required String defaultName});

  Future<AppUser> getUserById(String uid);

  /// admin이 assignee 선택할 때 사용
  Future<List<AppUser>> getUsers();
}
