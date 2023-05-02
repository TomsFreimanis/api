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
       theme: ThemeData(fontFamily: 'Montserrat'),
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.add_reaction_outlined),
          title: const Text('Search for your favorite gifs'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  Future.delayed(
                      const Duration(milliseconds: 300), () => _search(value));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search for GIFs',
                contentPadding: EdgeInsets.all(16),
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
                        final url = result['images']['downsized_medium']['url'];
                        return Image.network(url);
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
