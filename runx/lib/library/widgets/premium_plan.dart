// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/plan.dart';

// Logic
import 'package:runx/preferences/colors.dart';

/*-------------------------------*/
/* WIDGETS FOR PREMIUM PLANS TAB */
/*-------------------------------*/
Widget buildPremiumPlans(BuildContext context) {
  return Scaffold(body: buildPremiumList(context));
}

Widget buildPremiumList(BuildContext context) => Scaffold(
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box("PremiumPlans").listenable(),
        builder: (context, box, _) {
          final plans = box.values.toList().cast<Plan>();
          plans.sort((a, b) => a.name.compareTo(b.name));
          return buildPremiumContent(plans);
        },
      ),
    );

Widget buildPremiumContent(List<Plan> plans) {
  if (plans.isEmpty) {
    return const Center(
      child: Center(
        child: Text(
            'Não conseguimos encontrar planos premium!\n\n\n Verifique a sua conexão à internet\nou\nPeça um plano ao seu instrutor',
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
          itemCount: plans.length,
          itemBuilder: (BuildContext context, int index) {
            final plan = plans[index];
            return buildPremium(context, plan);
          },
        ),
      ),
    ],
  );
}

Widget buildPremium(BuildContext context, Plan plan) {
  return GestureDetector(
    onTap: () {
      /*
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExerciseDetails(
            context,
            plan: plan,
          ),
        ),
      );
      */
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
                    image: AssetImage('assets/images/program_icon.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  plan.name,
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
                      plan.description,
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
                      plan.description,
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
