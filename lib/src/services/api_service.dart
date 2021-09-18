// import 'package:auth/src/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_flutter2_5/src/utils/constant.dart';
class ApiService{
  get(_url) async {
    // print('${MyConstant.localBaseURL}$_url');
    var apiData = await http.get(Uri.parse('${MyConstant.localBaseURL}$_url'));
    return(apiData.body);
  }
}
