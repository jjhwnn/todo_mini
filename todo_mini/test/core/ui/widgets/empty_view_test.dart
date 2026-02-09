import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mini/core/ui/widgets/empty_view.dart';

void main() {
  testWidgets('EmptyView shows title and optional description', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyView(
            title: '비었어요',
            description: '표시할 항목이 없습니다',
          ),
        ),
      ),
    );

    expect(find.text('비었어요'), findsOneWidget);
    expect(find.text('표시할 항목이 없습니다'), findsOneWidget);

    // onRetry가 없으면 버튼이 없어야 함
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('EmptyView shows retry button when onRetry is provided', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyView(
            title: '데이터 없음',
            onRetry: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // 버튼이 보여야 함
    expect(find.widgetWithText(ElevatedButton, '새로고침'), findsOneWidget);

    // 탭하면 콜백이 호출되어야 함
    await tester.tap(find.widgetWithText(ElevatedButton, '새로고침'));
    await tester.pump();

    expect(tapped, true);
  });
}
