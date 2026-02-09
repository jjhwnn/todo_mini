import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mini/core/ui/widgets/error_view.dart';

void main() {
  testWidgets('ErrorView shows default title and optional description', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ErrorView(
            description: '에러가 났습니다',
          ),
        ),
      ),
    );

    // 기본 타이틀
    expect(find.text('문제가 발생했습니다'), findsOneWidget);
    expect(find.text('에러가 났습니다'), findsOneWidget);

    // onRetry가 없으면 버튼이 없어야 함
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('ErrorView shows retry button when onRetry is provided', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            title: '실패',
            description: '다시 시도해주세요',
            onRetry: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('실패'), findsOneWidget);
    expect(find.text('다시 시도해주세요'), findsOneWidget);

    // 버튼 노출 및 클릭 확인
    expect(find.widgetWithText(ElevatedButton, '다시 시도'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '다시 시도'));
    await tester.pump();

    expect(tapped, true);
  });
}
