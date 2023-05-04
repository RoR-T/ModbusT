import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

import 'package:modbust/setting/setting.dart';
import 'package:modbust/data/data.dart';

void main() {
  runApp(const ModbusApp());
}

class ModbusApp extends StatelessWidget {
  const ModbusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModbusState(),
      child: MaterialApp(
        title: 'Modbus RTU/TCP Simulator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class ModbusState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorrite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectIndex) {
      case 0:
        page = const DataPage();
        break;
      case 1:
        page = const SettingPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                minWidth: 80,
                extended: false,
                selectedIndex: selectIndex,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dataset),
                    label: Text('Data'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Setting'),
                  ),
                ],
                onDestinationSelected: (value) {
                  setState(() {
                    selectIndex = value;
                  });
                },
              ),
            ),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ))
          ],
        ),
      );
    });
  }
}
