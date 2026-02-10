# todo_mini

Firebase 기반의 **공지 + 할 일(Todo) + 관리자(Admin) 기능**을 갖춘 미니 앱입니다.  
아키텍처는 **MVVM + Repository(DataSource 추상화) + Provider**로 구성되어 있고, USER/ADMIN 권한에 따라 기능 범위를 분리했습니다.

---

## 주요 기능

### 사용자(USER)
- 로그인: 이메일/비밀번호, Google 로그인
- 로그아웃
- 공지사항 목록/상세 조회
- 내 할 일 목록 조회
- 내 할 일 **status만 변경**(OPEN ↔ DONE)

### 관리자(ADMIN)
- 유저 목록 조회
- 전체 Todo 조회
- Todo 생성/삭제(배정 포함)
- 공지 생성/삭제
- 홈에서 **admin role일 때만** 관리자 화면 진입 버튼 노출

---

## 기술 스택
- Flutter
- 상태관리: **Provider**
- 아키텍처: **MVVM**
- Data Layer: **Repository + DataSource**
- Backend: **Firebase (Auth, Firestore)**
- Login: Email/Password + Google Sign-In
- Testing: flutter_test + fake_cloud_firestore + firebase_auth_mocks

---

## 폴더 구조(요약)

```txt
lib/
  core/
    ui/
      async_state.dart
      widgets/ (LoadingView, ErrorView, EmptyView ...)
  data/
    models/ (AppUser, Todo, Notice ...)
    datasources/
      firebase_auth_ds.dart
      firestore_ds.dart
    repositories/
      auth_repository.dart
      user_repository.dart
      todo_repository.dart
      notice_repository.dart
    repositories_impl/
      auth_repository_impl.dart
      user_repository_impl.dart
      todo_repository_impl.dart
      notice_repository_impl.dart
  features/
    auth/
      login_view_model.dart
      login_screen.dart
    home/
      home_view_model.dart
      home_placeholder_screen.dart
    notices/
      notices_view_model.dart
      notices_screen.dart
      notice_detail_screen.dart
    todos/
      my_todos_view_model.dart
      my_todos_screen.dart
      todo_detail_view_model.dart
      todo_detail_screen.dart
    admin/
      admin_view_model.dart
      admin_screen.dart
      create_todo_dialog.dart
      create_notice_dialog.dart
  main.dart
  app.dart

test/
  app/ (provider wiring test)
  features/
    auth/ (login vm/screen tests)
    home/ (bootstrap tests, logout tests)
    notices/ (vm/screen tests)
    todos/ (vm tests)
    admin/ (vm tests)
