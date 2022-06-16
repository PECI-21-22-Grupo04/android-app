// System Packages
import 'package:flutter/material.dart';

// Models
import 'package:runx/caching/models/plan_exercise.dart';

// Logic
import 'package:runx/library/logic/video_play.dart';

class PlanExerciseDetails extends StatefulWidget {
  final PlanExercise exercise;

  const PlanExerciseDetails(BuildContext context,
      {Key? key, required this.exercise})
      : super(key: key);

  @override
  State<PlanExerciseDetails> createState() => _PlanExerciseDetailsState();
}

class _PlanExerciseDetailsState extends State<PlanExerciseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.name)),
      body: buildExerciseDetails(widget.exercise),
    );
  }

  Widget buildExerciseDetails(PlanExercise exercise) {
    Size screenSize = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: (exercise.videoPath == "")
                    ? const Text("Nenhum video disponivel")
                    : VideoPlayNetwork(video: exercise.videoPath),
                height: screenSize.height / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                height: screenSize.height / 13,
                color: const Color.fromARGB(255, 244, 240, 240),
                child: const Text(
                  "Grupo Muscular: ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 90, 19, 233),
                  ),
                ),
              ),
              LimitedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    exercise.targetMuscle,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                height: screenSize.height / 13,
                color: const Color.fromARGB(255, 244, 240, 240),
                child: const Text(
                  "Nível de Dificuldade: ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 90, 19, 233),
                  ),
                ),
              ),
              LimitedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    exercise.difficulty,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                height: screenSize.height / 13,
                color: const Color.fromARGB(255, 244, 240, 240),
                child: const Text(
                  "Indicado Para: ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 90, 19, 233),
                  ),
                ),
              ),
              LimitedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    exercise.forPathology,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                height: screenSize.height / 13,
                color: const Color.fromARGB(255, 244, 240, 240),
                child: const Text(
                  "Como Realizar: ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 90, 19, 233),
                  ),
                ),
              ),
              LimitedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    exercise.description,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
