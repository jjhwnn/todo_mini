import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mini/features/auth/login_screen.dart';

import 'core/ui/widgets/loading_view.dart';

import 'features/home/home_view_model.dart';
import 'features/home/home_placeholder_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo_mini',
      home: Consumer<HomeViewModel>(
        builder: (_, vm, __) {
          if (vm.meState.isLoading) {
            return const Scaffold(body: LoadingView());
          }

          if (vm.meState.isSuccess) {
            return HomePlaceholderScreen(me: vm.meState.data!);
          }

          // 로그인된 상태면 홈(임시)
          if (vm.meState.isSuccess) {
            return HomePlaceholderScreen(me: vm.meState.data!);
          }

          // 로그인 필요(또는 인증 관련 에러)면 로그인 화면
          return const LoginScreen();
        },
      ),
    );
  }
}
