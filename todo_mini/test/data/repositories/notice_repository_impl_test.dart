import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:todo_mini/data/datasources/firestore_ds.dart';
import 'package:todo_mini/data/repositories/notice_repository.dart';
import 'package:todo_mini/data/repositories_impl/notice_repository_impl.dart';

void main() {
  test('NoticeRepositoryImpl.createNotice should create a notice document', () async {
    final db = FakeFirebaseFirestore();
    final fs = FirestoreDataSource(db);
    final repo = NoticeRepositoryImpl(fs);

    await repo.createNotice(NoticeCreateInput(title: 'N', content: 'C'));

    final snap = await db.collection('notices').get();
    expect(snap.docs.length, 1);

    final data = snap.docs.first.data();
    expect(data['title'], 'N');
    expect(data['content'], 'C');
    expect(data.containsKey('createdAt'), true);
    expect(data.containsKey('updatedAt'), true);
  });
}
