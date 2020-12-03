import "package:assets_audio_player/assets_audio_player.dart";

class AudioPlayerModelFactory{

  static List<Audio> getAudioPlayerModels() {
    return [
      Audio(
              "assets/audios/country.mp3",
              metas: Metas(
                id: "1",
                title: "My Country Song",
                artist: "Joe Doe",
                album: "Country Album",
                image: MetasImage.asset("assets/images/country.jpg"),
              )
          ),
    ];
  }
}