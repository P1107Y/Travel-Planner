import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'cur_live_FwKPClkoEHLCHjTgDzSUnuR0TYv3SZn4Qs3m8PTN';
const converterURL = 'https://api.currencyapi.com';

class CurrencyConverter {
  Future<dynamic> getData(Uri url) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCurrencyExchangeRates() async {
    Uri url = Uri.parse('$converterURL/v3/latest?apikey=$apiKey');
    var currencyData = await getData(url);
    return currencyData;
  }
}
