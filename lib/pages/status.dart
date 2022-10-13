import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dj_app/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          socketService.socket.emit('message', {
            'nombre': 'Matías',
            'edad': 26,
            'profesion': ['Web developer', 'Flutter developer']
          });
        },
      ),
    );
  }
}
