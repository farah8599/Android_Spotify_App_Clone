import './Models/external_url.dart';
import './Models/follower.dart';
import './Models/image.dart';
import './Models/owner.dart';
List<Image> parceImage(imageJason) {
  var list = imageJason as List;
  List<Image> imageList = list.map((data) => Image.fromjson(data)).toList();
  return imageList;
}

List<ExternalUrl> parceExternalUrl(externalUrlJason) {
  var list = externalUrlJason as List;
  List<ExternalUrl> externalUrlList =
      list.map((data) => ExternalUrl.fromjson(data)).toList();
  return externalUrlList;
}

List<Follower> parceFollower(followerJason) {
  var list = followerJason as List;
  List<Follower> followerList =
      list.map((data) => Follower.fromjson(data)).toList();
  return followerList;
}

List<Owner> parceOwner(ownerJson) {
  var list = ownerJson as List;
  List<Owner> ownerList = list.map((data) => Owner.fromjason(data)).toList();
  return ownerList;
}