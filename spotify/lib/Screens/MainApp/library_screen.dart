//import packages
import 'package:flutter/material.dart';
//import screens
import 'package:spotify/Screens/Library/albums_screen.dart';
import 'package:spotify/Screens/Library/playlists_screen.dart';
import 'package:spotify/Screens/Library/artists_screen.dart';

class LibraryScreen extends StatelessWidget {
  static const routeName = '/library_screen';

  const LibraryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    int initialindex = 0;
    return DefaultTabController(
      length: 3,
      initialIndex: initialindex,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Music',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          bottom: TabBar(
              indicatorColor: Colors.lightGreen,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Playlists',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Artists',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Albums',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(children: <Widget>[
          Container(
              height: deviceSize.height * 0.43923, child: PlaylistsScreen()),
          ArtistsScreen(),
          AlbumsScreen(),
        ]),
      ),
    );
  }
}
