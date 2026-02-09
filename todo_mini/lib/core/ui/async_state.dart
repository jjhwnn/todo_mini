/// 화면 상태를 "표준화"하기 위한 모델입니다.
/// ViewModel(ChangeNotifier)은 이 상태만 바꾸고,
/// View(Widget)는 상태에 따라 UI만 렌더링합니다.
///
/// 장점:
/// - 모든 화면이 같은 패턴(loading/empty/error/success)으로 움직여서 유지보수 쉬움
/// - 면접에서 "상태 설계 기준"을 설명하기 쉬움

enum AsyncStatus { idle, loading, success, empty, error }

class AsyncState<T> {
  final AsyncStatus status;
  final T? data;

  /// 사용자에게 보여줄 메시지(주로 에러 메시지)
  final String? message;

  /// FirebaseException.code(예: permission-denied)를 저장하면
  /// UI에서 에러 종류별 안내를 할 수 있습니다.
  final String? code;

  const AsyncState._(
      this.status, {
        this.data,
        this.message,
        this.code,
      });

  /// 초기 상태(아무것도 안 함)
  const AsyncState.idle() : this._(AsyncStatus.idle);

  /// 로딩 중
  const AsyncState.loading() : this._(AsyncStatus.loading);

  /// 성공(데이터 있음)
  const AsyncState.success(T data) : this._(AsyncStatus.success, data: data);

  /// 성공(데이터는 없어서 비어있는 화면을 보여줘야 함)
  const AsyncState.empty() : this._(AsyncStatus.empty);

  /// 실패(메시지 필수)
  const AsyncState.error({required String message, String? code})
      : this._(AsyncStatus.error, message: message, code: code);

  bool get isIdle => status == AsyncStatus.idle;
  bool get isLoading => status == AsyncStatus.loading;
  bool get isSuccess => status == AsyncStatus.success;
  bool get isEmpty => status == AsyncStatus.empty;
  bool get isError => status == AsyncStatus.error;
}
