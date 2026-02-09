import 'package:flutter/material.dart';

/// "에러" 화면 공통 컴포넌트입니다.
/// permission-denied 같은 케이스도 여기서 메시지를 바꿔줄 수 있습니다.
class ErrorView extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    this.title = '문제가 발생했습니다',
    this.description,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('다시 시도'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
