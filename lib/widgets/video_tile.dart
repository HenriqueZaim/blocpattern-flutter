import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_blocpattern/blocs/favorite_bloc.dart';
import 'package:youtube_blocpattern/models/video.dart';
import 'package:youtube_blocpattern/api.dart';

class VideoTile extends StatelessWidget {

  final Video video;
  final favoriteBloc = BlocProvider.getBloc<FavoriteBloc>();

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: video.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16.0/9.0,
              child: Image.network(video.thumb, fit: BoxFit.cover),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          video.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          video.channel,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: favoriteBloc.outFav,
                  initialData: {},
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return IconButton(
                        icon: Icon(
                            snapshot.data.containsKey(video.id)
                                ? Icons.star
                                : Icons.star_border
                        ),
                        onPressed: (){
                          favoriteBloc.toggleFavorite(video);
                        },
                      );
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
