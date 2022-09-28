// ignore_for_file: file_names, unused_local_variable
import 'package:chat_app/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Models/useModel.dart';

class AuthWidget extends ConsumerWidget {
  final WidgetBuilder signInBuilder;
  final WidgetBuilder notSignedInBuilder;

  const AuthWidget(
      {required this.signInBuilder, required this.notSignedInBuilder, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    return authStateChanges.when(
        data: (user) => user != null
            ? signedInHandler(context, ref, user)
            : notSignedInBuilder(context),
        error: (_, __) {
          return const Scaffold(
              body: Center(
            child: Text("Something went wrong"),
          ));
        },
        loading: () {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  FutureBuilder<UserModel?> signedInHandler(context, WidgetRef ref, User user) {
    final database = ref.read(databaseProvider)!;
    final futureUserPotential = database.getUser(user.uid);
    return FutureBuilder<UserModel?>(
        future: futureUserPotential,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final potentialUser = snapshot.data;
            if (potentialUser == null) {
              database.addUser(
                  UserModel(uid: user.uid, name: ref.read(nameProvider).name));
            }
            return signInBuilder(context);
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
