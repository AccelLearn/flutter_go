import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider (
      create: (contenxt) => MyAppState(),
      child: MaterialApp(
        title: 'Startup Name',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
        ),
        home: MyHomePage(),
        routes: {
          '/home': (context) => GeneratorPage(),
          '/favorite':(context) => FavoritePage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentWord = WordPair.random();
  var favoriteWords = <WordPair>[];

  void changeWord() {
    currentWord = WordPair.random();
    notifyListeners();
  }

  void addFavoriteWord(WordPair word) {
    if(favoriteWords.contains(word)) {
      favoriteWords.remove(word);
    } else {
      favoriteWords.add(word);
    }
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _children = [
    GeneratorPage(),
    FavoritePage(),
  ];

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ]
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    WordPair pair = appState.currentWord;
    IconData icon = appState.favoriteWords.contains(pair) ? Icons.favorite : Icons.favorite_border;


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 前面的 pair 是传递给 BigCard 的参数
          // 后面的 pair 是上面定义的变量
          BigCard(pair: pair),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.addFavoriteWord(pair);
                },
                child: Row(
                  children: [
                    Icon(icon, size: 20,),
                    SizedBox(width: 5),
                    Text('favorite'),
                  ],
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  appState.changeWord();
                },
                child: Text('next'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      shadowColor: theme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: 'A random word',
        ),
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favoriteWords = appState.favoriteWords;
    
    if(favoriteWords.isEmpty) return Center(child: Text('No favorite words yet!'));

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${favoriteWords.length} favorites:'),
        ),
        for (var word in favoriteWords)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(word.asPascalCase),
          )
      ],
    );
  }
}
