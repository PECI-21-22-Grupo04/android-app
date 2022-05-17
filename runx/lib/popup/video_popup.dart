import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runx/exercise/video_play.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

class VideoPopup extends StatefulWidget {
  const VideoPopup({Key? key}) : super(key: key);

  @override
  State<VideoPopup> createState() => _VideoPopupState();
}

class _VideoPopupState extends State<VideoPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Open the popup window',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAlertBox();
        },
        tooltip: 'Open Popup',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Consumer(
                builder: (context, ThemeModel themeNotifier, child) {
              return Dialog(
                  insetPadding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Expanded(
                        child:
                            VideoPlayAsset(video: 'assets/videos/sample.mp4'),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height / 2 - 20,
                          color: themeNotifier.isDark
                              ? themeSecondaryDark
                              : themeSecondaryLight)
                    ],
                  ));
            });
          });
        });
  }
}
