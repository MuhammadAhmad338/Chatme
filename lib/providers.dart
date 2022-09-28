// ignore_for_file: unused_import, unused_local_variable, unnecessary_null_comparison
import 'package:chat_app/Services/cloud_fireStore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final databaseProvider = Provider<CloudFireStore?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  String? uid = auth.asData?.value?.uid;
  if (uid != null) {
    return CloudFireStore(uid: uid);
  }
  return null;
});

final nameProvider = ChangeNotifierProvider<UserText>((ref) {
  return UserText();
});

class UserText extends ChangeNotifier {
  String name = "";
  setName(String username) {
    name = username;
    notifyListeners();
  }
}
