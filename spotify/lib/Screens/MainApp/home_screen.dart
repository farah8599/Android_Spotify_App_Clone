//Importing libraries from external packages.
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
//Importing providers.
import 'package:provider/provider.dart';
import 'package:spotify/Providers/categories_provider.dart';
import 'package:spotify/Providers/play_history_provider.dart';
import 'package:spotify/Providers/playlist_provider.dart';
import 'package:spotify/Providers/user_provider.dart';
import 'package:spotify/Providers/album_provider.dart';
import 'package:spotify/widgets/play_history_list_widget.dart';
import '../../Providers/playable_track.dart';
import './tab_navigator.dart';
//Importing Screens.
import 'package:spotify/Screens/MainApp/tab_navigator.dart';
//Importing widgets.
import '../../widgets/playlist_list_widget.dart';
import '../../widgets/album_list_widget.dart';

class HomeScreen extends StatefulWidget {
  ///Static variable for the route name of this screen.
  static const routeName = '/home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///A boolean to indicate the screen is loading or not.
  bool _isLoading = false;

  ///A boolean to indicate the screen is initiallized or not.
  bool _isInit = false;

  ///A userprovider[UserProvider] variable to get all the user's details.
  UserProvider user;

  ///A categoryprovider[CategoriesProvider] variable to get all the home screen categories.
  CategoriesProvider categoriesProvider;

  ///A categoryprovider[PlaylistProvider] variable to get all the home screen categories.
  PlaylistProvider playlistProvider;

  /// Boolean to indicate whether there is a new notifications to show badge.
  bool showBadge = false;

  ///A number to count the number of new notifications.
  int numberOfNewNotifications = 0;
  
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.configure(
      onLaunch: (msg) async {
        print(msg);
        return;
      },
      onResume: (msg) async {
        print(msg);
        return;
      },
      onMessage: (msg) {
        setState(() {
          showBadge = true;
          numberOfNewNotifications++;
        });
        print(msg);
        return;
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      categoriesProvider =
          Provider.of<CategoriesProvider>(context, listen: false);
      user = Provider.of<UserProvider>(context, listen: false);
      playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
      Provider.of<PlayHistoryProvider>(context, listen: false)
          .fetchRecentlyPlayed(user.token);
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchMadeForYou(user.token);
      Provider.of<AlbumProvider>(context, listen: false)
          .fetchMostRecentAlbums(user.token);
      Provider.of<AlbumProvider>(context, listen: false)
          .fetchPopularAlbums(user.token);
      Provider.of<PlayableTrackProvider>(context, listen: false)
          .fetchUserLikedTracks(user.token, 50);
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchMostRecentPlaylists(user.token)
          .then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });

      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchPopularPlaylists(user.token);
      categoriesProvider.fetchHomeScreenCategories(user.token).then((_) {
        if (mounted) {
          setState(() {
            if (categoriesProvider.isArabic) {
              playlistProvider.fetchArabicPlaylists(
                  user.token, categoriesProvider.getArabicCategoryId);
            }
            if (categoriesProvider.isHappy) {
              playlistProvider.fetchHappyPlaylists(
                  user.token, categoriesProvider.getHappyCategoryId);
            }
            if (categoriesProvider.isJazz) {
              playlistProvider.fetchJazzPlaylists(
                  user.token, categoriesProvider.getJazzCategoryId);
            }
            if (categoriesProvider.isPop) {
              playlistProvider.fetchPopPlaylists(
                  user.token, categoriesProvider.getPopCategoryId);
            }
            _isLoading = false;
          });
        }
      });
    }

    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    PlayHistoryProvider playHistoryProvider =
        Provider.of<PlayHistoryProvider>(context);
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(40, 96, 65, 7.0),
                  Color(0xFF191414),
                ],
                begin: Alignment.topLeft,
                end: FractionalOffset(0.2, 0.2),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 0,
                    backgroundColor: Colors.transparent,
                    actions: <Widget>[
                      Badge(
                        showBadge: showBadge,
                        animationType: BadgeAnimationType.scale,
                        shape: BadgeShape.circle,
                        position: BadgePosition(
                          top: -0.5,
                          right: -0.5,
                        ),
                        badgeColor: Colors.green,
                        badgeContent: Text(
                          numberOfNewNotifications.toString(),
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              showBadge = false;
                              numberOfNewNotifications = 0;
                            });
                            Navigator.of(context).pushNamed(
                                TabNavigatorRoutes.recentActivitiesScreen);
                          },
                          icon: Icon(
                            Icons.notifications,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(TabNavigatorRoutes.settings);
                        },
                        icon: Icon(
                          Icons.settings,
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Column(
                          children: <Widget>[
                            if (!playHistoryProvider.getRecentlyPlayed.isEmpty)
                              RecentlyPlayedList(),
                            PlaylistList(PlaylistCategory.madeForYou),
                            PlaylistList(PlaylistCategory.mostRecentPlaylists),
                            PlaylistList(PlaylistCategory.popularPlaylists),
                            AlbumList(AlbumCategory.mostRecentAlbums),
                            AlbumList(AlbumCategory.popularAlbums),
                            if (categoriesProvider.isPop)
                              PlaylistList(PlaylistCategory.pop),
                            if (categoriesProvider.isJazz)
                              PlaylistList(PlaylistCategory.jazz),
                            if (categoriesProvider.isArabic)
                              PlaylistList(PlaylistCategory.arabic),
                            if (categoriesProvider.isHappy)
                              PlaylistList(PlaylistCategory.happy),
                            SizedBox(
                              height: deviceSize.height * 0.1713,
                            ),
                          ],
                        );
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
