import 'dart:ui' as ui;

import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'cards_overview.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InfoDialogLayout extends StatefulWidget {
  final List<TicketDocument> allData;

  const InfoDialogLayout(this.allData, {super.key});

  @override
  State createState() {
    return _InfoDialogLayoutState();
  }
}

class _InfoDialogLayoutState extends State<InfoDialogLayout> {
  List<Map> allergeneList = [];
  List<Color> gradientColors = [
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
  ];
  List<Color> palletColors = [
    const Color.fromARGB(255, 241, 73, 0),
    const Color.fromARGB(255, 255, 215, 0),
    Colors.lightGreen,
  ];
  List<double> stops = <double>[0.4, 0.7, 1.0];

  void closeDialog() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    setState(() {
      allergeneList = allergene();
    });
    super.initState();
  }

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
        /*elevation: 2,
        shadowColor: Colors.grey,*/
        centerTitle: true,
        automaticallyImplyLeading: false,
        //backgroundColor: const Color.fromARGB(255, 230, 255, 230),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    'Karten:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    'Gesamt: ${soldCards()}/728',
                                    textScaler: const TextScaler.linear(0.8),
                                  ),
                                  Text(
                                    'Hartkarten: ${hardCards()}',
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
                        SfCircularChart(
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
                          series: _getRadialBarGradientSeriesHardCards(),
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
                                'Fleisch: ${meatAmount()}',
                                textScaler: const TextScaler.linear(0.8),
                              ),
                              Text(
                                'Vegetarisch: ${vegetarianAmount()}',
                                textScaler: const TextScaler.linear(0.8),
                              ),
                              Text(
                                'Vegan: ${veganAmount()}',
                                textScaler: const TextScaler.linear(0.8),
                              ),
                            ],
                          ),
                        )
                      ],
                      palette: palletColors,
                      series: _getDoughnutSeries(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
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
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(14.0),
                          color: const Color.fromARGB(255, 240, 240, 240)),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.31,
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
                                              allergeneList
                                                  .elementAt(index)['Anzahl']
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
                                              allergeneList
                                                  .elementAt(index)['Allergie']
                                                  .toString(),
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
                                itemCount: allergeneList.length),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DoughnutSeries<ChartSampleData, String>> _getDoughnutSeries() {
    return [
      DoughnutSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData('meat', meatAmount(),
              '${((meatAmount() / soldCards() / 10 + 1) * 100).round()}%'),
          ChartSampleData('vegetarian', vegetarianAmount(),
              '${((vegetarianAmount() / soldCards() / 10 + 1) * 100).round()}%'),
          ChartSampleData('vegan', veganAmount(),
              '${((veganAmount() / soldCards() / 10 + 1) * 100).round()}%'),
        ],
        innerRadius: '75%',
        radius: '100%',
        animationDuration: 700,
        pointRadiusMapper: (data, _) => data.text,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        enableTooltip: false,
      )
    ];
  }

  List<RadialBarSeries<ChartShaderData, String>> _getRadialBarGradientSeries() {
    return <RadialBarSeries<ChartShaderData, String>>[
      RadialBarSeries<ChartShaderData, String>(
          maximumValue: 728,
          dataSource: <ChartShaderData>[
            ChartShaderData('Karten', soldCards()),
          ],
          cornerStyle: CornerStyle.bothCurve,
          gap: '0%',
          innerRadius: '75%',
          radius: '100%',
          animationDuration: 700,
          xValueMapper: (ChartShaderData data, _) => data.x,
          yValueMapper: (ChartShaderData data, _) => data.y,
          dataLabelMapper: (ChartShaderData data, _) => data.x)
    ];
  }

  List<RadialBarSeries<ChartShaderData, String>>
      _getRadialBarGradientSeriesHardCards() {
    return <RadialBarSeries<ChartShaderData, String>>[
      RadialBarSeries<ChartShaderData, String>(
          maximumValue: soldCards().toDouble(),
          dataSource: <ChartShaderData>[
            ChartShaderData('Hartarten', hardCards()),
          ],
          cornerStyle: CornerStyle.bothCurve,
          gap: '0%',
          innerRadius: '95%',
          radius: '109%',
          enableTooltip: false,
          animationDuration: 700,
          xValueMapper: (ChartShaderData data, _) => data.x,
          yValueMapper: (ChartShaderData data, _) => data.y,
          dataLabelMapper: (ChartShaderData data, _) => data.x)
    ];
  }

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

  int soldCards() {
    int sold = 0;
    for (var element in widget.allData) {
      sold += element.numberOfTickets;
    }
    return sold;
  }

  int hardCards() {
    int hardCards = 0;
    for (var element in widget.allData) {
      hardCards += element.numberOfHardcards;
    }
    return hardCards;
  }

  int meatAmount() {
    int amount = 0;
    for (var data in widget.allData) {
      amount += data.tierisch;
    }
    return amount;
  }

  int vegetarianAmount() {
    int amount = 0;
    for (var data in widget.allData) {
      amount += data.vegetarisch;
    }
    return amount;
  }

  int veganAmount() {
    int amount = 0;
    for (var data in widget.allData) {
      amount += data.vegan;
    }
    return amount;
  }

  List<Map> allergene() {
    List<Map> allergie = [];
    for (var element in widget.allData) {
      if (element.allergies != 'Keine') {
        List personAllergie = element.allergies.split(';');
        for (var element in personAllergie) {
          if (element.isNotEmpty) {
            int amount = int.parse(element.toString().split(',')[0].trim());
            String allergietype = element.toString().split(',')[1].trim();
            try {
              allergie
                  .firstWhere((item) => item['Allergie'] == allergietype)
                  .update('Anzahl', (value) => value += amount);
            } catch (_) {
              allergie.add({
                'Anzahl': amount,
                'Allergie': allergietype,
              });
            }
          }
        }
      }
    }
    return allergie;
  }
}
