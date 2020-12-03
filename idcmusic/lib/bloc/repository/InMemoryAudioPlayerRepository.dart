import 'package:assets_audio_player/assets_audio_player.dart';
import 'AudioPlayerRepository.dart';

class InMemoryAudioPlayerRepository implements AudioPlayerRepository{
  final List <Audio> audioPlayerModels;
  Audio currentSong;

  InMemoryAudioPlayerRepository({
    this.audioPlayerModels
  });

  @override
  Future<Audio> updateCurrentSong(Audio updatedModel){
    //audioPlayerModels[audioPlayerModels.indexWhere((element) => element.id == updatedModel.id)] = updatedModel;
    currentSong = updatedModel;
    return Future.value(currentSong);
  }

  @override
  Future<Audio> getCurrentSong(){
    return Future.value(currentSong);
  }

  @override
  Future<Audio> getById(String audioPlayerId) {
    //return Future.value(audioPlayerModels.firstWhere((model) => model.id == audioPlayerId));
  }

  @override
  Future<List<Audio>> getAll() {
    return Future.value(audioPlayerModels);
  }

  @override
  Future<List<Audio>> updateModel(Audio updatedModel) {
    //audioPlayerModels[audioPlayerModels.indexWhere((element) => element.id == updatedModel.id)] = updatedModel;
    return Future.value(audioPlayerModels);
  }

  @override
  Future<List<Audio>> updateAllModels(List<Audio> updatedList) {
    audioPlayerModels.clear();
    audioPlayerModels.addAll(updatedList);
    return Future.value(audioPlayerModels);
  }
}