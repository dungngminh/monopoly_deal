import 'package:lucky_deal_shared/src/types/packet/packet.dart';

enum PacketType {
  createRoom(EmptyPacket.from),
  roomCreated(RoomCreated.from),
  memberJoined(MemberJoined.from),
  membersUpdated(MembersUpdated.from),
  joinRoom(JoinRoom.from),
  joinedRoom(JoinedRoom.from),
  error(ErrorPacket.from),
  startGame(EmptyPacket.from),
  gameStarted(EmptyPacket.from),
  revealCard(RevealCard.from),
  cardRevealed(CardRevealed.from),
  memberLeft(MemberLeft.from),
  connected(Connected.from),
  ackConnection(EmptyPacket.from);

  const PacketType(this.decode);

  final PacketData Function(List<String> values) decode;
}
