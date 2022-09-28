// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:chat_app/Helper/helper.dart';
import 'package:chat_app/Screens/callScreen.dart';
import 'package:chat_app/Screens/selectPersonToChatScreen.dart';
import 'package:chat_app/Screens/signUpandsignIn.dart';
import 'package:chat_app/Screens/statusScreen.dart';
import 'package:chat_app/Screens/tabChatScreen.dart';
import 'package:chat_app/Screens/tavBarViewScreen.dart';
import 'package:chat_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  Helper helper = Helper();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, initialIndex: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.7,
          leading: IconButton(
              onPressed: () async {
                await helper.getCameraImages();
                setState(() {});
              },
              icon: const Icon(Icons.camera_alt)),
          title: const Text("ChatApp",
              style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: [
                const Tab(text: "Chats"),
                const Tab(text: "Status"),
                const Tab(text: "Calls")
              ]),
          actions: [
            const Icon(Icons.search),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Sign Out?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            ElevatedButton(
                                onPressed: () async {
                                  await ref
                                      .read(firebaseAuthProvider)
                                      .signOut()
                                      .then((value) => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpAndSignIn())));
                                },
                                child: const Text("Sign Out"))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.more_vert)),
          ]),
      body: TabBarView(controller: tabController, children: [
        const TabChatScreen(),
        StatusScreen(),
        const CallScreen()
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SelectPersonToChatScreen()));
          },
          child: const Icon(
            Icons.message,
            color: Colors.white,
          )),
    );
  }
}
