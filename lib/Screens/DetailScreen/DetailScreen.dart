import 'package:flutter/material.dart';
import 'package:music_rater/Screens/DetailScreen/MobileScreen.dart';
import 'package:music_rater/Screens/DetailScreen/WebScreen.dart';
import 'package:universal_platform/universal_platform.dart';

class DetailScreen extends StatefulWidget{
  final musicID, musicName, artistName, genre, musicUrl;

  DetailScreen({this.musicID, this.musicName, this.artistName, this.genre, this.musicUrl});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen>{

  @override
  Widget build(BuildContext context) {
    if(UniversalPlatform.isAndroid || MediaQuery.of(context).size.width < 600){
      return MobileScreen(musicID: widget.musicID, musicName: widget.musicName,
      artistName: widget.artistName, genre: widget.genre, musicUrl: widget.musicUrl);
    }
    return WebScreen(musicID: widget.musicID, musicName: widget.musicName,
        artistName: widget.artistName, genre: widget.genre, musicUrl: widget.musicUrl);
  }
}