import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MovesList extends StatefulWidget {
  const MovesList({
    super.key,
  });

  @override
  State<MovesList> createState() => _MovesListState();
}

class _MovesListState extends State<MovesList> {
  List<Map<String, String>> movesList = [];
  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("moves");
    ref.onValue.listen((DatabaseEvent event) {
      _refresh(event.snapshot.value.toString());
    });
    super.initState();
  }

  _refresh(String value) {
    List<String> items = value.split(", ");
    if (items[0]=="null") {
      movesList = [];
      setState(() {});
      return;
    }
    movesList = items.map((item) {
      List<String> parts = item.split(": ")[1].split(" | ");
      String value = parts[2].replaceAll("{", "").replaceAll("}", "");
      return {
        "date": parts[0],
        "time": parts[1],
        "value": value,
      };
    }).toList();
    movesList.sort(
        (a, b) => int.parse(b["value"]!).compareTo(int.parse(a["value"]!)));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => FadeInRight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 130,
            child: Card(
              elevation: index.toDouble(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movesList[index]["value"] ?? " ",
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          movesList[index]["time"] ?? " ",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          movesList[index]["date"] ?? " ",
                        ),
                        const Icon(
                          Icons.local_parking,
                          size: 40,
                        )
                      ],
                    )
                  ],
                ),
              ),
              // title: Text(
              //   movesList[index]["value"] ?? " ",
              //   style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              // ),
              // subtitle: Text("HOLA MUNDO"),
              // tileColor: colors.surface,
            ),
          ),
        ),
      ),
      itemCount: movesList.length,
    );
  }
}
