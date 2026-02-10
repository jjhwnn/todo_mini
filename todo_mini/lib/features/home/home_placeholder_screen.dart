import 'package:flutter/material.dart';
import '../../data/models/app_user.dart';

class HomePlaceholderScreen extends StatelessWidget {
  final AppUser me;

  const HomePlaceholderScreen({super.key, required this.me});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Signed in as: ${me.name}'),
            const SizedBox(height: 8),
            Text('Role: ${me.role.name}'),
            const SizedBox(height: 16),
            const Text(
              'HomeBootstrap 완료!\n다음 PR에서 Login/Home UI를 본격 구현합니다.',
            ),
          ],
        ),
      ),
    );
  }
}
