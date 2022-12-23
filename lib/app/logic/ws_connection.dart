import 'dart:async';

import 'package:monopoly_deal/app/app.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WsConnection {
  final socket = WebSocket(Uri.parse("ws://localhost:3000/game"));
  final wsAdapter = WsAdapter();
  String? sid;

  final _sidStreamController = StreamController<String>.broadcast();

  Stream<ConnectionState> get stateStream =>
      socket.connection.asBroadcastStream();
  Stream<ServerPacket> get messageStream => socket.messages
      .asBroadcastStream()
      .map((event) => wsAdapter.decode(event));
  Stream<String> get sidStream => _sidStreamController.stream;
  final List<Function(String sid)> _pendingRequests = [];

  WsConnection() {
    sidStream.listen((event) {
      sid = event;
      for (var r in _pendingRequests) {
        r(sid!);
      }
    });
    messageStream.listen((event) {
      if (event is ConnectedPacket) {
        _sidStreamController.add(event.sid);
      }
    });
  }

  void createRoom() {
    request(String sid) =>
        socket.send(wsAdapter.encode(CreateRoomPacket(sid: sid)));
    if (sid == null) {
      _pendingRequests.add(request);
      return;
    }
    request(sid!);
  }

  void joinRoom(int roomId) {
    request(String sid) =>
        socket.send(wsAdapter.encode(JoinRoomPacket(sid: sid, roomId: roomId)));
    if (sid == null) {
      _pendingRequests.add(request);
      return;
    }
    request(sid!);
  }
}
