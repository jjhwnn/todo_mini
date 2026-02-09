import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:todo_mini/data/datasources/firestore_ds.dart';

void main() {
  test('FirestoreDataSource should provide collection references', () {
    final fakeDb = FakeFirebaseFirestore();
    final ds = FirestoreDataSource(fakeDb);

    expect(ds.users().path, 'users');
    expect(ds.todos().path, 'todos');
    expect(ds.notices().path, 'notices');
  });
}
