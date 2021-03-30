import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_blocpattern/blocs/favorite_bloc.dart';
import 'package:youtube_blocpattern/models/video.dart';
import 'package:youtube_blocpattern/api.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Meu favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        initialData: {},
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data.values.map((item) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                  onTap: () {
                    FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: item.id);
                  },
                  onLongPress: (){
                    bloc.toggleFavorite(item);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        child: Image.network(item.thumb),
                      ),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
