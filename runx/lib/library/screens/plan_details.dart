// System Packages
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/plan.dart';
import 'package:runx/caching/models/plan_exercise.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/api.dart';

// Widgets
import 'package:runx/library/widgets/timer_buttons.dart';

// Screens
import 'package:runx/library/screens/plan_exercise_details.dart';

class PlanDetails extends StatefulWidget {
  final Plan plan;
  const PlanDetails(BuildContext context, {Key? key, required this.plan})
      : super(key: key);

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = false;
  bool isStopped = false;
  bool? canLeave;

  @override
  void initState() {
    isStopped = false;
    canLeave = true;
    super.initState();
    reset();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void reset() {
    setState(() {
      isStopped = false;
      canLeave = true;
      duration = const Duration();
    });
  }

  void startTimer() {
    setState(() {
      isStopped = true;
      canLeave = false;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void stopTimer({bool resets = true}) {
    setState(() {
      isStopped = true;
      timer?.cancel();
    });
    if (resets) {
      reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plano: " + widget.plan.name),
      ),
      body: buildPlanExercises(context),
    );
  }

  Widget buildPlanExercises(BuildContext context) {
    return Scaffold(body: buildList(context));
  }

  Widget buildList(BuildContext context) => Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("PlanExercises").listenable(),
          builder: (context, box, _) {
            final exercises = box.values.toList().cast<PlanExercise>();
            exercises.removeWhere(
                (element) => element.belongsToProgramID != widget.plan.planID);
            return buildContent(exercises);
          },
        ),
      );

  Widget buildContent(List<PlanExercise> exercises) {
    if (exercises.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
              'N??o conseguimos encontrar exercicios!\n\n\n Verifique a sua conex??o ?? internet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24)),
        ),
      );
    }
    return WillPopScope(
      onWillPop: (canLeave == false) ? _onWillPop : leavePage,
      child: Column(
        children: [
          const SizedBox(height: 12),
          buildTime(),
          const SizedBox(height: 24),
          buildButtons(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: exercises.length,
              itemBuilder: (BuildContext context, int index) {
                final exercise = exercises[index];
                return buildTransaction(context, exercise);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransaction(BuildContext context, PlanExercise exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlanExerciseDetails(
              context,
              exercise: exercise,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 1,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                height: 125,
                width: 110,
                child: CachedNetworkImage(
                  imageUrl: exercise.thumbnailPath,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/exercise_icon.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: themeColorLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                        "Dificuldade: " + exercise.difficulty,
                        style: const TextStyle(
                          fontSize: 13,
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
                        "Foco: " + exercise.targetMuscle,
                        style: const TextStyle(
                          fontSize: 13,
                          letterSpacing: .3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.repeat_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "S??ries: " + exercise.numSets,
                        style: const TextStyle(
                          fontSize: 13,
                          letterSpacing: .3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.repeat_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Repeti????es: " + exercise.numReps,
                        style: const TextStyle(
                          fontSize: 13,
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

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'Horas'),
      buildSeparatorCard(separator: '-', header: ""),
      buildTimeCard(time: minutes, header: 'Minutos'),
      buildSeparatorCard(separator: '-', header: ""),
      buildTimeCard(time: seconds, header: 'Segundos'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          Text(header, style: const TextStyle(color: Colors.black54)),
        ],
      );

  Widget buildSeparatorCard(
          {required String separator, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Text(
              separator,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          Text(header, style: const TextStyle(color: Colors.black54)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(
            text: 'Pausar',
            color: Colors.black,
            backgroundColor: const Color.fromARGB(255, 223, 221, 221),
            onClicked: () {
              if (isRunning) {
                stopTimer(resets: false);
              }
            },
          ),
          const SizedBox(width: 12),
          ButtonWidget(
            text: "Completar Treino",
            color: Colors.white,
            backgroundColor: Colors.green,
            onClicked: () {
              APICaller()
                  .finishWorkout(
                      email: FirebaseAuth.instance.currentUser!.email,
                      progID: widget.plan.planID,
                      timeTaken: duration.toString())
                  .then((result) {
                if (result != "ERROR" && json.decode(result)["code"] == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Completou o treino! \nOs dados foram guardados.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "N??o conseguimos guardar os dados desta sess??o.\nVerifique a sua conex??o ou tente mais tarde.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }
              });
              stopTimer();
            },
          ),
        ],
      );
    } else {
      if (isStopped == true) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              text: "Continuar",
              color: Colors.black,
              backgroundColor: const Color.fromARGB(255, 223, 221, 221),
              onClicked: () {
                startTimer();
              },
            ),
            const SizedBox(width: 12),
            ButtonWidget(
              text: "Cancelar Treino",
              color: Colors.white,
              backgroundColor: const Color.fromARGB(255, 243, 77, 66),
              onClicked: () {
                stopTimer();
              },
            ),
          ],
        );
      } else {
        return ButtonWidget(
          text: "Come??ar Treino",
          color: Colors.black,
          backgroundColor: Colors.white,
          onClicked: () {
            startTimer();
          },
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Prestes a sair',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Deseja sair antes de acabar o seu treino?'),
            actions: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () => Navigator.of(context).pop(false),
                        child:
                            const Text('N??o', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Sair sem acabar',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          APICaller()
                              .finishWorkout(
                                  email:
                                      FirebaseAuth.instance.currentUser!.email,
                                  progID: widget.plan.planID,
                                  timeTaken: duration.toString())
                              .then((result) {
                            if (result != "ERROR" &&
                                json.decode(result)["code"] == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Completou o treino! \nOs dados foram guardados.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "N??o conseguimos guardar os dados desta sess??o.\nVerifique a sua conex??o ou tente mais tarde.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }
                          });
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Acabar e sair',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> leavePage() async {
    Navigator.of(context).pop(true);
    return true;
  }
}
