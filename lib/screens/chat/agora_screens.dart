import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AgoraScreens extends StatefulWidget {
  const AgoraScreens({Key? key, required this.room}) : super(key: key);
  final types.Room room;
  @override
  State<AgoraScreens> createState() => _AgoraScreensState();
}

class _AgoraScreensState extends State<AgoraScreens> {
  late final AgoraClient client;
  // final AgoraClient client = AgoraClient(
  //   agoraConnectionData: AgoraConnectionData(

  //     username: "user",
  //   ),
  // );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
      appId: "8e412651038a453882baa2904995d037",
      channelName: widget.room!.id,
    ));
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora VideoUIKit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
            ),
          ],
        ),
      ),
    );
  }
}
