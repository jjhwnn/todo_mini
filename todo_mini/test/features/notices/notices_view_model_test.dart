import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_mini/core/ui/async_state.dart';
import 'package:todo_mini/data/models/notice.dart';
import 'package:todo_mini/data/repositories/notice_repository.dart';
import 'package:todo_mini/features/notices/notices_view_model.dart';

class FakeNoticeRepository implements NoticeRepository {
  final controller = StreamController<List<Notice>>.broadcast();

  @override
  Stream<List<Notice>> watchNotices() => controller.stream;

  // admin 메서드는 이 테스트에서 사용하지 않음
  @override
  Future<void> createNotice(NoticeCreateInput input) => throw UnimplementedError();
  @override
  Future<void> deleteNotice(String noticeId) => throw UnimplementedError();

  void dispose() => controller.close();
}

void main() {
  test('NoticesViewModel should become empty when stream emits empty list', () async {
    final repo = FakeNoticeRepository();
    final vm = NoticesViewModel(repo);

    vm.start();
    repo.controller.add([]);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.status, AsyncStatus.empty);

    repo.dispose();
  });

  test('NoticesViewModel should become success when stream emits items', () async {
    final repo = FakeNoticeRepository();
    final vm = NoticesViewModel(repo);

    vm.start();
    repo.controller.add([
      Notice(
        id: 'n1',
        title: 't',
        content: 'c',
        createdAt: DateTime(2026, 2, 10),
        updatedAt: DateTime(2026, 2, 10),
      ),
    ]);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.status, AsyncStatus.success);
    expect(vm.state.data!.length, 1);

    repo.dispose();
  });

  test('NoticesViewModel should become error on stream error', () async {
    final repo = FakeNoticeRepository();
    final vm = NoticesViewModel(repo);

    vm.start();
    repo.controller.addError(Exception('boom'));

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.status, AsyncStatus.error);

    repo.dispose();
  });
}
