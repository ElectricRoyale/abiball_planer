import 'dart:ui' as ui;

import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;

import '../../utils/utils.dart';
import 'allergens_widget.dart';

class InfoDialog extends StatelessWidget {
  InfoDialog(this.documents, {super.key}){
    for (var element in documents) {
      if (element.allergies != null) {
        List personAllergies = element.allergies!.split(';');
        for (var element in personAllergies) {
          if (element.isNotEmpty) {
            int amount = int.parse(element.toString().split(',')[0].trim());
            String allergenType = element.toString().split(',')[1].trim();
            try {
              allergens
                  .firstWhere((item) => item.allergenType == allergenType).amount += amount;
            } catch (_) {
              allergens.add(Allergy(amount, allergenType));
            }
          }
        }
      }
    }
  }

  final List <Allergy> allergens = [];
  final List <TicketDocument> documents;

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
  final List<double> stops = <double>[0.4, 0.7, 1.0];

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Übersicht'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.018),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SfCircularChart(
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                                height: '150%',
                                width: '150%',
                                widget: PhysicalModel(
                                  shape: BoxShape.circle,
                                  elevation: 10,
                                  color: const Color.fromRGBO(230, 230, 230, 1),
                                  child: Container(),
                                )),
                            CircularChartAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Geld:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    'Ausgaben: ${intl.NumberFormat.currency(locale: 'eu', symbol: '€')
                                        .format(minMoney(soldCards(documents)))}',
                                    textScaler: const TextScaler.linear(0.8),
                                  ),
                                  Text(
                                    'Einnahmen: ${intl.NumberFormat.currency(locale: 'eu', symbol: '€')
                                        .format(money(documents))}',
                                    textScaler: const TextScaler.linear(0.8),
                                  ),
                                  Text(
                                    'Differenz: ${(money(documents) - minMoney(soldCards(documents))) > 0 ? "+" : ""}${intl.NumberFormat.currency(locale: 'eu', symbol: '€', decimalDigits: 0).format(money(documents) - minMoney(soldCards(documents)))}',
                                    textScaler: const TextScaler.linear(0.8),
                                  )
                                ],
                              ),
                            )
                          ],
                          onCreateShader:
                              (ChartShaderDetails chartShaderDetails) =>
                              ui.Gradient.sweep(
                                chartShaderDetails.outerRect.center,
                                gradientColors,
                                stops,
                                TileMode.clamp,
                                _degreeToRadian(0),
                                _degreeToRadian(360),
                                _resolveTransform(chartShaderDetails.outerRect,
                                    TextDirection.ltr),
                              ),
                          series: _getMoneySeries(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SfCircularChart(
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                                height: '150%',
                                width: '150%',
                                widget: PhysicalModel(
                                  shape: BoxShape.circle,
                                  elevation: 10,
                                  color: const Color.fromRGBO(230, 230, 230, 1),
                                  child: Container(),
                                )),
                            CircularChartAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Karten:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    'Gesamt: ${soldCards(documents)}/728',
                                    textScaler: const TextScaler.linear(0.8),
                                  ),
                                  Text(
                                    'Hartkarten: ${hardCards(documents)}',
                                    textScaler: const TextScaler.linear(0.8),
                                  )
                                ],
                              ),
                            )
                          ],
                          onCreateShader:
                              (ChartShaderDetails chartShaderDetails) =>
                              ui.Gradient.sweep(
                                chartShaderDetails.outerRect.center,
                                gradientColors,
                                stops,
                                TileMode.clamp,
                                _degreeToRadian(0),
                                _degreeToRadian(360),
                                _resolveTransform(chartShaderDetails.outerRect,
                                    TextDirection.ltr),
                              ),
                          series: _getRadialBarGradientSeries(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SfCircularChart(
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                            height: '150%',
                            width: '150%',
                            widget: PhysicalModel(
                              shape: BoxShape.circle,
                              elevation: 10,
                              color: const Color.fromRGBO(230, 230, 230, 1),
                              child: Container(),
                            )),
                        CircularChartAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Essen:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                'Fleisch: ${meatAmount(documents)}',
                                textScaler: const TextScaler.linear(0.8),
                              ),
                              Text(
                                'Vegetarisch: ${vegetarianAmount(documents)}',
                                textScaler: const TextScaler.linear(0.8),
                              ),
                              Text(
                                'Vegan: ${veganAmount(documents)}',
                                textScaler: const TextScaler.linear(0.8),
                              ),
                            ],
                          ),
                        )
                      ],
                      palette: palletColors,
                      series: _getPieSeries(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: Text(
                        'Allergene:',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(14.0),
                              color: const Color.fromARGB(255, 240, 240, 240)),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 215, 215, 215),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(255, 160, 160, 160),
                                          blurRadius: 4,
                                          blurStyle: BlurStyle.solid,
                                          offset: Offset(0.0, 0.1),
                                          spreadRadius: 1),
                                    ],
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(),
                                        ),
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Anzahl',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(),
                                        ),
                                        const Expanded(
                                          flex: 36,
                                          child: Text('Allergie',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 16,
                                child: ListView.separated(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 5, bottom: 10.0),
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 3.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: Text(
                                                '${index + 1}.',
                                                textAlign: TextAlign.center,
                                              )),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              allergens
                                                  .elementAt(index).amount
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(),
                                          ),
                                          Expanded(
                                            flex: 36,
                                            child: Text(
                                              allergens
                                                  .elementAt(index).allergenType,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                    const Divider(
                                      color: Colors.black,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                    itemCount: allergens.length),
                              ),
                            ],
                          ),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
