import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_mini/data/models/app_user.dart';

void main() {
  test('AppUser toJson should map role correctly', () {
    final u1 = AppUser(
      id: 'uid',
      name: 'Kim',
      role: UserRole.user,
      createdAt: DateTime(2026, 1, 1),
    );
    expect(u1.toJson()['role'], 'user');

    final u2 = AppUser(
      id: 'uid',
      name: 'Admin',
      role: UserRole.admin,
      createdAt: DateTime(2026, 1, 1),
    );
    expect(u2.toJson()['role'], 'admin');
  });

  test('AppUser fromJson should parse timestamp and role', () {
    final json = {
      'name': 'Lee',
      'role': 'admin',
      'createdAt': Timestamp.fromDate(DateTime(2026, 2, 1)),
    };

    final user = AppUser.fromJson('uid_1', json);
    expect(user.id, 'uid_1');
    expect(user.name, 'Lee');
    expect(user.role, UserRole.admin);
    expect(user.createdAt, DateTime(2026, 2, 1));
  });
}
