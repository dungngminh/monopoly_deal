import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  static const roomIdLength = 6;
  String _enteredRoomId = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Scaffold(
              backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.05),
              appBar: AppBar(
                backgroundColor:
                    theme.colorScheme.surfaceTint.withOpacity(0.08),
                leading: IconButton(
                  onPressed: () {
                    wsGateway.close();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.adaptive.arrow_back),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Insets.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Insets.medium),
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Insets.medium,
                          horizontal: Insets.extraLarge,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() => _enteredRoomId = value);
                          },
                          style: theme.textTheme.headline3?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer),
                          textAlign: TextAlign.center,
                          autofocus: true,
                          maxLength: roomIdLength,
                          decoration: const InputDecoration(
                            hintText: 'Enter code',
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: JoinRoomButton(
                        enteredRoomId: _enteredRoomId,
                        enabled: _enteredRoomId.length == roomIdLength,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JoinRoomButton extends StatelessWidget {
  const JoinRoomButton({
    Key? key,
    required this.enabled,
    required this.enteredRoomId,
  }) : super(key: key);

  final String enteredRoomId;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (GameRoomModel.of(context).loading) {
      return const ElevatedButton(
        onPressed: null,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: RepaintBoundary(child: CircularProgressIndicator()),
          ),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: enabled
          ? () {
              wsGateway
                ..connect()
                ..send(
                    (sid) => JoinRoomPacket(sid: sid, roomId: enteredRoomId));
              GameRoomModel.of(context).waitingForNewState();
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
      ).copyWith(
        elevation: ButtonStyleButton.allOrNull(0.0),
      ),
      icon: const Icon(Icons.navigate_next_rounded),
      label: const Text('Join'),
    );
  }
}
