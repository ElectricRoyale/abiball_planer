import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void searchCallback(String search) {}

void deleteItem(
    BuildContext context, LayerLink layerLink, VoidCallback onDelete) {
  Color textColor = Colors.red;

  RenderSliverList renderSliverList =
      context.findRenderObject() as RenderSliverList;
  double height = renderSliverList.firstChild!.size.height * 0.5;
  double width = renderSliverList.firstChild!.size.width * 0.15;

  OverlayEntry deleteOverlay = OverlayEntry(builder: (context) => Container());

  deleteOverlay = OverlayEntry(
    builder: (context) => Stack(
      children: [
        ModalBarrier(
          onDismiss: () => deleteOverlay.remove(),
        ),
        Positioned(
          width: width,
          height: height * 2.5,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(width * 0.15, height),
            child: Card(
                surfaceTintColor: Colors.white,
                clipBehavior: Clip.antiAlias,
                elevation: 7,
                child: InkWell(
                  onTap: () {
                    deleteOverlay.remove();
                    deleteOverlay.dispose();
                    onDelete.call();
                  },
                  child: Row(
                    children: [
                      const Expanded(
                          child: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: textColor),
                          ))
                    ],
                  ),
                )),
          ),
        )
      ],
    ),
  );
  Overlay.of(context).insert(deleteOverlay);
}

int soldCards(List<TicketDocument> documents) {
  int sold = 0;
  if (documents.isNotEmpty) {
    for (var document in documents) {
      sold += document.numberOfTickets;
    }
  }
  return sold;
}

double minMoney(int soldCards) {
  return 8933.93 + 24.50 * soldCards - 4000;
}

double money(List<TicketDocument> documents) {
  double money = 0;
  if (documents.isNotEmpty) {
    for (var document in documents) {
      money += document.money;
    }
  }
  return money;
}

int hardCards(List<TicketDocument> documents) {
  int hardCards = 0;
  if (documents.isNotEmpty) {
    for (var document in documents) {
      hardCards += document.numberOfHardCards;
    }
  }
  return hardCards;
}

int meatAmount(List<TicketDocument> documents) {
  int amount = 0;
  if (documents.isNotEmpty) {
    for (var document in documents) {
      amount += document.meat;
    }
  }
  return amount;
}

int vegetarianAmount(List<TicketDocument> documents) {
  int amount = 0;
  if (documents.isNotEmpty) {
    for (var document in documents) {
      amount += document.vegetarian;
    }
  }
  return amount;
}

int veganAmount(List<TicketDocument> documents) {
  int amount = 0;
  if (documents.isNotEmpty) {
    for (var document in documents) {
      amount += document.vegan;
    }
  }
  return amount;
}

class GridItem {
  final Shader Function(ChartShaderDetails)? shader;
  final String topic;
  final Widget stats;
  final List<CircularSeries> series;
  final List<Color>? palette;
  final List<CircularChartAnnotation>? annotations;

  GridItem(this.topic, this.stats, this.series,
      {this.shader, this.palette, this.annotations});
}

class StatisticData {
  StatisticData(this.x, this.y, {this.text});

  final String? text;
  final String x;
  final num y;
}
