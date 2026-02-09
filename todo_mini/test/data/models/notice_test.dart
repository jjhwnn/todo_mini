import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mini/data/models/notice.dart';

void main() {
  test('Notice toJson should include title/content only', () {
    final notice = Notice(
      id: 'n1',
      title: 'Hello',
      content: 'World',
      createdAt: DateTime(2026, 2, 1),
      updatedAt: DateTime(2026, 2, 1),
    );

    final json = notice.toJson();
    expect(json.keys, containsAll(['title', 'content']));
    expect(json.keys, isNot(contains('createdAt')));
    expect(json.keys, isNot(contains('updatedAt')));
  });
}
