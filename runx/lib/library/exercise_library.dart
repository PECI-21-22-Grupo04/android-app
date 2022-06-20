// System Packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/free_exercise.dart';

// Logic
import 'package:runx/preferences/colors.dart';

// Screens
import 'package:runx/library/screens/exercise_details.dart';

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
            final exercises = box.values.toList().cast<FreeExercise>();
            exercises.sort((a, b) => a.name.compareTo(b.name));
            return buildContent(exercises);
          },
        ),
      );

  Widget buildContent(List<FreeExercise> exercises) {
    if (exercises.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
              'Não conseguimos encontrar exercicios!\n\n\n Verifique a sua conexão à internet',
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
              final exercise = exercises[index];
              return buildTransaction(context, exercise);
            },
          ),
        ),
      ],
    );
  }

  Widget buildTransaction(BuildContext context, FreeExercise exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExerciseDetails(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
