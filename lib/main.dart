import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_api/giphy_service.dart';

void main() => runApp(const GiphySearchApp());

class GiphySearchApp extends StatefulWidget {
  const GiphySearchApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GiphySearchAppState createState() => _GiphySearchAppState();
}

class _GiphySearchAppState extends State<GiphySearchApp> {
  final _searchController = TextEditingController();
  List<dynamic> _results = [];
  final _giphy = GiphyService();

  Future<void> _search(String query) async {
    final response = await _giphy.search(query);
    final data = jsonDecode(response.body)['data'];
    setState(() {
      _results = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.blue,
        accentColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.add_reaction_outlined),
          title: const Text('Search for your favorite gifs', style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.blue[800],
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    Future.delayed(
                        const Duration(milliseconds: 300), () => _search(value));
                  }
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for GIFs',
                  hintStyle: const TextStyle(color: Colors.white54),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.blue[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _results.isNotEmpty
                  ? StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: _results.length,
                      staggeredTileBuilder: (index) =>
                          const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        final result = _results[index];
                        final url = result['images']['fixed_width']['url'];
                        return Image.network(
                          url,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
