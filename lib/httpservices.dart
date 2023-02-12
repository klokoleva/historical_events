import 'package:http/http.dart' as http;

Future getdataservices(String month, String year) async {
  var url = Uri.http('numbersapi.com', '/$month/$year/date');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Request failed with status: ${response.statusCode}.';
  }
}
