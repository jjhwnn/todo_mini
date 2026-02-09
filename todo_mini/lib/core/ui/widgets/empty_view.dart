import 'package:flutter/material.dart';

/// "데이터 없음(Empty)" 화면 공통 컴포넌트입니다.
/// 예: 공지 리스트가 0개, 내 할 일이 0개 등
class EmptyView extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRetry; // 선택: 새로고침/재시도 버튼

  const EmptyView({
    super.key,
    this.title = '데이터가 없습니다',
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
                child: const Text('새로고침'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
