// System Packages
import 'package:flutter/material.dart';
import 'package:runx/presentation/side_nav.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
        centerTitle: true,
        toolbarHeight: 40,
        leading: IconButton(
          iconSize: 25.0,
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SideNav()),
            );
          },
        ),
      ),
    );
  }
}
