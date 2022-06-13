// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/exercise.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/library/logic/video_play.dart';

class ExerciseLibrary extends StatefulWidget {
  const ExerciseLibrary({Key? key}) : super(key: key);

  @override
  State<ExerciseLibrary> createState() => _ExerciseLibraryState();
}

class _ExerciseLibraryState extends State<ExerciseLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Biblioteca de Exercicios'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Exercicios Base",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildFreeExercises(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFreeExercises(BuildContext context) {
    return Scaffold(body: buildList(context));
  }

  Widget buildList(BuildContext context) => Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("FreeExercises").listenable(),
          builder: (context, box, _) {
            final exercises = box.values.toList().cast<Exercise>();
            exercises.sort((a, b) => a.name.compareTo(b.name));
            return buildContent(exercises);
          },
        ),
      );

  Widget buildContent(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
              'Não conseguimos encontrar exercicios! Verifique a sua conexão à internet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24)),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: exercises.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = exercises[index];
              return buildTransaction(context, transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget buildTransaction(BuildContext context, Exercise exercise) {
    return GestureDetector(
      onTap: () {
        openAlertBox(context, exercise);
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
              child: Container(
                height: 125,
                width: 110,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/exercise_icon.png'),
                        fit: BoxFit.cover)),
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
                        fontSize: 18),
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
                      Text(exercise.difficulty,
                          style:
                              const TextStyle(fontSize: 13, letterSpacing: .3)),
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
                      Text(exercise.targetMuscle,
                          style:
                              const TextStyle(fontSize: 13, letterSpacing: .3)),
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

openAlertBox(BuildContext context, Exercise exercise) {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer(
            builder: (context, ThemeModel themeNotifier, child) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const VideoPlayAsset(
                            video: "assets/videos/sample.mp4"),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent),
                      ),
                    ),
                    Container(
                      width: 600,
                      height: 600,
                      color: themeNotifier.isDark
                          ? themeSecondaryDark
                          : themeSecondaryLight,
                      child: Text("asa"),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
