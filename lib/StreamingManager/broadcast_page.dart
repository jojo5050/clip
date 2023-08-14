
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import 'app_id.dart';

class BroadCastPage extends StatefulWidget {
  const BroadCastPage({
    Key? key,
    required this.isBroadcaster,
    required this.userName,
    required this.userImage,
    required this.userId,
    this.clientName,
  }) : super(key: key);

  final String userImage;
  final String userId;
  final String userName;
  final bool isBroadcaster;
  final String? clientName;

  @override
  State<BroadCastPage> createState() => _BroadCastPageState();
}

class _BroadCastPageState extends State<BroadCastPage>
    with TickerProviderStateMixin {
  final _users = <int>[];
  bool muted = false;
  late RtcEngine _engine;
  List<RTMMessage> _messages = [];
  int uid = 0;
  List<RtmChannelMember> _members = [];
  final _scrollController = ScrollController();

  CollectionReference streamRef =
  FirebaseFirestore.instance.collection("Streams");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String channelName = "Clip";

  var message;

  var loginEerrorMssg;
  int memberCount = 0;

  String? tokenData;

  String? tokenValue;

  String? agoraRtmToken;

  @override
  void dispose() {
    _users.clear();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _iniAlgoraRtcEngine();

    _createClient();
  }

  Future<void> _iniAlgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    await _engine.enableVideo();

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);

    await _engine.setClientRole(
      widget.isBroadcaster ? ClientRole.Broadcaster : ClientRole.Audience,
    );
    if (widget.isBroadcaster) {
      startStreamAndNotifyServer();
    }

    _addEventHandlers();
    final String? agoraToken = await getToken(channelName, widget.userId);

    await _engine.joinChannelWithUserAccount(agoraToken, channelName, widget.userId);

  }


  final _channelMessageController = TextEditingController();
  bool _isLogin = false;
  bool _isInChannel = false;

  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  AnimationController? _animationController;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(right: 20, left: 20, top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
             IconButton(onPressed: (){
               Navigator.of(context).pop();
             }, icon: Icon(Icons.clear)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      /*Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return StreamViewers(
                          members: _members,
                        );
                      }));*/
                    },
                    child: Container(
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "$memberCount",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                  height: 0,
                  width: 0,
              ),
            ],
          ),
        ),
      )),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: <Widget>[
            _broadcastView(),
            Positioned(
              bottom: 70,
              right: 20,
              child: Container(),
             /* child: Lottie.asset(
                'assets/animations/hearts.json',
                height: 300,
                width: 200,
                controller: _animationController,
              ),*/
            ),
            Positioned(
              bottom: 65,
              // left: 20,
              child: Center(
                child: _buildSendChannelMessage(),
              ),
            ),
            Positioned(
              bottom: 120,
              child: _buildInfoList(),
            )
          ],
        ),
      ),
    );
  }

  // helper function to get list of native users
  List<Widget> _getRenderView() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
      uid: uid,
      channelId: 'Clip',
    )));
    return list;
  }

  // video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedView = views.map<Widget>((view) => Expanded(
        child: Container(
          child: view,
        )));
    return Expanded(child: Row(children: wrappedView.toList()));
  }

  // video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderView();
    switch (views.length) {
      case 1:
        return Center(
          child: Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView([views[0]]),
                SizedBox(
                  height: 10,
                ),
                videoControls(),
              ],
            ),
          ),
        );
      case 2:
        return Center(
          child: Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView([views[0]]),
                _expandedVideoView([views[1]]),
              ],
            ),
          ),
        );

      case 3:
        return Center(
          child: Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView(views.sublist(0, 2)),
                _expandedVideoView(views.sublist(0, 2)),
              ],
            ),
          ),
        );
      default:
    }
    return Center(
      child: Container(),
    );
  }

  void _addEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        //  _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'Stream started';
        //  _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        //  _infoStrings.add('Stream ended');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'new user Joined: $uid';
        //  _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'user is Offline: $uid';
        //  _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        //  _infoStrings.add(info);
      });
    }));
  }

  void endCall() {
    Navigator.pop(context);
    endStream();
  }

  void muteMic() {
    setState(() {
      muted = !muted;
    });
  }

  void switchCam() {
    _engine.switchCamera();
  }

  Widget videoControls() {
    if (widget.isBroadcaster) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                muteMic();
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(
                  muted ? Icons.mic_off : Icons.mic,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 25,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                endCall();
                //  showEndStreamDialoge();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(
                    Icons.call_end,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                switchCam();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            endCall();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Icon(
                Icons.call_end,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 5.h,
            width: 65.w,
            child: TextFormField(
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.justify,
              textAlignVertical: TextAlignVertical.bottom,
              showCursor: true,
              cursorColor: Colors.black,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _channelMessageController,
              decoration: InputDecoration(
                hintText: 'Comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          InkWell(
            onTap: _toggleSendChannelMessage,
            child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 25,
                )),
          ),
          SizedBox(
            width: 2.w,
          ),
          InkWell(
            onTap: () {
              _toggleSendChannelMessage(isLike: true);
              _animationController!.value = 0.0;
              _animationController!.forward();
            },
            child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                /*child: Icon(
                  Icons.heart_broken_sharp,
                  color: Colors.red,
                  size: 25,
                )*/
                child: Image.asset(
                  "assets/images/heart_fill.png",
                  color: Colors.red,
                  fit: BoxFit.cover,
                )),
          )
        ],
      ),
    );
  }

  void _toggleSendChannelMessage({bool isLike = false}) async {
    String text = isLike
        ? "${widget.userName} likes post"
        : _channelMessageController.text;
    if (text.isEmpty) {
      print('Please input text to send.');
      return;
    }
    try {
      String message = jsonEncode({"avatar": widget.userImage, "text": text});
      await _channel?.sendMessage(AgoraRtmMessage.fromText(message));
      // _log(message: RTMMessage(message: text));
      _log(
          message: RTMMessage(
            message: jsonDecode(message)["text"],
            sender: widget.userName,
            avatar: widget.userImage,
            isChat: true,
          ));
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _channelMessageController.clear();
    } catch (errorCode) {
      print('Unable to send message: ' + errorCode.toString());
    }
  }

  void _log({RTMMessage? message}) {
    setState(() {
      _messages.add(message ?? RTMMessage());
    });
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(appID);
    _client?.onMessageReceived = (RtmMessage message, String peerId) {
      //  _logPeer(message.text);
      print("printing message:${message.text}");
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client?.logout();
        print('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };

    final String? agoraRtmToken = await getRtmToken(widget.userName);

    String id = widget.userName;
    try {
      await _client?.login(
        agoraRtmToken,
        id,
      );
      print('Login success: ' + id);

      setState(() {
        _isLogin = true;
      });
    } catch (errorCode) {
      print('Login error: ' + errorCode.toString());
    }
    _toggleJoinChannel();
  }

 Future<String> getRtmToken(String userId) async {
  // String id = widget.userId;
    final String rtmServerUrl
    = 'https://rtm-server-8xza.vercel.app/rtm_token?userID=$userId';
    final response = await http.get(Uri.parse(rtmServerUrl));

    if (response.statusCode == 200) {
      final  rtmTokenData = response.body;
      print("print here again firsttttttttttttttttttttttt asssssssss $rtmTokenData");
      return rtmTokenData;
    } else {
      throw Exception('Failed to generate Agora token');
    }


  }

  void _toggleJoinChannel() async {
    try {
      _channel = await _createChannel(
        channelName,
      );
      await _channel?.join();
      print('Join channel success.');

      setState(() {
        _isInChannel = true;
      });
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);

    if (channel != null) {
      channel.onMemberCountUpdated = (count) async {
        List<AgoraRtmMember> members = await channel.getMembers();
        setState(() {
          memberCount = count;
          _members = members;
        });
      };
      channel.onMemberJoined = (AgoraRtmMember member) {
        /*_log(
            message:
            RTMMessage(message: "${member.userId} joined", isChat: false));
*/
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        _log(
            message: RTMMessage(
              message: "${member.userId} left",
              isChat: false,
            ));
      };
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
        print(message.text);
        if (message.text.contains("likes post")) {
          _animationController!.value = 0.0;
          _animationController!.forward();
        }
        _log(
            message: RTMMessage(
              message: jsonDecode(message.text)["text"],
              sender: member.userId,
              avatar: jsonDecode(message.text)["avatar"],
              isChat: true,
            ));
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      };
    }
    return channel;
  }

  Widget _buildInfoList() {
    return Container(
        height: MediaQuery.of(context).size.height / 4.5,
        width: MediaQuery.of(context).size.width,
        child: _messages.length > 0
            ? ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, i) {
            RTMMessage message = _messages[i];
            return Container(
              child: ListTile(
                title: Align(
                  // alignment: widget.isBroadcaster
                  //     ? Alignment.bottomLeft
                  //     : Alignment.bottomRight,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15.sp,
                        backgroundImage:
                        NetworkImage(message.avatar ?? ""),
                      ),
                      message.isChat!
                          ? Text(message.sender!)
                          : SizedBox(),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 0.5.h),
                        child: Text(
                          message.message ?? "",
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: _messages.length,
        )
            : Container());
  }

  void endStream() async {
    String broadCasterID = _firebaseAuth.currentUser!.uid;
    _channel!.leave();
    _client!.logout();
    _client!.release();
   // _channel!.close();
    _engine.leaveChannel();

    notifyServer();
  /*  try {
      FirebaseFirestore.instance
          .collection('Streams')
          .doc(broadCasterID)
          .delete();
    } catch (e) {}*/
  }

  void desplayMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          "$message",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  Future<void> startStreamAndNotifyServer() async {
    String broadCasterID = _firebaseAuth.currentUser!.uid;
    streamRef.doc(broadCasterID).set({
     "Status": "Started",
     "hostId": broadCasterID,
     "StreamToken": appID
   });
  }

  void displayLoginErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          "$loginEerrorMssg",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

   Future<String?> getToken(String channelName, String uid) async {

      final String tokenServerUrl = 'https://token-server-8a6vsn6kd-jojo5050.vercel.app/access_token?channelName=$channelName&role=subscriber&uid=$uid';
      final response = await http.get(Uri.parse(tokenServerUrl));

      if (response.statusCode == 200) {
       final  tokenData = response.body;
         print("print here again firsttttttttttttttttttttttt asssssssss $tokenData");
         return tokenData;
      } else {
        throw Exception('Failed to generate Agora token');
      }

   }

  Future<void> notifyServer() async {
    String broadCasterID = _firebaseAuth.currentUser!.uid;
    streamRef.doc(broadCasterID).set({
      "Status": "Stopped",
      "hostId": broadCasterID,
      "StreamToken": appID
    });

  }

}

class RTMMessage {
  String? message;
  String? sender;
  String? avatar;
  bool? isChat;

  RTMMessage({this.message, this.sender, this.isChat, this.avatar});
}
