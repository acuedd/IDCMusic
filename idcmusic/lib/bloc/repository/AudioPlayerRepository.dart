
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';

abstract class AudioPlayerRepository{
  Future<AudioPlayerModel> getById(String audioPlayerId);
  Future<List<AudioPlayerModel>> getAll();

  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updatedModel);
  Future<List<AudioPlayerModel>> updateAllModels(List<AudioPlayerModel> updatedList);
}