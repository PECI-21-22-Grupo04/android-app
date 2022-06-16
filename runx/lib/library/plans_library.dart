// System Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:runx/library/widgets/free_plan.dart';
import 'package:runx/library/widgets/premium_plan.dart';

class PlanLibrary extends StatefulWidget {
  final String accountState;
  const PlanLibrary(this.accountState, {Key? key}) : super(key: key);

  @override
  State<PlanLibrary> createState() => _PlanLibraryState();
}

class _PlanLibraryState extends State<PlanLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Biblioteca de Planos'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Planos Grátis",
                ),
                Tab(
                  text: "Planos Premium",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildFreePlans(context),
              buildPremiumPlans(context, widget.accountState),
            ],
          ),
        ),
      ),
    );
  }
}
