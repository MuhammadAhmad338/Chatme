// ignore_for_file: file_names, unused_local_variable
import 'package:chat_app/Models/chat.dart';
import 'package:chat_app/Screens/chatScreen.dart';
import 'package:chat_app/providers.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabChatScreen extends ConsumerStatefulWidget {
  const TabChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabChatScreenState();
}

class _TabChatScreenState extends ConsumerState<TabChatScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chat?>>(
        stream: ref.read(databaseProvider)!.getChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Some error occured"),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data ?? [];
          return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index]; // type chat
                final myUser = ref.read(firebaseAuthProvider).currentUser;
                if (chat == null) {
                  return Container();
                }
                return ListTile(
                  title: Text(
                      chat.myUid == myUser!.uid ? chat.otherName : chat.myName),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(chat: chat)));
                  },
                );
              });
        });
  }
}
