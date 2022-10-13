import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:top_dj_app/models/dj_model.dart';
import 'package:top_dj_app/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DjModel> djs = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-djs', _handleActiveDjs);

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-djs');
    super.dispose();
  }

  _handleActiveDjs(dynamic payload) {
    djs = (payload as List).map((dj) => DjModel.fromMap(dj)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top Djs',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: djs.length,
              itemBuilder: (context, index) => _djTile(djs[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewDj,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _djTile(DjModel dj) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(dj.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('delete-dj', {'id': dj.id}),
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
        onTap: () => socketService.socket.emit('vote-dj', {'id': dj.id}),
      ),
    );
  }

  addNewDj() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
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
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (name.length > 1) {
      socketService.socket.emit('add-dj', {'name': name});
    }

    Navigator.pop(context);
  }

  // Mostrar grafica
  Widget _showGraph() {
    Map<String, double> dataMap = {};

    for (var dj in djs) {
      dataMap.addAll({dj.name: dj.votes.toDouble()});
    }

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    );
  }
}
