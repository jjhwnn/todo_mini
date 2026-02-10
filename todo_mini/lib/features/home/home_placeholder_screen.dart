import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mini/features/todos/my_todos_screen.dart';

import '../../data/models/app_user.dart';
import '../../data/repositories/auth_repository.dart';

import '../notices/notices_screen.dart';

class HomePlaceholderScreen extends StatelessWidget {
  final AppUser me;

  const HomePlaceholderScreen({super.key, required this.me});

  Future<void> _signOut(BuildContext context) async {
    final auth = context.read<AuthRepository>();
    await auth.signOut();
  }

  void _openNotices(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NoticesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            key: const Key('btn_logout'),
            tooltip: 'Logout',
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Signed in as: ${me.name}'),
            const SizedBox(height: 8),
            Text('Role: ${me.role.name}'),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('btn_open_notices'),
                onPressed: () => _openNotices(context),
                child: const Text('공지사항 보기'),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('btn_open_my_todos'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyTodosScreen()),
                  );
                },
                child: const Text('내 할 일 보기'),
              ),
            ),

            const SizedBox(height: 16),
            const Text('Notices 기능이 연결되었습니다.'),
          ],
        ),
      ),
    );
  }
}
