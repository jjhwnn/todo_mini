import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/ui/widgets/loading_view.dart';
import 'core/ui/widgets/error_view.dart';

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

          // 에러 상태(로그인 필요 포함)
          return Scaffold(
            body: ErrorView(
              title: '로그인이 필요합니다',
              description: vm.meState.message,
              // 로그인 화면이 아직 placeholder라 retry는 start() 재호출 정도만 제공
              onRetry: vm.start,
            ),
          );
        },
      ),
    );
  }
}
