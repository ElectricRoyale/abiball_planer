import 'dart:ui' as ui;

import 'package:abiball_planer/core/route/cards/info_dialog.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatelessWidget {
  Statistics(this.documents, {super.key});

  final List<TicketDocument> documents;

  final List<GridItem> gridItems = [];

  final List<Color> gradientColors = [
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
  ];
  final List<Color> palletColors = [
    const Color.fromARGB(255, 241, 73, 0),
    const Color.fromARGB(255, 255, 215, 0),
    Colors.lightGreen,
  ];

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);
  final List<double> stops = <double>[0.4, 0.7, 1.0];

  List<RadialBarSeries<StatisticData, String>> _getRadialBarGradientSeries() =>
      <RadialBarSeries<StatisticData, String>>[
        RadialBarSeries<StatisticData, String>(
            maximumValue: 728,
            dataSource: <StatisticData>[
              StatisticData('Karten', soldCards(documents)),
            ],
            cornerStyle: CornerStyle.bothCurve,
            gap: '0%',
            innerRadius: '75%',
            radius: '105%',
            animationDuration: 700,
            trackColor: Colors.white,
            xValueMapper: (StatisticData data, _) => data.x,
            yValueMapper: (StatisticData data, _) => data.y,
            dataLabelMapper: (StatisticData data, _) => data.x),
        RadialBarSeries<StatisticData, String>(
            maximumValue: 728,
            dataSource: <StatisticData>[
              StatisticData('Hard Cards', hardCards(documents)),
            ],
            cornerStyle: CornerStyle.bothCurve,
            gap: '0%',
            innerRadius: '75%',
            radius: '75%',
            animationDuration: 700,
            trackColor: Colors.white,
            xValueMapper: (StatisticData data, _) => data.x,
            yValueMapper: (StatisticData data, _) => data.y,
            dataLabelMapper: (StatisticData data, _) => data.x),
      ];

  List<RadialBarSeries<StatisticData, String>> _getMoneySeries() =>
      <RadialBarSeries<StatisticData, String>>[
        RadialBarSeries<StatisticData, String>(
            maximumValue: minMoney(soldCards(documents)),
            dataSource: <StatisticData>[
              StatisticData('Money', money(documents)),
            ],
            cornerStyle: CornerStyle.bothCurve,
            gap: '0%',
            innerRadius: '75%',
            radius: '105%',
            animationDuration: 700,
            trackColor: Colors.white,
            xValueMapper: (StatisticData data, _) => data.x,
            yValueMapper: (StatisticData data, _) => data.y,
            dataLabelMapper: (StatisticData data, _) => data.x)
      ];

  List<PieSeries<StatisticData, String>> _getPieSeries() => [
        PieSeries<StatisticData, String>(
          dataSource: <StatisticData>[
            StatisticData(
              'meat',
              meatAmount(documents),
            ),
            StatisticData(
              'vegetarian',
              vegetarianAmount(documents),
            ),
            StatisticData(
              'vegan',
              veganAmount(documents),
            ),
          ],
          radius: '105%',
          animationDuration: 700,
          xValueMapper: (StatisticData data, _) => data.x,
          yValueMapper: (StatisticData data, _) => data.y,
          enableTooltip: false,
        )
      ];

  void setStatisticData() {
    gridItems.clear();
    gridItems.addAll([
      GridItem(
        'Geld:',
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ausgaben: ',
                    textScaler: TextScaler.linear(0.9),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    intl.NumberFormat.currency(locale: 'eu', symbol: '€')
                        .format(minMoney(soldCards(documents))),
                    textScaler: const TextScaler.linear(0.9),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Einnahmen: ',
                    textScaler: TextScaler.linear(0.9),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    intl.NumberFormat.currency(locale: 'eu', symbol: '€')
                        .format(money(documents)),
                    style: TextStyle(
                        color:
                            money(documents) >= minMoney(soldCards(documents))
                                ? Colors.green
                                : Colors.red),
                    textScaler: const TextScaler.linear(0.9),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Differenz: ',
                    textScaler: TextScaler.linear(0.9),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${(money(documents) - minMoney(soldCards(documents))) > 0 ? "+" : ""}${intl.NumberFormat.currency(locale: 'eu', symbol: '€', decimalDigits: 0).format(money(documents) - minMoney(soldCards(documents)))}',
                    style: TextStyle(
                        color:
                            money(documents) >= minMoney(soldCards(documents))
                                ? const Color.fromARGB(255, 151, 255, 0)
                                : Colors.red),
                    textScaler: const TextScaler.linear(0.9),
                  ),
                ],
              ),
            ]),
        _getMoneySeries(),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
              height: '159%',
              width: '159%',
              widget: PhysicalModel(
                shape: BoxShape.circle,
                elevation: 3,
                color: Colors.white,
                child: Container(),
              )),
          CircularChartAnnotation(
            widget: Text(
              '${((money(documents) / minMoney(soldCards(documents))) * 100).round()}%',
              textScaler: const TextScaler.linear(1.1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
        palette: [
          money(documents) >= minMoney(soldCards(documents))
              ? Colors.green
              : Colors.red
        ],
      ),
      GridItem(
        'Karten:',
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Insgesamt: ',
                    textScaler: TextScaler.linear(0.9),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    soldCards(documents).toString(),
                    style: TextStyle(
                        color: soldCards(documents) <= 599
                            ? const Color.fromARGB(255, 122, 227, 0)
                            : (soldCards(documents) > 599 &&
                                    soldCards(documents) < 728)
                                ? Colors.orange
                                : Colors.red),
                    textScaler: const TextScaler.linear(0.9),
                  ),
                  const Text(
                    '/728',
                    textScaler: TextScaler.linear(0.9),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                'Hartkarten: ${hardCards(documents)}',
                textScaler: const TextScaler.linear(0.9),
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            ]),
        _getRadialBarGradientSeries(),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
              height: '115%',
              width: '115%',
              widget: PhysicalModel(
                shape: BoxShape.circle,
                elevation: 0,
                color: Colors.white,
                child: Container(),
              )),
          CircularChartAnnotation(
            widget: Text(
              '${((soldCards(documents) / 728) * 100).round()}%',
              textScaler: TextScaler.linear(
                  soldCards(documents).toString().length < 3 ? 1.0 : 0.9),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
        shader: (ChartShaderDetails chartShaderDetails) => ui.Gradient.sweep(
          chartShaderDetails.outerRect.center,
          gradientColors,
          stops,
          TileMode.clamp,
          _degreeToRadian(0),
          _degreeToRadian(360),
          _resolveTransform(chartShaderDetails.outerRect, TextDirection.ltr),
        ),
      ),
      GridItem(
        'Essen:',
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fleisch: ${meatAmount(documents)}',
                textScaler: const TextScaler.linear(0.9),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                'Vegetarisch: ${vegetarianAmount(documents)}',
                textScaler: const TextScaler.linear(0.9),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                'Vegan: ${veganAmount(documents)}',
                textScaler: const TextScaler.linear(0.9),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ]),
        _getPieSeries(),
        palette: palletColors,
      ),
    ]);
  }

  Widget infoDialog(BuildContext context) => Dialog(
    clipBehavior: Clip.hardEdge,
    shape:
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15,
        vertical: MediaQuery.of(context).size.height * 0.1),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900.0, maxHeight: 650.0),
      child: InfoDialog(documents),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.18,
      width: MediaQuery.sizeOf(context).width,
      constraints: const BoxConstraints(maxHeight: 150),
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.03, horizontal: 20.0),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.003),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color(0xFF237FEA),
          Colors.blue,
          Color(0xFF237FEA),
        ], stops: [
          0.0,
          0.33,
          1.0
        ]),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 4,
              spreadRadius: 0,
              color: Colors.blue)
        ],
      ),
      child: Builder(builder: (context) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.16,
            margin: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).width * 0.01,
                right: MediaQuery.sizeOf(context).width * 0.00),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Display all important Ticket data:',
                  textScaler: TextScaler.linear(1.3),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.08,
                  child: TextButton(
                      onPressed: () => showDialog(context: context, builder: (context) => infoDialog(context)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the border radius as needed
                          ),
                        ),
                      ),
                      child: const Text(
                        'Display',
                        style: TextStyle(color: Color(0xFF237FEA)),
                      )),
                )
              ],
            ),
          ),
          ...gridItems.map(
            (item) => Container(
              width: ui.Size.fromWidth(MediaQuery.sizeOf(context).width * 0.19)
                  .width,
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).height * 0.01),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(16.0),
              ),
              //constraints: const BoxConstraints(maxWidth: 300.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: double.infinity,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                item.topic,
                                textScaler: const TextScaler.linear(1.25),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(flex: 4, child: item.stats),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 114.0),
                        child: SfCircularChart(
                          annotations: item.annotations,
                          onCreateShader: item.shader,
                          palette: item.palette,
                          series: item.series,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ]);
      }),
    );
  }
}
