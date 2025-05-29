import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CounterViewWidget extends StatefulWidget {
  const CounterViewWidget({super.key});

  @override
  State<CounterViewWidget> createState() => _CounterViewWidgetState();
}

class _CounterViewWidgetState extends State<CounterViewWidget> {
  String contador = "";

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("counterRapida");
    ref.onValue.listen((DatabaseEvent event) {
      _refresh(event.snapshot.value.toString());
    });

    super.initState();
  }

  _refresh(String value) {
    contador = value;

    setState(() {});
  }

  String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeIn(
                  child: Text(
                    formatNumber(int.parse(contador)),
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.copyWith(fontSize: 50),
                  ),
                ),
                const Text("CONTEO\nTOTAL",
                    textAlign: TextAlign.center, style: textStyle)
              ],
            ),
            const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SetToZeroButton(),
                  OnOffButton(),
                ])
          ],
        ),
      ),
    );
  }
}

class SetToZeroButton extends StatelessWidget {
  const SetToZeroButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ElevatedButton.icon(
        onPressed: _setToZeroCount,
        label: const Text("Reset Count"),
        icon: const Icon(Icons.restore),
      ),
    );
  }

  _setToZeroCount() {
    DatabaseReference refCounter =
        FirebaseDatabase.instance.ref("counterRapida");
    DatabaseReference refCounterList = FirebaseDatabase.instance.ref("moves");
    refCounter.set(0);
    refCounterList.set({});
  }
}

class OnOffButton extends StatefulWidget {
  const OnOffButton({
    super.key,
  });

  @override
  State<OnOffButton> createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton> {
  bool state = true;
  DatabaseReference ref = FirebaseDatabase.instance.ref("estado");

  @override
  void initState() {
    ref.onValue.listen((DatabaseEvent event) {
      final valueString = event.snapshot.value.toString();
      var state = false;
      if (valueString == "true") {
        state = true;
      }
      _refresh(state);
    });
    super.initState();
  }

  _refresh(bool value) {
    state = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ElevatedButton.icon(
        onPressed: _changeState,
        label: Text(state == true ? "Pausar Barrera" : "Encender Barrera"),
        icon: Icon(state == true ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  _changeState() {
    ref.child("").set(!state);
  }
}
