import 'package:dogbreadapp/services/api_imp.dart';
import 'package:dogbreadapp/viewmodels/views/base_model.dart';

class DashBoardViewModel extends BaseModel {
  ApiImp _apiImp;

  DashBoardViewModel(this._apiImp);

  Future<List<dynamic>> getPaginatedData(limt, page) async {
    setBusy(true);
    var res = await _apiImp.getPaginatedBreeds(limt, page);
    setBusy(false);
    return res;
  }
}
