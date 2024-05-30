import 'dart:ui';

import 'package:abiball_planer/core/managment/managerProvider.dart';
import 'package:abiball_planer/core/route/cards/add_dialog.dart';
import 'package:abiball_planer/core/route/cards/edit_dialog.dart';
import 'package:abiball_planer/core/route/cards/statistics.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/service/web_socket_service.dart';
import 'package:abiball_planer/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardsOverview extends StatelessWidget {
  const CardsOverview(this.focusNode, {super.key});

  final FocusNode focusNode;

  Widget addDialog(BuildContext context) => Dialog(
    clipBehavior: Clip.hardEdge,
    shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15,
        vertical: MediaQuery.of(context).size.height * 0.1),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900.0, maxHeight: 650.0),
      child: AddDialogLayout(
            soldCards(ManagerProvider.of(context).tickets),
          ),
    ),
  );

  Widget editDialog(BuildContext context, int index) => Dialog(
    clipBehavior: Clip.hardEdge,
    shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
            vertical: MediaQuery.of(context).size.height * 0.1),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900.0, maxHeight: 650.0),
      child: EditDialogLayout(
            soldCards(ManagerProvider.of(context).viewTickets),
            ManagerProvider.of(context).viewTickets.elementAt(index),
          ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Statistics(
            ManagerProvider.of(context).tickets,
          )..setStatisticData(),
          Expanded(
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.keyN, control: true):
                    () => showDialog(
                        context: context,
                        builder: (builder) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: addDialog(context))).then(
                        (value) => focusNode.requestFocus()),
                const SingleActivator(LogicalKeyboardKey.f5): () =>
                    RealtimeDataService().getVisitors(),
              },
              child: Focus(
                focusNode: focusNode..requestFocus(),
                autofocus: true,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 4, spreadRadius: -1, color: Colors.grey)
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade300))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: InkWell(
                                  onTap: () {
                                    String direction =
                                        ManagerProvider.of(context).direction;
                                    if (ManagerProvider.of(context).sortBy !=
                                            'firstname' &&
                                        ManagerProvider.of(context).sortBy !=
                                            'lastname') {
                                      direction = 'asc';
                                    }
                                    if (ManagerProvider.of(context).sortBy ==
                                        'lastname') {
                                      direction = ManagerProvider.of(context)
                                                  .direction ==
                                              'asc'
                                          ? 'desc'
                                          : 'asc';
                                    }
                                    ManagerProvider.of(context).sort(
                                        ManagerProvider.of(context).sortBy ==
                                                'firstname'
                                            ? 'lastname'
                                            : 'firstname',
                                        direction);
                                  },
                                  child: Row(
                                    children: [
                                      const Text('Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      ManagerProvider.of(context).sortBy ==
                                                  'firstname' ||
                                              ManagerProvider.of(context)
                                                      .sortBy ==
                                                  'lastname'
                                          ? Icon(
                                              ManagerProvider.of(context)
                                                          .direction ==
                                                      'asc'
                                                  ? Icons
                                                      .keyboard_arrow_down_rounded
                                                  : Icons
                                                      .keyboard_arrow_up_rounded,
                                              color: Colors.black,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: InkWell(
                                  onTap: () {
                                    ManagerProvider.of(context).sort(
                                        'neighbourWish',
                                        ManagerProvider.of(context).direction ==
                                                    'asc' &&
                                                ManagerProvider.of(context)
                                                        .sortBy ==
                                                    'neighbourWish'
                                            ? 'desc'
                                            : 'asc');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Sitznachbar wunsch',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      ManagerProvider.of(context).sortBy ==
                                              'neighbourWish'
                                          ? Icon(
                                              ManagerProvider.of(context)
                                                          .direction ==
                                                      'asc'
                                                  ? Icons
                                                      .keyboard_arrow_down_rounded
                                                  : Icons
                                                      .keyboard_arrow_up_rounded,
                                              color: Colors.black,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    ManagerProvider.of(context).sort(
                                        'placeNumber',
                                        ManagerProvider.of(context).direction ==
                                                    'asc' &&
                                                ManagerProvider.of(context)
                                                        .sortBy ==
                                                    'placeNumber'
                                            ? 'desc'
                                            : 'asc');
                                  },
                                  child: Row(
                                    //mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Sitzplatz',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Flexible(
                                        child: ManagerProvider.of(context)
                                                    .sortBy ==
                                                'placeNumber'
                                            ? Icon(
                                                ManagerProvider.of(context)
                                                            .direction ==
                                                        'asc'
                                                    ? Icons
                                                        .keyboard_arrow_down_rounded
                                                    : Icons
                                                        .keyboard_arrow_up_rounded,
                                                color: Colors.black,
                                              )
                                            : Container(
                                                width: 0,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {
                                    ManagerProvider.of(context).sort(
                                        'cards',
                                        ManagerProvider.of(context).direction ==
                                                    'asc' &&
                                                ManagerProvider.of(context)
                                                        .sortBy ==
                                                    'cards'
                                            ? 'desc'
                                            : 'asc');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Hart-/Karten',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis),
                                      ManagerProvider.of(context).sortBy ==
                                              'cards'
                                          ? Icon(
                                              ManagerProvider.of(context)
                                                          .direction ==
                                                      'asc'
                                                  ? Icons
                                                      .keyboard_arrow_down_rounded
                                                  : Icons
                                                      .keyboard_arrow_up_rounded,
                                              color: Colors.black,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(''),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {
                                    ManagerProvider.of(context).sort(
                                        'payed',
                                        ManagerProvider.of(context).direction ==
                                                    'asc' &&
                                                ManagerProvider.of(context)
                                                        .sortBy ==
                                                    'payed'
                                            ? 'desc'
                                            : 'asc');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        ManagerProvider.of(context).direction ==
                                                'asc'
                                            ? Icons.keyboard_arrow_down_rounded
                                            : Icons.keyboard_arrow_up_rounded,
                                        color: ManagerProvider.of(context)
                                                    .sortBy ==
                                                'payed'
                                            ? Colors.black
                                            : Colors.transparent,
                                      ),
                                      const Text('Bezahlt',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ManagerProvider.of(context)
                                .viewTickets
                                .isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                itemBuilder: (context, index) {
                                  LayerLink layerLink = LayerLink();
                                  return CompositedTransformTarget(
                                    link: layerLink,
                                    child: GestureDetector(
                                      onSecondaryTap: () =>
                                          deleteItem(context, layerLink, () {
                                        RealtimeDataService().deleteVisitor(
                                            ManagerProvider.of(context)
                                                .viewTickets
                                                .elementAt(index)
                                                .conditions);
                                      }),
                                      onLongPress: () =>
                                          deleteItem(context, layerLink, () {
                                        RealtimeDataService().deleteVisitor(
                                            ManagerProvider.of(context)
                                                .viewTickets
                                                .elementAt(index)
                                                .getDocumentMap());
                                      }),
                                      onTap: () => showDialog(
                                          context: context,
                                          builder: (builder) =>
                                              editDialog(context, index)),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${index + 1}.',
                                                    textScaler:
                                                        const TextScaler.linear(
                                                            1.15),
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        ManagerProvider.of(
                                                                context)
                                                            .viewTickets
                                                            .elementAt(index)
                                                            .toString(),
                                                        textScaler:
                                                            const TextScaler
                                                                .linear(1.15),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        ManagerProvider.of(
                                                                context)
                                                            .viewTickets
                                                            .elementAt(index)
                                                            .email,
                                                        textScaler:
                                                            const TextScaler
                                                                .linear(0.85),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Text(
                                                  ManagerProvider.of(context)
                                                          .viewTickets
                                                          .elementAt(index)
                                                          .neighbourWish ??
                                                      '--',
                                                  textScaler:
                                                      const TextScaler.linear(
                                                          1.05),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Text(
                                                  ManagerProvider.of(context)
                                                          .viewTickets
                                                          .elementAt(index)
                                                          .placeNumber ??
                                                      '--',
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                      const TextScaler.linear(
                                                          1.05),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Text(
                                                  '${ManagerProvider.of(context).viewTickets.elementAt(index).numberOfHardCards}/${ManagerProvider.of(context).tickets.elementAt(index).numberOfTickets}',
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                      const TextScaler.linear(
                                                          1.05),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: OutlinedButton(
                                                  onPressed: ManagerProvider.of(
                                                              context)
                                                          .viewTickets
                                                          .elementAt(index)
                                                          .payed
                                                      ? () {}
                                                      : null,
                                                  style: OutlinedButton.styleFrom(
                                                      side: BorderSide(
                                                          color: ManagerProvider
                                                                      .of(
                                                                          context)
                                                                  .viewTickets
                                                                  .elementAt(
                                                                      index)
                                                                  .payed
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .disabledColor)),
                                                  child: const Text(
                                                    'Resend',
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                        TextScaler.linear(1.05),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Checkbox(
                                                    value: ManagerProvider.of(
                                                            context)
                                                        .viewTickets
                                                        .elementAt(index)
                                                        .payed,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    onChanged: (payed) {
                                                      TicketDocument document =
                                                          ManagerProvider.of(
                                                                  context)
                                                              .viewTickets
                                                              .elementAt(index);
                                                      document.payed =
                                                          !document.payed;
                                                      document.money = document
                                                              .payed
                                                          ? 39.0 *
                                                              document
                                                                  .numberOfTickets
                                                          : 0.0;
                                                      RealtimeDataService()
                                                          .updateVisitor(
                                                              document
                                                                  .getDocumentMap(),
                                                              document
                                                                  .conditions);
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      indent: 30.0,
                                      endIndent: 20.0,
                                      height: 3.5,
                                    ),
                                itemCount: ManagerProvider.of(context)
                                    .viewTickets
                                    .length)
                            : const Center(
                                child: Text('No cards are sold yet!'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
