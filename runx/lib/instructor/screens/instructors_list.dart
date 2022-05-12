// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';

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
          child: Text('Não conseguimos encontrar instrutores disponiveis!',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
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
    const color = Colors.green;
    return Card(
      child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          title: Text(
            instProfile.firstName +
                " " +
                instProfile.lastName +
                "\n" +
                instProfile.email,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text("Rating Médio: " + instProfile.averageRating),
          trailing: Text(
            instProfile.getAvailableSpotsLeft().toString(),
            style: const TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          )),
    );
  }
}
