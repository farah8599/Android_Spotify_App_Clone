import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/Providers/playable_track.dart';
import 'package:spotify/Providers/user_provider.dart';
import 'package:spotify/Screens/Albums/song_item_pop_up_menu.dart';
import '../Models/track.dart';

///It is used to provide the [PlaylistsListScreen] with the needed data about the track.
class SongItemInLikedPlaylistList extends StatefulWidget {
 final Track trackObject;
  SongItemInLikedPlaylistList(this.trackObject);
  @override
  _SongItemInLikedPlaylistListState createState() => _SongItemInLikedPlaylistListState();
}

class _SongItemInLikedPlaylistListState extends State<SongItemInLikedPlaylistList> {
  @override
  Widget build(BuildContext context) {
    final song = Provider.of<Track>(context, listen: false);
    final track = Provider.of<PlayableTrackProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    return Row(children: <Widget>[
      Container(
        width: deviceSize.width * 0.7,
        height: deviceSize.height * 0.1,
        child: InkWell(
          onTap: () {
            track.setCurrentSong(song, user.isUserPremium(), user.token);
            Navigator.pop(context);
          },
          child: ListTile(
            leading: Image.network(widget.trackObject.album.image),
            title: Text(
              widget.trackObject.name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              widget.trackObject.artists[0].name,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
      IconButton(
        icon: Icon(
          track.isTrackLiked(song.id) ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
        onPressed: () async {
          if (track.isTrackLiked(song.id)) {
            await track.unlikeTrack(user.token, song.id).then((_) {
              setState(() {});
            });
          } else {
            await track.likeTrack(user.token, song).then((_) {
              setState(() {});
            });
          }
        },
      ),
      IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.black87,
              pageBuilder: (BuildContext context, _, __) {
                return SongItemPopUpMenu(song);
              }));
        },
      ),
    ]);
  }
}
