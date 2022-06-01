// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/caching/sharedpref_helper.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';

// Widgets
import 'package:runx/instructor/widgets/instructor_widgets.dart';

class InstructorPage extends StatefulWidget {
  final InstructorProfile instProfile;

  const InstructorPage(this.instProfile, {Key? key}) : super(key: key);

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> {
  String _accountState = "";

  @override
  void initState() {
    getAccountStatus().then((result) => setState(() {
          _accountState = result!;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.instProfile.getFullName()),
        centerTitle: true,
        elevation: 2,
      ),
      body: Stack(
        children: <Widget>[
          buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 9.5),
                  buildProfileImage(),
                  buildFullName(widget.instProfile.getFullName()),
                  buildStatus(context, widget.instProfile.getRegisterDate()),
                  buildStatContainer(
                      widget.instProfile.getMaxClients(),
                      widget.instProfile.getCurrentClients(),
                      widget.instProfile.getAverageRating()),
                  buildBio(context, widget.instProfile.getAboutMe()),
                  Container(
                    width: screenSize.width / 1.3,
                    height: 2.0,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 20.0),
                  buildGetInTouch(context, widget.instProfile.getFullName()),
                  buildButtons(
                    context,
                    _accountState,
                    widget.instProfile.getEmail(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> getAccountStatus() async {
    return await SharedPreferencesHelper().getStringValuesSF("accountStatus");
  }
}
