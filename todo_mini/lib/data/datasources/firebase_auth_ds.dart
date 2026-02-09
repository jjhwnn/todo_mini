import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;

  // v7+ : 생성자 대신 싱글톤 instance 사용
  final GoogleSignIn _googleSignIn;

  // v7+ : initialize가 비동기라, 1회만 보장하기 위해 플래그 둠
  bool _googleInitialized = false;

  // 필요하면 clientId/serverClientId를 외부에서 주입 가능 (웹/서버 연동 시)
  final String? _clientId;
  final String? _serverClientId;

  FirebaseAuthDataSource(
      this._auth, {
        GoogleSignIn? googleSignIn,
        String? clientId,
        String? serverClientId,
      })  : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _clientId = clientId,
        _serverClientId = serverClientId;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await _googleSignIn.initialize(
      clientId: _clientId,
      serverClientId: _serverClientId,
    );
    _googleInitialized = true;
  }

  /// ✅ Google 로그인 (google_sign_in v7+)
  /// - 로그인(인증): authenticate()
  /// - Firebase Auth에는 idToken만 있어도 credential 생성 가능 (accessToken은 선택)
  ///   google_sign_in v7에서 auth 토큰은 idToken만 제공됩니다. :contentReference[oaicite:1]{index=1}
  Future<UserCredential> signInWithGoogle({
    List<String> scopeHint = const <String>[],
  }) async {
    await _ensureGoogleInitialized();

    // v7: signIn() 없음 -> authenticate()
    final account = await _googleSignIn.authenticate(scopeHint: scopeHint);

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google idToken is null');
    }

    // Firebase 문서에서도 Google sign-in → credential → signInWithCredential 흐름 :contentReference[oaicite:2]{index=2}
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // google_sign_in v7: signOut 메서드 존재 :contentReference[oaicite:3]{index=3}
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
