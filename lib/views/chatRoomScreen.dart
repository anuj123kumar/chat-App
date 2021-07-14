import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRooms;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshots) {
        return snapshots.hasData
            ? ListView.builder(
                itemCount: snapshots.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      userName: snapshots.data.docs[index].data()["chatRoomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshots.data.docs[index].data()["chatRoomId"],
                  );
                }) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRooms = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png"),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(width: 8,),
            Text(
              userName,
              style: mediumTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
