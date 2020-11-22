import "package:assets_audio_player/assets_audio_player.dart";
import "package:church_of_christ/player/models/AudioPlayerModel.dart";

class AudioPlayerModelFactory{

  static List<AudioPlayerModel> getAudioPlayerModels() {
    return [
      AudioPlayerModel(
          id: "1",
          isPlaying: false,
          audio: Audio(
              "assets/audios/country.mp3",
              metas: Metas(
                id: "1",
                title: "My Country Song",
                artist: "Joe Doe",
                album: "Country Album",
                image: MetasImage.asset("assets/images/country.jpg"),
              )
          )
      ),
    ];
  }
}