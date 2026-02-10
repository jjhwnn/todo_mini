import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/app_user.dart';
import '../../data/repositories/auth_repository.dart';

class HomePlaceholderScreen extends StatelessWidget {
  final AppUser me;

  const HomePlaceholderScreen({super.key, required this.me});

  Future<void> _signOut(BuildContext context) async {
    final auth = context.read<AuthRepository>();
    await auth.signOut();
    // 별도 네비게이션 처리는 하지 않습니다.
    // authUidChanges() 변화 → HomeViewModel이 감지 → App이 LoginScreen으로 분기
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
            const Text(
              'Logout 버튼 클릭 시 AuthRepository.signOut 호출 →\n'
              'HomeViewModel이 authUidChanges()로 감지하여 로그인 화면으로 분기됩니다.',
            ),
          ],
        ),
      ),
    );
  }
}
