import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_test/flutter_test.dart';
import '../../Providers/album_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../Providers/user_provider.dart';


class EditAlbum extends StatefulWidget {
  ///save the id of the album to be edited
  final id;

  ///constructor to set this id
  EditAlbum({this.id});

  ///route name to get to the screen from navigator.
  static const routeName = '//edit_album_screen';
  @override
  _EditAlbumState createState() => _EditAlbumState();
}

class _EditAlbumState extends State<EditAlbum> {
  ///indicator to the file which the user pick image to.
  File imageURI;

  ///controller for album name text field.
  final albumNameController = TextEditingController();

  ///controller for album type text field.
  final albumTypeController = TextEditingController();

  ///selected value of the album type drop down menu.
  String dropdownValue1;

  ///selected value of the genres drop down menu.
  String dropdownValue2;

  ///method to pick image from mobile gallery.
  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
  }

  ///method used to create new album by sending its data to the server.
  void _editAlbum(BuildContext ctx , String _userToken ) async
  {
    final deviceSize = MediaQuery.of(context).size;
    bool check =
    await Provider.of<AlbumProvider>(context , listen: false)
        .editAlbum(imageURI ,_userToken ,albumNameController.text ,widget.id );
//      if (check)
//      {
//        await Provider.of<AlbumProvider>(context, listen: false)
//            .fetchMyAlbums(_userToken);
//      }
    setState(() {
      if(check)
      {

        Scaffold.of(context).showSnackBar(
            SnackBar(
                content: Container(
                    height: deviceSize.height*0.1,
                    child: Text("album edited successfuly!"))));
        Navigator.of(ctx).pop();
      }
      else
        {
          Scaffold.of(context).showSnackBar(
              SnackBar(
                  content: Container(
                      height: deviceSize.height*0.1,
                      child: Text("something went wrong ,please try again!"))));
        }
    });
  }
  @override
  Widget build(BuildContext context) {

    ///get device size for responsiveness issues.
    final deviceSize = MediaQuery.of(context).size;
    String _user = Provider.of<UserProvider>(context, listen: false).token;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Edit Album"),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(deviceSize.height * 0.03),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: deviceSize.width * 0.02,
                  bottom: deviceSize.width * 0.02,
                  left: deviceSize.width * 0.2,
                  right: deviceSize.width * 0.2),
              width: deviceSize.width * 0.4,
              child: TextFormField(
                controller: albumNameController,
                decoration: InputDecoration(
                  labelText: 'Album name ',
                  filled: true,
                  fillColor: Colors.green[700],
                  labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.text,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                imageURI == null
                    ? Text(
                  'No image selected.',
                  style: TextStyle(color: Colors.redAccent),
                )
                    : Image.file(imageURI,
                    width: deviceSize.width * 0.4,
                    height: deviceSize.width * 0.4,
                    fit: BoxFit.cover),
                Container(
                    margin: EdgeInsets.only(
                        top: deviceSize.width * 0.02,
                        bottom: deviceSize.width * 0.02,
                        left: deviceSize.width * 0.2,
                        right: deviceSize.width * 0.2),
                    width: deviceSize.width * 0.7,
                    height: deviceSize.width * 0.12,
                    child: RaisedButton(
                      onPressed: () =>getImageFromGallery(),
                      child: Text('Open Gallery'),
                      textColor: Colors.white,
                      color: Colors.green[700],
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(deviceSize.height * 0.01),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: deviceSize.width * 0.25,
                  left: deviceSize.width * 0.25),
              height: deviceSize.height * 0.07,
              width: deviceSize.width * 0.1,
              child: FloatingActionButton(
                onPressed: () => _editAlbum(context, _user),
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.1713,
            )
          ],
        ),
      ),
    );
  }
}
