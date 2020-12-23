import 'package:church_of_christ/provider/view_state_model.dart';

abstract class ViewStateListModel<T> extends ViewStateModel{
  List<T> list = []; 

  initData() async{
    setBusy();
    await refresh(init:true);
  }

  refresh({bool init = false}) async{
    try{
      List<T> data = await loadData();
      if(data.isEmpty){
        list.clear();
        setEmpty();
      }
      else{
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setIdle();
      }      
    } catch( e,s ){
      if(init) list.clear();
      setError(e,s);
    }
  }

  Future<List<T>> loadData(); 

  onCompleted(List<T> data){}
}