import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify/Providers/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify/Widgets/album_widget_artist_profile.dart';
import 'package:spotify/widgets/song_promo_card_artist_profile.dart';
import '../../Models/playlist.dart';
import 'package:spotify/Models/artist.dart';
import 'package:spotify/Providers/artist_provider.dart';
import '../../Models/album.dart';
import '../../Providers/album_provider.dart';
import '../MainApp/tab_navigator.dart';
import '../../widgets/album_widget_artist_profile.dart';
import '../../widgets/featured_playlists_artist_profile.dart';
import '../../widgets/suggested_artists_artist_profile.dart';
import '../../widgets/artist_card_widget.dart';
import '../../Providers/user_provider.dart';
import '../../Providers/track_provider.dart';
import '../../Widgets/album_widget_artist_profile.dart';
import '../../Widgets/album_widget_artist_mode.dart';
import '../../Models/track.dart';
import 'dart:io';
import 'dart:async';

class ArtistProfileScreen extends StatefulWidget {
  final String id;
  ArtistProfileScreen(this.id);
  @override
  ArtistProfileScreenState createState() => ArtistProfileScreenState();
}

class ArtistProfileScreenState extends State<ArtistProfileScreen> {

  bool _isLoading = false;
  List<Artist> artists = [];
  List<Playlist> playlists;
  List<Album> albums;
  bool _isInit = false;
  Artist artistInfo;
  String artistName;
  String artistId;

  bool isScreenLoading=true;
  var testLen = 1;
  bool _isScrolled = false;
  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      isScreenLoading=false;
    });
    super.initState();
  }

  @override

  void _showErrorDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Loading Failed'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              //to be popped in the next phase
              Navigator.of(ctx).pushReplacementNamed(TabNavigatorRoutes.search);
            },
          )
        ],
      ),
    );
  }
  bool relatedArtists = true;
  bool checkAlbums = true;
  bool checkPlaylist = true;
  bool checkTracks = true;

  void didChangeDependencies() async {
      if (!_isInit) {
        setState(
                () {
              _isLoading = true;
            });
        final user = Provider
            .of<UserProvider>(context, listen: false).token;
        try {
          await Provider.of<PlaylistProvider>(
              context, listen: false)
              .fetchArtistProfilePlaylists(
              user, widget.id);
        } catch(e)
    {
      setState(() {
        checkPlaylist = false;
      });

    }
        try {
          await Provider.of<ArtistProvider>(
              context, listen: false)
              .fetchMultipleArtists(
              user , widget.id);
        } catch (e)
        {
          setState(() {
            relatedArtists = false;
          });
        }
        try {
          await Provider.of<AlbumProvider>(
              context, listen: false)
              .fetchArtistAlbums(
              user, widget.id);
        } catch(e) {
          setState(
                  () {
                checkAlbums = false;
              });
        }

      /*try {
       / await Provider.of<TrackProvider>(
            context, listen: false)
            .fetchArtistTopTracks(
            user, widget.id).then ((_) {
          setState(
                  () {
                _isLoading = false;
              });
        });
      } catch(e)
      {
        setState(() {
          checkTracks = false;
        });

    }*/
    await Provider.of<ArtistProvider>(
            context, listen: false)
            .fetchChoosedArtist(
            user, widget.id)
            .then(
                (_) {
              setState(
                      () {
                    _isLoading = false;
                  });
            });
        _isInit = true;
      }

      super.didChangeDependencies(
      );

  }

  void _goToDiscography(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      TabNavigatorRoutes.discographyScreen,
    );
  }

  void _goToAbout(BuildContext ctx1) {
    Navigator.of(ctx1).pushNamed(TabNavigatorRoutes.aboutInfoScreen);
  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final artistProvider = Provider.of<ArtistProvider>(context, listen: false);
    List<Artist> artists;
    artists = artistProvider.getMultipleArtists;
    artistInfo = artistProvider.getChoosedArtist;
    final playlistsProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    List<Playlist> playlists;
    playlists = playlistsProvider.getArtistProfilePlaylists;
    //print(playlists[0].name);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    List<Album> albums;
    albums = albumProvider.getArtistAlbums;

    //final tracksProvider = Provider.of<TrackProvider>(context, listen: false);
    //List<Track> tracks;
    //tracks = tracksProvider.getTopTracks;

    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green[700],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
                FlatButton(
                  child: Text('FOLLOW'),
                  textColor: Colors.grey,
                  //onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                  //onPressed: () {},
                ),
              ],
            ),
            backgroundColor: Colors.black,
            body: ListView(
              children: <Widget>[
                Container(
                  height: deviceSize.height * 0.6,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: testLen,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) => ChangeNotifierProvider.value(
                      value: artistInfo,
                      child: ArtistBackground(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: deviceSize.width * 0.25,
                      left: deviceSize.width * 0.25),
                  height: deviceSize.height * 0.07,
                  width: deviceSize.width * 0.1,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'SHUFFLE PLAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    //onPressed: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: deviceSize.height * 0.04,
                      bottom: deviceSize.height * 0.02),
                ),
                /*checkAlbums ?*/ /*Text(
                  'Popular releases',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ): null,
                checkTracks ? Container(
                  height: deviceSize.height * 0.3,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: albums.length,
                    physics:
                         NeverScrollableScrollPhysics(), //to be replaced with fixed 4 items
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) => ChangeNotifierProvider.value(
                      value:  checkTracks ? albums[i] : null  ,
                      child: LoadingAlbumsWidget(),
                    ),
                  ),
                ): null,*/
                Container(
                  margin: EdgeInsets.only(
                      right: deviceSize.width * 0.18,
                      left: deviceSize.width * 0.18),
                  padding: EdgeInsets.all(deviceSize.height * 0.04),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text(
                      'SEE DISCOGRAPHY',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _goToDiscography(context),
                  ),
                ),

                /* Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Featuring' + ' ' + artistName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),

            //row of featured playlists
             Container(

              height: 200,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: playlists.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => ChangeNotifierProvider.value(
                    value: playlists[i],
                    child: FeaturedPlaylists(),
                  )),
            ),*/

                Container(
                  padding: EdgeInsets.only(
                      top: deviceSize.height * 0.01,
                      bottom: deviceSize.height * 0.01),
                  child: relatedArtists ?Text(
                    'Fans also like ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ) : null
                ),

                Container(
                  height: relatedArtists ?deviceSize.height * 0.35 : 0,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: artists.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => ChangeNotifierProvider.value(
                      value: relatedArtists ?artists[i] : null,
                      child: suggesttedArtists(),
                    ),
                  ),
                ),
                checkPlaylist ?Container(
                  padding: EdgeInsets.only(
                      top: deviceSize.height * 0.01,
                      bottom: deviceSize.height * 0.01),
                  child: Text(
                    'Artist Playlists',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ): null,
                checkPlaylist ? Container(
                  height: deviceSize.height * 0.35,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: playlists.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => ChangeNotifierProvider.value(
                            value:  playlists[i]  ,
                            child: FeaturedPlaylists(),
                          )),
                ): null,
                Container(
                  padding: EdgeInsets.only(
                      top: deviceSize.height * 0.01,
                      bottom: deviceSize.height * 0.01),
                  child: Text(
                    'About',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                InkWell(
                  child: Container(
                    height: deviceSize.height * 0.6,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: testLen,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) => ChangeNotifierProvider.value(
                        value: artistInfo,
                        child: ArtistBackground(),
                      ),
                    ),
                  ),
                  onTap: () => _goToAbout(context),
                ),
              ],
            ),
          );
  }
}
