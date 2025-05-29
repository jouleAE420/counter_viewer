import 'package:counter_viewer/widgets/contador_widget.dart';
import 'package:counter_viewer/widgets/moves_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contador"),
      ),
      body: const InfoView(),
    );
  }
}

class InfoView extends StatelessWidget {
  const InfoView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CounterViewWidget(),
        Expanded(
          child: MovesList(),
        )
      ]),
    );
  }
}

