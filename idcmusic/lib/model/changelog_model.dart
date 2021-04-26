import 'package:church_of_christ/provider/view_state_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChangelogModel extends ViewStateListModel{
  
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  ChangelogModel();

  @override
  Future<Map<dynamic, dynamic>> loadData() async{
    return await BaseRepository.fetchChangelog();
  }

  Future<dynamic> refresh({bool init = false}) async {
    try{
      var data = await loadData();
      if(data.isEmpty){
        refreshController.refreshCompleted(resetFooterState: true);
        list.clear();
        setEmpty();
      }
      else{
        onCompleted(data);
        list.clear();
        list = data;
        refreshController.refreshCompleted();
        refreshController.loadComplete();

        setIdle();
      }
      return data;
    } catch (e, s) {
      if (init) list.clear();
      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}