// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/history_workout.dart';

// Logic
import 'package:runx/preferences/colors.dart';

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({Key? key}) : super(key: key);

  @override
  _WorkoutHistoryState createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Histórico de Treino')),
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("WorkoutHistory").listenable(),
          builder: (context, box, _) {
            final workoutLog = box.values.toList().cast<HistoryWorkout>();
            return buildContent(workoutLog);
          },
        ),
      );

  Widget buildContent(List<HistoryWorkout> workoutLog) {
    if (workoutLog.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
            'O seu histórico de treino está vazio!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23),
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
                    workoutLog.length.toString() + " treinos realizados",
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
            itemCount: workoutLog.length,
            itemBuilder: (BuildContext context, int index) {
              final log = workoutLog[index];
              return buildInstructorList(context, log);
            },
          ),
        ),
      ],
    );
  }

  Widget buildInstructorList(BuildContext context, HistoryWorkout workoutLog) {
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
                    workoutLog.pName,
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
                        "Realizado: " + workoutLog.doneDate,
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
                      Text(
                        "Demorou: " + workoutLog.timeTaken,
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
                      (workoutLog.heartRate != "0")
                          ? Text(
                              "Calorias Queimadas: " + workoutLog.caloriesBurnt,
                              style: const TextStyle(
                                fontSize: 16,
                                letterSpacing: .3,
                              ),
                            )
                          : const Text(
                              "Calorias Queimadas: -",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: .3,
                              ),
                            )
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
                      (workoutLog.heartRate != "0")
                          ? Text(
                              "Media Cardíaca: " + workoutLog.heartRate,
                              style: const TextStyle(
                                fontSize: 16,
                                letterSpacing: .3,
                              ),
                            )
                          : const Text(
                              "Media Cardíaca: -",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: .3,
                              ),
                            )
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
