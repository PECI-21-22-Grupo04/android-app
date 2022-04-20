// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/exercise/video_play.dart';
import 'package:runx/preferences/colors.dart';

import '../preferences/theme_model.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return const Scaffold(
          body: VideoPlayAsset(video: 'assets/videos/sample.mp4'));
    });
  }
}
