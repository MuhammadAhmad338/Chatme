// ignore_for_file: file_names, unused_local_variable, await_only_futures, unnecessary_null_comparison, use_build_context_synchronously, avoid_print
import 'package:chat_app/Models/chat.dart';
import 'package:chat_app/Screens/chatScreen.dart';
import 'package:chat_app/providers.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/useModel.dart';

class SelectPersonToChatScreen extends ConsumerWidget {
  const SelectPersonToChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Select Person To Chat"),
      ),
      body: SafeArea(
          child: StreamBuilder<List<UserModel>>(
              stream: ref.watch(databaseProvider)!.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final usersList = snapshot.data ?? [];

                return ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      final user = usersList[index];
                      final myUser = ref.read(firebaseAuthProvider).currentUser;
                      if (user.uid == myUser!.uid) {
                        return Container();
                      }
                      return Column(
                        children: [
                          ListTile(
                              title: Text(user.name),
                              onTap: () async {
                                final chatId = await ref
                                        .read(databaseProvider)
                                        ?.getChatStarted(
                                            myUser.uid, user.uid) ??
                                    false;

                                if (chatId == "") {
                                  await ref
                                      .read(databaseProvider)!
                                      .startChats(
                                          myUser.uid, user.uid, user.name)
                                      .then((value) => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) {
                                            return ChatScreen(
                                                chat: Chat(
                                                    myUid: myUser.uid,
                                                    myName: "",
                                                    otherUid: user.uid,
                                                    otherName: user.name,
                                                    chatId: value));
                                          })));
                                } else {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ChatScreen(
                                        chat: Chat(
                                            myUid: myUser.uid,
                                            myName: "",
                                            otherUid: user.uid,
                                            otherName: user.name,
                                            chatId: chatId.toString()));
                                  }));
                                }
                              }),
                          const Divider()
                        ],
                      );
                    });
              })),
    );
  }
}
