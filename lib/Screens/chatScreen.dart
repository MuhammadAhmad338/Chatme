// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_null_comparison, avoid_print, prefer_const_constructors, unused_local_variable
import 'package:chat_app/Helper/helper.dart';
import 'package:chat_app/Models/messages.dart';
import 'package:chat_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/chat.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Chat chat;
  const ChatScreen({required this.chat, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final textEditingController = TextEditingController();
  Helper helper = Helper();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chat.otherName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          actions: const [
            Icon(Icons.video_call),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Icon(Icons.call),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Icon(Icons.more_vert),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10))
          ],
        ),
        body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                      "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg",
                      fit: BoxFit.cover,
                    )),
                Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<Message>>(
                          stream: ref
                              .read(databaseProvider)!
                              .getAllMessages(widget.chat.chatId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.active &&
                                snapshot.hasData) {
                              final messages = snapshot.data ?? [];

                              return ListView.builder(
                                  reverse: false,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    final userMe = message.myUid ==
                                        ref
                                            .read(firebaseAuthProvider)
                                            .currentUser!
                                            .uid;
                                    if (userMe) {
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: myMessageBubble(message),
                                      );
                                    } else {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: otherMessageBubble(message),
                                      );
                                    }
                                  });
                            }
                            return Container();
                          }),
                    ),
                    //Sending message field
                    sendMessageField()
                  ],
                )
              ],
            )));
  }

  Widget sendMessageField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 4, right: 4),
      child: Row(children: [
        //TextField Container
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(80)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          offset: const Offset(0.0, 0.50),
                          blurRadius: 1,
                          spreadRadius: 1),
                    ]),
                child: Row(children: [
                  const SizedBox(width: 10),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 60),
                        child: Scrollbar(
                          child: TextField(
                            maxLines: null,
                            controller: textEditingController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message"),
                          ),
                        )),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.link),
                      const SizedBox(width: 10),
                      textEditingController.text.isEmpty
                          ? GestureDetector(
                              onTap: () async {
                                await helper.getSingleImageFromGallery();
                                setState(() {});
                              },
                              child: const Icon(Icons.camera_alt))
                          : const Text("")
                    ],
                  ),
                  const SizedBox(width: 12),
                ]))),
        //Send Icon Container....
        const SizedBox(width: 5),
        InkWell(
          onTap: () async {
            if (textEditingController.text.isNotEmpty) {
              await ref.read(databaseProvider)!.sendMessage(
                  widget.chat.chatId,
                  Message(
                      text: textEditingController.text,
                      myUid: ref.read(firebaseAuthProvider).currentUser!.uid,
                      time: DateTime.now().toString()));
              print("message sent");
            }
          },
          child: Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        )
      ]),
    );
  }

  Widget myMessageBubble(Message message) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin:
          const EdgeInsets.only(left: 80.0, right: 15.0, top: 7.0, bottom: 7.0),
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10))),
      child: Text(message.text),
    );
  }

  Widget otherMessageBubble(Message message) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin:
          const EdgeInsets.only(left: 15.0, right: 80.0, top: 7.0, bottom: 7.0),
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10))),
    );
  }
}
