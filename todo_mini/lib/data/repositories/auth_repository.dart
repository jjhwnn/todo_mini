/// 상위 레이어(ViewModel)는 FirebaseAuth를 직접 몰라도 되도록
/// "AuthRepository" 인터페이스로 추상화합니다.
abstract class AuthRepository {
  /// uid 스트림 (로그인/로그아웃 감지)
  Stream<String?> authUidChanges();

  /// 현재 uid (없으면 null)
  String? currentUid();

  Future<String> signIn({required String email, required String password});
  Future<String> signUp({required String email, required String password}); // 선택
  Future<String> signInWithGoogle(); // ✅ 구글 로그인
  Future<void> signOut();
}
