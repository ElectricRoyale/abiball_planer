import 'dart:ui';

import 'package:abiball_planer/core/managment/managerProvider.dart';
import 'package:abiball_planer/core/route/cards/add_dialog.dart';
import 'package:abiball_planer/core/route/cards/edit_dialog.dart';
import 'package:abiball_planer/core/route/cards/statistics.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/service/websocketService.dart';
import 'package:abiball_planer/core/utils/searchfield.dart';
import 'package:abiball_planer/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardsOverview extends StatelessWidget {
  const CardsOverview(this.focusNode, {super.key});

  final FocusNode focusNode;

  InputDecoration decoration(bool showSuffix) {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(7.0),
      hintText: 'Search for Name',
      prefixIcon: const Icon(
        Icons.search,
        size: 28,
      ),
      prefixIconColor: Colors.grey.shade300,
    );
  }

  Widget addDialog(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
            vertical: MediaQuery.of(context).size.height * 0.1),
        child: AddDialogLayout(soldCards(ManagerProvider.of(context).tickets)));
  }

  @override
  Widget build(BuildContext context) {
    RealtimeDataService().context = context;
    return Material(
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.sizeOf(context).height * 0.00),
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(MediaQuery.sizeOf(context).width * 0.015, 0.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi Pascal Reinmuth',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Karten',
                        textScaler: TextScaler.linear(2.0),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.225,
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  margin: EdgeInsets.only(
                      right: MediaQuery.sizeOf(context).width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 0.75)),
                  clipBehavior: Clip.antiAlias,
                  child: AutoCompleteTextField<TicketDocument>(
                    decoration: decoration(false),
                    onFocusChanged: (focus) =>
                        focus ? null : focusNode.requestFocus(),
                    suggestions: ManagerProvider.of(context).tickets,
                    unFocusOnItemSubmitted: true,
                    itemSubmitted: (item) {
                      ManagerProvider.of(context).search(item.toString());
                      focusNode.requestFocus();
                    },
                    textSubmitted: (item) {
                      ManagerProvider.of(context).search(item);
                      focusNode.requestFocus();
                    },
                    clearOnSubmit: false,
                    itemBuilder: (context, document, selected, last) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(document.toString()),
                          selected: selected,
                          selectedColor:
                              Theme.of(context).textTheme.titleLarge!.color,
                          tileColor: Colors.white,
                          selectedTileColor: Colors.grey.shade200,
                        ),
                        !last
                            ? const Divider(
                                height: 0,
                                indent: 15,
                                endIndent: 15,
                              )
                            : Container(),
                      ],
                    ),
                    itemSorter: (a, b) => a.toString().compareTo(b.toString()),
                    itemFilter: (document, option) => document
                        .toString()
                        .toLowerCase()
                        .contains(option.toLowerCase()),
                  ),
                ),
              ],
            ),
          ),
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
                onFocusChange: (t) => print(t),
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
                                    ManagerProvider.of(context).sort(
                                        ManagerProvider.of(context).sortBy ==
                                                'firstname'
                                            ? 'lastname'
                                            : 'firstnames');
                                  },
                                  child: Row(
                                    children: [
                                      const Text('Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: ManagerProvider.of(context)
                                                        .sortBy ==
                                                    'firstname' ||
                                                ManagerProvider.of(context)
                                                        .sortBy ==
                                                    'lastname'
                                            ? Colors.black
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 8,
                                child: Text('Sitznachbar wünsche',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text('Sitzplatz',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text('Hart-/Karten ',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(''),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {
                                    /* sortNames = false;
                                      updateManagerProvider.of(context).tickets();*/
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.01,
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors
                                            .transparent, /*sortNames
                                              ? Colors.transparent
                                              : Colors.black,*/
                                      ),
                                      const Text(
                                        'Bezahlt',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                          builder: (builder) => Dialog(
                                              clipBehavior: Clip.hardEdge,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              insetPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.15,
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.1),
                                              child: EditDialogLayout(
                                                  soldCards(ManagerProvider.of(context).viewTickets),
                                                  ManagerProvider.of(context).viewTickets.elementAt(index)))),
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
