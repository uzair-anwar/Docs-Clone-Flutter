import 'package:docs_clone/colors.dart';
import 'package:docs_clone/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authServiceProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KwhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            color: KBlackColor,
          ),
          IconButton(
            onPressed: () {
              signOut(ref);
            },
            icon: const Icon(Icons.logout),
            color: KRedColor,
          )
        ],
      ),
      body: Center(
        child: Text(ref.watch(userProvider)!.email),
      ),
    );
  }
}
