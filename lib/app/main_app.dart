import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';

final errorDisplayKey = GlobalKey<AppErrorDisplayState>();
final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _gameRoomNotifier = GameRoomNotifier();
  final _roomGateway = RoomGateway();

  @override
  void dispose() {
    _gameRoomNotifier.dispose();
    _roomGateway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameRoomModel(
      notifier: _gameRoomNotifier,
      child: RoomModel(
        notifier: _roomGateway,
        child: AppErrorDisplay(
          key: errorDisplayKey,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(0, 15, 228, 232)),
            ),
            navigatorObservers: [routeObserver],
            routes: {
              '/': (context) => const StartPage(),
              '/waitingRoom': (_) => const WaitingRoom(),
              '/joinRoom': (_) => const JoiningRoom(),
              '/game': (context) => GameWidget(game: MainGame2()),
            },
          ),
        ),
      ),
    );
  }
}
