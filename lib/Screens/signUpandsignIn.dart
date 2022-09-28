// ignore_for_file: file_names, unused_local_variable, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, empty_catches, use_build_context_synchronously, avoid_print
import 'package:chat_app/Screens/homeScreen.dart';
import 'package:chat_app/providers.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpAndSignIn extends ConsumerStatefulWidget {
  const SignUpAndSignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpAndSignInState();
}

class _SignUpAndSignInState extends ConsumerState<SignUpAndSignIn> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(" Sign In / Sign Up ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 5),
              ElevatedButton(
                  child: const Text("Sign Up ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Sign Up"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    autofocus: true,
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                        labelText: "Name"),
                                  ),
                                  TextField(
                                      autofocus: true,
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          labelText: "Email")),
                                  TextField(
                                    autofocus: true,
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        labelText: "Password"),
                                  )
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        if (nameController.text != "") {
                                          ref
                                              .read(nameProvider)
                                              .setName(nameController.text);
                                          await ref
                                              .read(firebaseAuthProvider)
                                              .createUserWithEmailAndPassword(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text);
                                        }
                                      } catch (err) {
                                        print(err);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            ));
                  }),
              ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            "Sign In",
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                autofocus: true,
                                controller: emailController,
                                decoration:
                                    const InputDecoration(labelText: "Email"),
                              ),
                              TextField(
                                controller: passwordController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    labelText: "Password"),
                              )
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(firebaseAuthProvider)
                                        .signInWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);
                                    ;
                                  } catch (err) {
                                    print(err);
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                          ],
                        );
                      });
                },
                child: const Text(
                  "Sign In ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
