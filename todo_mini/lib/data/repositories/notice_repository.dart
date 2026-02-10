import '../models/notice.dart';

class NoticeCreateInput {
  final String title;
  final String content;

  NoticeCreateInput({required this.title, required this.content});
}

abstract class NoticeRepository {
  Stream<List<Notice>> watchNotices();

  // ADMIN
  Future<void> createNotice(NoticeCreateInput input);
  Future<void> deleteNotice(String noticeId); // 또는 updateNotice도 가능
}
