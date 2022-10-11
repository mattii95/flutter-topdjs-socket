import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:top_dj_app/models/dj_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DjModel> djs = [
    DjModel(id: '1', name: 'Armin Van Buuren', votes: 5),
    DjModel(id: '2', name: 'David Guetta', votes: 3),
    DjModel(id: '3', name: 'Martin Garrix', votes: 4),
    DjModel(id: '4', name: 'Miss Monique', votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Djs'),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: djs.length,
        itemBuilder: (context, index) => _djTile(djs[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewDj,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _djTile(DjModel dj) {
    return Dismissible(
      key: Key(dj.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction $direction');
        print('id ${dj.id}');
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 16),
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(dj.name.substring(0, 2)),
        ),
        title: Text(dj.name),
        trailing: Text(
          '${dj.votes}',
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          print(dj.name);
        },
      ),
    );
  }

  addNewDj() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Dj:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => addDjToList(textController.text),
                elevation: 5,
                textColor: Colors.red,
                child: const Text('Add'),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('New Dj:'),
        content: CupertinoTextField(controller: textController),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add'),
            onPressed: () => addDjToList(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void addDjToList(String name) {
    if (name.length > 1) {
      djs.add(DjModel(id: DateTime.now.toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
