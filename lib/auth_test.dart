import 'package:firebase_auth/firebase_auth.dart';

Future<void> registerUser() async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'test@atmosphere.com',
      password: '12345678',
    );
    if (credential.user != null) {
      print('Пользователь создан!');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      print('Пользователь уже существует.');
    } else {
      rethrow;
    }
  }
}
