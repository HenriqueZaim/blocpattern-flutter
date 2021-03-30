import 'dart:convert';

import 'package:http/http.dart';
import 'package:youtube_blocpattern/models/video.dart';

const API_KEY = "AIzaSyByQAKo_j5ZLgDoqgWeV4JWBHA5M_QoYU8";

// "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"

// "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"

// "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {

  String _nextToken;
  String _search;

  Future<List<Video>> search(String search) async {
    _search = search;
    Response response = await get(
       Uri.parse( "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10" )
    );
    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    Response response = await get(
        Uri.parse( "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken" )
    );
    return decode(response);
  }

  List<Video> decode(Response response){
    if(response.statusCode == 200){
      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded["items"].map<Video>(
          (map) {
            return Video.fromJson(map);
          }
      ).toList();

      return videos;
    }else{
      throw Exception("Um erro ocorreu. Tente novamente");
    }
  }
}