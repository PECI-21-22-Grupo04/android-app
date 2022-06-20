// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/history_instructor.dart';
import 'package:runx/preferences/colors.dart';

class InstructorHistory extends StatefulWidget {
  const InstructorHistory({Key? key}) : super(key: key);

  @override
  _InstructorHistoryState createState() => _InstructorHistoryState();
}

class _InstructorHistoryState extends State<InstructorHistory> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Histórico de Instrutores')),
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("HistoryInstructor").listenable(),
          builder: (context, box, _) {
            final availIns = box.values.toList().cast<HistoryInstructor>();
            return buildContent(availIns);
          },
        ),
      );

  Widget buildContent(List<HistoryInstructor> availIns) {
    if (availIns.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
            'O seu histórico de instrutores está vazio!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 25),
        InkWell(
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 220, 210, 210).withOpacity(.5),
                    const Color.fromARGB(255, 220, 210, 210).withOpacity(.5),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (availIns.length == 1)
                        ? "1 instrutor no total"
                        : availIns.length.toString() + " instrutores no total",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      BuildContext context, HistoryInstructor instProfile) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 1,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    instProfile.firstName + " " + instProfile.lastName,
                    style: const TextStyle(
                      color: themeColorLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.info_outline_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Assinou:   " + instProfile.signedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: .3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.info_outline_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      (instProfile.canceledDate == "")
                          ? const Text(
                              "Atualmente Associado",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: .3,
                                color: Colors.green,
                              ),
                            )
                          : Text(
                              "Cancelou: " + instProfile.canceledDate,
                              style: const TextStyle(
                                fontSize: 16,
                                letterSpacing: .3,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
