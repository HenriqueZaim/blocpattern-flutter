import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DataSearch extends SearchDelegate<String>{

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty)
      return Container();
    else{
      return FutureBuilder<List>(
        future: getSuggestions(query),
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Align(child: CircularProgressIndicator(), alignment: Alignment.center);
          else {
            return ListView.builder(
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(snapshot.data[index]),
                  onTap: (){
                    close(context, snapshot.data[index]);
                  },
                );
              },
              itemCount: snapshot.data.length,
            );
          }
        },
      );
    }
  }

  Future<List<dynamic>> getSuggestions(String search) async {
    Response response = await get(
        Uri.parse('https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json')
    );

    if(response.statusCode == 200){
      return json.decode(response.body)[1].map(
          (item){
            return item[0];
          }
      ).toList();
    }else{
      throw Exception("Ocorreu um erro ao mostrar sugestões. Tente novamente");
    }
  }

}