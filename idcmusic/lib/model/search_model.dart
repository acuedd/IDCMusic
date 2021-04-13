import 'package:church_of_christ/provider/view_state_list_model.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/provider/view_state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String kSearchHistory = 'kSearchHistory';

class SearchHistoryModel extends ViewStateListModel<String>{
  clearHistory() async{
    debugPrint("clearHistory");
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(kSearchHistory);
    list.clear(); 
    setEmpty();
  }


  addHistory(String keyword) async{
    var sharedPreferences = await SharedPreferences.getInstance();
    var histories = sharedPreferences.getStringList(kSearchHistory) ?? [];
    histories
      ..remove(keyword)
      ..insert(0, keyword);

    //await sharedPreferences.setString(kSearchHistory, histories);
    notifyListeners();
  }


  @override
  Future<Map<String, dynamic >> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }
}