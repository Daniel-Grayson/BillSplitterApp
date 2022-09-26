import 'package:flutter/material.dart';
import 'package:main_footer_3/util/hexcolor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn =
        'https://2cf1dfb436be46ff9a729f065cd86427@o1417946.ingest.sentry.io/6760779';
    options.tracesSampleRate = 1.0;
  }, appRunner: () => runApp(const BillSplitter()));
}

class BillSplitter extends StatefulWidget {
  const BillSplitter({Key? key}) : super(key: key);

  @override
  State<BillSplitter> createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;

  Color _purple = HexColor("#6908D6");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Bill Splitter",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          alignment: Alignment.center,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.vertical,
            // padding: const EdgeInsets.only(top: 80.5, left: 20.5, right: 20.5),
            padding: const EdgeInsets.all(20.5),
            children: [
              Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                    color: _purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.5)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Per Person",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                            color: _purple),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                            "\$ ${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 34.9,
                                color: _purple)),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 250,
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.5),
                    border: Border.all(
                        width: 2,
                        color: Colors.blueGrey,
                        style: BorderStyle.solid)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: TextStyle(color: _purple),
                        decoration: const InputDecoration(
                            prefixText: "Bill Amount",
                            prefixIcon: Icon(Icons.monetization_on_outlined)),
                        onChanged: (String value) {
                          try {
                            _billAmount = double.parse(value);
                          } catch (e) {
                            _billAmount = 0.0;
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Split",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_personCounter > 1) {
                                      _personCounter--;
                                    } else {
                                      // do nothing

                                    }
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: _purple.withOpacity(0.1)),
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: _purple),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "$_personCounter",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: _purple),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _personCounter++;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: _purple.withOpacity(0.1)),
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: _purple),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tip",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "\$ ${(calculateTotalTip(_billAmount, _personCounter, _tipPercentage)).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: _purple,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "$_tipPercentage%",
                            style: TextStyle(
                                color: _purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                          Slider(
                              min: 0,
                              max: 100,
                              divisions: 10,
                              activeColor: _purple,
                              inactiveColor: Colors.grey,
                              value: _tipPercentage.toDouble(),
                              onChanged: (double value) {
                                setState(() {
                                  _tipPercentage = value.round();
                                });
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  calculateTotalPerPerson(double billAmount, int splitBy, int tipPercentage) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, splitBy, tipPercentage) + billAmount) /
            splitBy;

    return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPercentage) {
    double totalTip = 0.0;

    if (billAmount < 0 || billAmount.toString().isEmpty) {
      // do nothing
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }
    return totalTip;
  }
}
