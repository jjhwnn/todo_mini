import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:todo_mini/data/models/notice.dart';
import 'package:todo_mini/data/repositories/notice_repository.dart';
import 'package:todo_mini/features/notices/notices_screen.dart';
import 'package:todo_mini/features/notices/notices_view_model.dart';

class FakeNoticeRepository implements NoticeRepository {
  final controller = StreamController<List<Notice>>.broadcast();

  @override
  Stream<List<Notice>> watchNotices() => controller.stream;

  @override
  Future<void> createNotice(NoticeCreateInput input) => throw UnimplementedError();
  @override
  Future<void> deleteNotice(String noticeId) => throw UnimplementedError();

  void dispose() => controller.close();
}

void main() {
  testWidgets('NoticesScreen shows empty view when no notices', (tester) async {
    final repo = FakeNoticeRepository();
    final vm = NoticesViewModel(repo)..start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NoticeRepository>.value(value: repo),
          ChangeNotifierProvider<NoticesViewModel>.value(value: vm),
        ],
        child: const MaterialApp(home: NoticesScreen()),
      ),
    );

    // stream이 아직 안 왔으니 loading일 수 있음 → 빈 리스트 발행
    repo.controller.add([]);
    await tester.pump(const Duration(milliseconds: 10));

    expect(find.text('공지사항이 없습니다'), findsOneWidget);

    repo.dispose();
  });
}
