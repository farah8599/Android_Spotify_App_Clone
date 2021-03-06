import 'package:flutter/material.dart';
import 'package:spotify/Providers/user_provider.dart';
import '../Models/track.dart';
import '../Models/artist.dart';
import '../Providers/playable_track.dart';
import 'package:provider/provider.dart';
import '../Screens/MainApp/tab_navigator.dart';
import '../Providers/track_provider.dart';
import '../Models/track.dart';

class SongPromoCard extends StatefulWidget {
  @override
  _SongPromoCardState createState() => _SongPromoCardState();
}

class _SongPromoCardState extends State<SongPromoCard> {
  String image =
      "https://i.scdn.co/image/c4818b1f9d0c7a793d421b51c63d82c8c768795c";

  //String name = 'Sahran';

  //String artist = 'AmrDiab123';

  @override
  Widget build(BuildContext context) {
    final playabletrack =
        Provider.of<PlayableTrackProvider>(context, listen: false);
    final user =
    Provider.of<UserProvider>(context, listen: false);

    final trackProvider = Provider.of<Track>(context);
    //List <Track> tracks = trackProvider.getTopTracks;
    final deviceSize = MediaQuery.of(context).size;
    return InkWell(
      child: Row(
        children: <Widget>[
          Container(
            //width: double.infinity,
            padding: EdgeInsets.only(
                top: deviceSize.width * 0.05,
                bottom: deviceSize.width * 0.05,
                left: deviceSize.width * 0.05,
            right:deviceSize.width * 0.03, ),
            child: FadeInImage(placeholder:AssetImage('assets/images/temp.jpg'),
              height: deviceSize.height * 0.1,
              width: deviceSize.width * 0.1,
              fit: BoxFit.cover,
              image:NetworkImage(
              trackProvider.album.image,
            ),
            ),
          ),
          Column(children: <Widget>[
            Text(
              trackProvider.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              trackProvider.name,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ]),
        ],
      ),
      onTap: () {
        playabletrack.setCurrentSong(trackProvider,user.isUserPremium(),user.token);
        //Navigator.of(context).pushNamed(TabNavigatorRoutes.playlistScreen);
      },
    );
  }
}
