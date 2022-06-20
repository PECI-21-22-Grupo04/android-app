// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/physical_data.dart';

// Logic
import 'package:runx/preferences/colors.dart';

// Widgets
import 'package:runx/history/physical/widgets/info_widgets.dart';

// Screens
import 'package:runx/history/physical/screens/add_info.dart';

class PhysicalHistory extends StatefulWidget {
  const PhysicalHistory({Key? key}) : super(key: key);

  @override
  _PhysicalHistoryState createState() => _PhysicalHistoryState();
}

class _PhysicalHistoryState extends State<PhysicalHistory> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Histórico Físico')),
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("PhysicalHistory").listenable(),
          builder: (context, box, _) {
            final physicalData = box.values.toList().cast<PhysicalData>();
            physicalData.sort(
              (a, b) => b.dataID.compareTo(a.dataID),
            );
            return buildContent(physicalData);
          },
        ),
      );

  Widget buildContent(List<PhysicalData> physicalData) {
    if (physicalData.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
            'Não conseguimos encontrar os seus dados fisicos',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "   Última Medição: " +
                          physicalData.elementAt(0).measuredDate.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: getWidgetWeight(physicalData),
                  ),
                  Expanded(
                    child: getWidgetIMC(physicalData),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green)),
          child: const Text(
            'Atualizar Dados',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddInfoHealth(latestData: physicalData.elementAt(0))),
            );
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: physicalData.length,
            itemBuilder: (BuildContext context, int index) {
              final log = physicalData[index];
              return buildInstructorList(context, log);
            },
          ),
        ),
      ],
    );
  }

  Widget buildInstructorList(BuildContext context, PhysicalData physicalData) {
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
                    physicalData.measuredDate,
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
                        Icons.man_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Altura: " + physicalData.height.toString(),
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
                        Icons.monitor_weight_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Peso: " + physicalData.weight.toString(),
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
                        "IMC: " + physicalData.bmi.toString(),
                        style: const TextStyle(
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
                        Icons.show_chart_rounded,
                        color: themeColorLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Nível Físico: " + physicalData.fitness,
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
