// System Packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';

// Screens
import 'package:runx/instructor/screens/associate_instructor.dart';

class InstructorsList extends StatefulWidget {
  const InstructorsList({Key? key}) : super(key: key);

  @override
  _InstructorsListState createState() => _InstructorsListState();
}

class _InstructorsListState extends State<InstructorsList> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("InstructorProfile").listenable(),
          builder: (context, box, _) {
            final availIns = box.values.toList().cast<InstructorProfile>();
            return buildContent(availIns);
          },
        ),
      );

  Widget buildContent(List<InstructorProfile> availIns) {
    if (availIns.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
            'Não conseguimos encontrar instrutores disponiveis!\n\n\n Verifique a sua conexão à internet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: availIns.length,
            itemBuilder: (BuildContext context, int index) {
              final inst = availIns[index];
              return buildInstructorList(context, inst);
            },
          ),
        ),
      ],
    );
  }

  Widget buildInstructorList(
      BuildContext context, InstructorProfile instProfile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: SizedBox(
                height: 125,
                width: 110,
                child: CachedNetworkImage(
                  imageUrl: instProfile.imagePath,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/profile_icon.png'),
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  instProfile.firstName + " " + instProfile.lastName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            subtitle: Center(
              child: Text(
                instProfile.getAverageRating(),
                style: const TextStyle(
                    height: 2, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            trailing: Text(
              "Vagas\n" +
                  instProfile.getAvailableSpotsLeft().toString() +
                  "/" +
                  instProfile.maxClients,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(255, 77, 212, 44),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AssociateInstructor(instProfile),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
