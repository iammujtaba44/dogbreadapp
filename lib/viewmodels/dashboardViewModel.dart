import 'package:dogbreadapp/services/api_imp.dart';
import 'package:dogbreadapp/viewmodels/views/base_model.dart';

class DashBoardViewModel extends BaseModel {
  ApiImp _apiImp;

  DashBoardViewModel(this._apiImp);

  Future<List<dynamic>> getPaginatedData(limt, page) async {
    setBusy(true);
    var res = await _apiImp.getPaginatedBreeds(limt, page);
    if (res.length == 0)
      setNoRecordFound(true);
    else
      setNoRecordFound(false);
    setBusy(false);
    return res;
  }

  Future<List<dynamic>> getPaginatedDataByName(limt, page,
      {String value}) async {
    setBusy(true);
    var res = await _apiImp.getPaginatedBreedsByNmae(limt, page, value: value);
    if (res.length == 0)
      setNoRecordFound(true);
    else
      setNoRecordFound(false);
    setBusy(false);
    return res;
  }
  Future<List<dynamic>> getBreedDetails(dynamic id) async {
    setBusy(true);
    var res = await _apiImp.getBreedDetails(id);
    if (res.length == 0)
      setNoRecordFound(true);
    else
      setNoRecordFound(false);
    setBusy(false);
    return res;
  }
}
