import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _builRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _builRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
      title: Text(pair.asLowerCase),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setStateSaved) {
              final Iterable<ListTile> tiles = _savedWordPairs.map((
                WordPair pair,
              ) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: Icon(Icons.delete),
                  onTap: () {
                    setState(() {
                      _savedWordPairs.remove(pair); // обновим в главном экране
                    });
                    setStateSaved(() {}); // обновим экран избранного
                  },
                );
              });

              final List<Widget> divided =
                  ListTile.divideTiles(context: context, tiles: tiles).toList();

              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved word Pairs'),
                  backgroundColor: Colors.blue,
                ),
                body: ListView(children: divided),
              );
            },
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WordPair Generator"),
        actions: <Widget>[
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
        ],
        backgroundColor: Colors.blue,
      ),
      body: _buildList(),
    );
  }
}
