import 'package:docs_clone/colors.dart';
import 'package:docs_clone/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(authServiceProvider).signInwithGoogle();
    if (errorModel.error == "null") {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push("/");
    } else {
      sMessenger.showSnackBar(customSnackBar(content: errorModel.error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context, ref),
          icon: Image.asset(
            'assets/images/g-logo-2.png',
            height: 20,
          ),
          label: const Text(
            "Sign in with google",
            style: TextStyle(color: KBlackColor),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: KwhiteColor, minimumSize: const Size(150, 50)),
        ),
      ),
    );
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
