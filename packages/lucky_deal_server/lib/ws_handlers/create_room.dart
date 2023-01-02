import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:hashids2/hashids2.dart';
import 'package:lucky_deal_server/providers/providers.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:redis/redis.dart';

Future<void> createRoomHandler(
  WebSocketChannel channel,
  RequestContext context,
  PacketData data,
) async {
  final roomId = HashIds().encodeInt(DateTime.now().millisecondsSinceEpoch);
  final cmdS = await context.read<CommandGenerator>()();
  final cmdP = await context.read<CommandGenerator>()();
  final pubSub = PubSub(cmdS)..subscribe([roomId]);
  pubSub.getStream().handleError(print).listen((event) {
    final msg = event as List<dynamic>;
    final kind = msg[0];
    switch (kind) {
      case 'subscribe':
        final roomInfo = RoomInfoPacket(
          roomId: roomId,
          maxMembers: 2,
          memberIds: [(data as CreateRoomPacket).sid],
        ).encode();
        cmdP.send_object(['SET', roomId, roomInfo]);
        cmdP.send_object(['PUBLISH', roomId, roomInfo]);
        break;
      case 'message':
        channel.sink.add(
          WsDto(
            PacketType.roomInfo,
            RoomInfoPacket.from(msg[2] as String),
          ).encode(),
        );
        break;
      default:
    }
  });
}
