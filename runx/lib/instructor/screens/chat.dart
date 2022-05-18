// System Packages
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

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

  void addMessage(types.Message message) {
    setState(() {
      messageList.insert(0, message);
    });
  }

  void handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Fotografia'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Ficheiro'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      addMessage(message);
    }
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      addMessage(message);
    }
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
            onAttachmentPressed: handleAtachmentPressed,
            onMessageTap: handleMessageTap,
            onPreviewDataFetched: handlePreviewDataFetched,
            onSendPressed: handleSendPressed,
            user: user,
          ),
        ),
      );
    });
  }
}
