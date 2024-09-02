import 'dart:convert';
import 'dart:developer';
import 'package:api_call_demo/ApiCalling/api.dart';
import 'package:api_call_demo/Model/home_data_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<GetApiList>?> getListData() async {
    const url = ApiUrls.getList;
    print("Get List Url : $url");
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;

      log("Get List data : $body");
      List<GetApiList> getDataList = getApiListFromJson(body);

      return getDataList;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Map?> getListDataById(int id) async {
    final url = '${ApiUrls.getList}/$id';
    log("Url : $url");

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    print("BodyData : $body");

    final Map getDataListById = jsonDecode(body);
    return getDataListById;
  }
}
