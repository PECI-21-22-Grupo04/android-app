// System Packages
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:runx/caching/models/instructor_profile.dart';
import 'package:uuid/uuid.dart';

// Models
import 'package:runx/preferences/theme_model.dart';

// Logic
import 'package:runx/preferences/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(InstructorProfile instructor, {Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<types.Message> messageList = [];

  final user =
      types.User(id: FirebaseAuth.instance.currentUser!.uid.toString());

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Chat(
            theme: DefaultChatTheme(
                backgroundColor: themeNotifier.isDark
                    ? themeSecondaryDark
                    : themeSecondaryLight,
                secondaryColor: themePrimaryLight,
                inputBackgroundColor: Colors.transparent,
                inputTextColor: themeNotifier.isDark ? neutral7 : neutral0),
            messages: messageList,
            onMessageTap: handleMessageTap,
            onPreviewDataFetched: handlePreviewDataFetched,
            onSendPressed: handleSendPressed,
            user: user,
          ),
        ),
      );
    });
  }

  void addMessage(types.Message message) {
    setState(() {
      messageList.insert(0, message);
    });
  }

  void handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = messageList.indexWhere((element) => element.id == message.id);
    final updatedMessage =
        messageList[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        messageList[index] = updatedMessage;
      });
    });
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    addMessage(textMessage);
  }

  void loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      messageList = messages;
    });
  }
}
