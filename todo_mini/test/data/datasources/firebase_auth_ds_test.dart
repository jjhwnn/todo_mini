import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:todo_mini/data/datasources/firebase_auth_ds.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('FirebaseAuthDataSource should be creatable (no firebase init needed)', () {
    final mockAuth = MockFirebaseAuth();
    final ds = FirebaseAuthDataSource(mockAuth);

    expect(() => ds.currentUser, returnsNormally);
    expect(ds.authStateChanges(), isA<Stream>());
  });
}
