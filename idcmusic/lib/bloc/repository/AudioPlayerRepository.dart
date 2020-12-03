import 'package:assets_audio_player/assets_audio_player.dart';

abstract class AudioPlayerRepository{
  Future<Audio> updateCurrentSong(Audio updatedModel);
  Future<Audio> getCurrentSong();

  Future<Audio> getById(String audioPlayerId);
  Future<List<Audio>> getAll();

  Future<List<Audio>> updateModel(Audio updatedModel);
  Future<List<Audio>> updateAllModels(List<Audio> updatedList);
}