import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  List currencies = await getCurrencies();
  runApp(new MaterialApp(
    home: new Center(
        child: new CryptoListWidget(currencies)
    ),
  ));
}

Future<List> getCurrencies() async {
  String apiUrl = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
  http.Response response = await http.get(apiUrl);
  return JSON.decode(response.body);
}

class CryptoListWidget extends StatelessWidget {

  // The underscore before a variable name marks it as a private variable
  final List<MaterialColor> _colors = [
    Colors.blue, Colors.red, Colors.green, Colors.yellow];

  final List _currencies;

  CryptoListWidget(this._currencies);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.blue,
      floatingActionButton: new Builder(
          builder: (BuildContext context) {
            return new FloatingActionButton(onPressed: () {
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Sending message")));
            },
              child: new Icon(Icons.add_alert),);
          }
      ),
    );
  }

  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 8.0),
      child: new Column(
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget()
        ],
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
        "CryptoCurrencies",
        style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0
        )
    );
  }

  Widget _getListViewWidget() {
    return new Flexible(
        child: new ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (context, index) {
              final Map currency = _currencies[index];
              final MaterialColor color = _colors[index % _colors.length];
              return _getListItemWidget(currency, color);
            })
    );
  }

  Container _getListItemWidget(Map currency, MaterialColor color) {
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(currency, color),
      ),
    );
  }

  ListTile _getListTile(Map currency, MaterialColor color) {
    return new ListTile(
      leading: _getLeadingWidget(currency['name'], color),
      title: _getTitleWidget(currency['name']),
      subtitle: _getSubTitleWidget(
          currency['price_usd'], currency['percent_change_1h']),
      isThreeLine: true,
    );
  }

  Widget _getLeadingWidget(String currenyName, MaterialColor color) {
    return new CircleAvatar(
        backgroundColor: color,
        child: new Text(currenyName[0])
    );
  }

  Text _getTitleWidget(String currencyName) {
    return new Text(
      currencyName,
      style: new TextStyle(
          fontWeight: FontWeight.bold
      ),
    );
  }

  RichText _getSubTitleWidget(String priceUsd, String percentChange1h) {
    TextSpan priceTextWidget = new TextSpan(
        text: "\$$priceUsd\n",
        style: new TextStyle(
            color: Colors.black
        )
    );

    String percentChangeText = "1 hour: $percentChange1h%";
    TextSpan percentChangeTextWidget;

    if (double.parse(percentChange1h) > 0) {
      percentChangeTextWidget = new TextSpan(
          text: percentChangeText,
          style: new TextStyle(
              color: Colors.green
          )
      );
    } else {
      percentChangeTextWidget = new TextSpan(
          text: percentChangeText,
          style: new TextStyle(
              color: Colors.red
          )
      );
    }

    return new RichText(
        text: new TextSpan(
            children: [priceTextWidget, percentChangeTextWidget]
        )
    );
  }

}
