import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mini/core/ui/widgets/loading_view.dart';

void main() {
  testWidgets('LoadingView shows default message and progress indicator', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: LoadingView()),
      ),
    );

    // 기본 메시지 확인
    expect(find.text('불러오는 중...'), findsOneWidget);

    // 로딩 인디케이터 확인
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingView shows custom message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: LoadingView(message: '잠시만요')),
      ),
    );

    expect(find.text('잠시만요'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
