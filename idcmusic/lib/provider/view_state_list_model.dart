import 'package:church_of_christ/provider/view_state_model.dart';

abstract class ViewStateListModel<T> extends ViewStateModel{
  Map<String, dynamic> list = Map<String, dynamic>(); 

  initData() async{
    setBusy();
    await refresh(init:true);
  }

  refresh({bool init = false}) async{
    try{
    Map<String, dynamic> data = await loadData();
      if(data.isEmpty){
        list.clear();
        setEmpty();
      }
      else{
        onCompleted(data);
        list.clear();
        list = data;
        setIdle();
      }      
    } catch( e,s ){
      if(init) list.clear();
      setError(e,s);
    }
  }

  Future<Map<String, dynamic>> loadData(); 

  onCompleted(Map<String, dynamic> data){}
}