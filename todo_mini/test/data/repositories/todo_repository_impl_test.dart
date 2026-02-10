import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:todo_mini/data/datasources/firestore_ds.dart';
import 'package:todo_mini/data/models/todo.dart';
import 'package:todo_mini/data/repositories/todo_repository.dart';
import 'package:todo_mini/data/repositories_impl/todo_repository_impl.dart';

void main() {
  test('TodoRepositoryImpl.createTodo should create a document with expected fields', () async {
    final db = FakeFirebaseFirestore();
    final fs = FirestoreDataSource(db);
    final repo = TodoRepositoryImpl(fs);

    await repo.createTodo(
      TodoCreateInput(title: 'T', assigneeId: 'uid_1', description: 'D'),
    );

    final snap = await db.collection('todos').get();
    expect(snap.docs.length, 1);

    final data = snap.docs.first.data();
    expect(data['title'], 'T');
    expect(data['assigneeId'], 'uid_1');
    expect(data['status'], 'open');
    expect(data.containsKey('createdAt'), true);
    expect(data.containsKey('updatedAt'), true);
  });

  test('TodoRepositoryImpl.updateMyTodoStatus should only update status/updatedAt', () async {
    final db = FakeFirebaseFirestore();
    final fs = FirestoreDataSource(db);
    final repo = TodoRepositoryImpl(fs);

    // 문서 미리 생성
    final doc = await db.collection('todos').add({
      'title': 'Hello',
      'description': 'keep',
      'dueDate': null,
      'status': 'open',
      'assigneeId': 'uid_1',
      'createdAt': DateTime(2026, 2, 1),
      'updatedAt': DateTime(2026, 2, 1),
    });

    await repo.updateMyTodoStatus(
      todoId: doc.id,
      myUid: 'uid_1',
      status: TodoStatus.done,
    );

    final updated = await db.collection('todos').doc(doc.id).get();
    final data = updated.data()!;

    // status는 변경되어야 함
    expect(data['status'], 'done');

    // 다른 필드는 변경되지 않아야 함(Repository 정책)
    expect(data['title'], 'Hello');
    expect(data['description'], 'keep');
    expect(data['assigneeId'], 'uid_1');
  });
}
