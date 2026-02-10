import '../datasources/firestore_ds.dart';
import '../models/notice.dart';
import '../repositories/notice_repository.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final FirestoreDataSource _fs;
  NoticeRepositoryImpl(this._fs);

  @override
  Stream<List<Notice>> watchNotices() {
    return _fs
        .notices()
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((s) => s.docs.map(Notice.fromDoc).toList());
  }

  @override
  Future<void> createNotice(NoticeCreateInput input) async {
    await _fs.notices().add({
      'title': input.title,
      'content': input.content,
      'createdAt': _fs.serverTimestamp(),
      'updatedAt': _fs.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteNotice(String noticeId) async {
    await _fs.notices().doc(noticeId).delete();
  }
}
