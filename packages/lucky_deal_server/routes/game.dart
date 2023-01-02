import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:logging/logging.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';

import '../ws_handlers/on_connect.dart';
import '../ws_handlers/registry.dart';

final logger = Logger('game');

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      onConnectHandler(channel);
      channel.stream.map((event) => WsDto.from(event as String)).listen(
            (packet) {
              if (!packetHandlers.containsKey(packet.event)) {
                throw UnsupportedError(
                  'Unsupported packet type: ${packet.event}',
                );
              }
              packetHandlers[packet.event]!(channel, packet.data);
            },
            onDone: () => logger.info('disconnected'),
            onError: (Object e, StackTrace s) {
              logger.warning('Error', e, s);
              channel.sink.addError(e, s);
            },
          );
    },
  );

  return handler(context);
}
