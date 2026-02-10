import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/widgets/loading_view.dart';
import '../../core/ui/widgets/error_view.dart';
import 'login_view_model.dart';

/// LoginScreen은 UI만 담당.
/// - 실제 로그인 동작은 LoginViewModel에 위임합니다.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (_, vm, __) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (vm.state.isLoading) const LoadingView(message: '로그인 중...'),
                if (vm.state.isError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ErrorView(
                      title: '로그인 실패',
                      description: vm.state.message,
                      onRetry: vm.resetError,
                    ),
                  ),

                TextField(
                  key: const Key('login_email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: vm.setEmail,
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('login_password'),
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: vm.setPassword,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('btn_signin_email'),
                    onPressed: vm.canSubmit ? vm.signInWithEmail : null,
                    child: const Text('이메일로 로그인'),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    key: const Key('btn_signin_google'),
                    onPressed: vm.state.isLoading ? null : vm.signInWithGoogle,
                    child: const Text('Google로 로그인'),
                  ),
                ),

                const Spacer(),

                const Text(
                  '※ 계정 생성은 콘솔에서 미리 만들어도 되고,\n다음 PR에서 SignUp UI를 추가해도 됩니다.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
