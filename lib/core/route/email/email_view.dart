import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/utils/searchfield.dart';
import 'package:flutter/material.dart';

class EmailView extends StatefulWidget {
  const EmailView({super.key});

  @override
  State createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  GlobalKey<AutoCompleteTextFieldState<TicketDocument>> key =
      GlobalKey<AutoCompleteTextFieldState<TicketDocument>>();
  FocusNode focusNode = FocusNode();

  List<TicketDocument> items = [
    TicketDocument('Pascal', 'Reinmuth', 'Pascal.Reinmuth@web.de', 7, 2,
        'Schultz', 7, 0, 0, 'Keine', false, '', 273),
    TicketDocument('Paulina', 'Schultz', 'Paulina.Schultz@t-online.de', 5, 1,
        'Reinmuth', 5, 0, 0, 'Keine', false, '', 273),
    TicketDocument('Test', 'Test', 'test.test@web.de', 7, 2, 'Mustermann', 7, 0,
        0, 'Keine', false, '', 273),
    TicketDocument('Max', 'Mustermann', 'Max.Mustermann@web.de', 7, 2, 'test',
        7, 0, 0, 'Keine', false, '', 273),
  ];

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  InputDecoration decoration(bool showSuffix) {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(10.0),
      hintText: 'Search for Email',
      prefixIcon: const Icon(
        Icons.search,
        size: 28,
      ),
      prefixIconColor: Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.125,
            padding:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.01),
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(MediaQuery.sizeOf(context).width * 0.015, 0.0),
                  child: const Text(
                    'Postfach',
                    textScaler: TextScaler.linear(2.0),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.25,
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  margin: EdgeInsets.only(
                      right: MediaQuery.sizeOf(context).width * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 1,
                          blurStyle: BlurStyle.outer)
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AutoCompleteTextField<TicketDocument>(
                    key: key,
                    decoration: decoration(false),
                    onFocusChanged: (focus) =>
                        focus ? null : focusNode.requestFocus(),
                    suggestions: items,
                    unFocusOnItemSubmitted: true,
                    itemSubmitted: (item) {
                      focusNode.requestFocus();
                    },
                    textSubmitted: (item) {
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
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(blurRadius: 4, spreadRadius: -1, color: Colors.grey)
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: InkWell(
                              onTap: () {
                                /* sortNames = true;
                                updateItems();*/
                              },
                              child: const Row(
                                children: [
                                  Text('Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Icon(Icons.keyboard_arrow_down_rounded,
                                      color: Colors
                                          .black /*sortNames
                                        ? Colors.black
                                        : Colors.transparent,*/
                                      ),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 8,
                            child: Text('Sitznachbar wünsche',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Text('Sitzplatz',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Text('Hart-/Karten ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                                updateItems();*/
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.01,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        itemBuilder: (context, index) => GestureDetector(
                              /*onSecondaryTapDown: (position) => this.position =
                                  (Overlay.of(context)
                                          .context
                                          .findRenderObject() as RenderBox)
                                      .localToGlobal(position.globalPosition),
                              onLongPressDown: (position) => this.position =
                                  (Overlay.of(context)
                                          .context
                                          .findRenderObject() as RenderBox)
                                      .localToGlobal(position.globalPosition),
                              onSecondaryTap: () => delete(
                                  entries.elementAt(
                                      entries.indexOf(items.elementAt(index))),
                                  context),
                              onLongPress: () => delete(
                                  entries.elementAt(
                                      entries.indexOf(items.elementAt(index))),
                                  context),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (builder) =>
                                      editDialog(items.elementAt(index))).then(
                                  (value) => value
                                      ? updateItem(items.elementAt(index))
                                      : null),*/
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Checkbox(
                                            value: items.elementAt(index).payed,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            onChanged: (selected) {}),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Row(
                                        children: [
                                          Text(
                                            '${index + 1}.',
                                            textScaler:
                                                const TextScaler.linear(1.15),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items
                                                    .elementAt(index)
                                                    .toString(),
                                                textScaler:
                                                    const TextScaler.linear(
                                                        1.15),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                items.elementAt(index).email,
                                                textScaler:
                                                    const TextScaler.linear(
                                                        0.85),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          items
                                                  .elementAt(index)
                                                  .neighbourWish ??
                                              '--',
                                          textScaler:
                                              const TextScaler.linear(1.05),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          items.elementAt(index).placeNumber ??
                                              '--',
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              const TextScaler.linear(1.05),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          '${items.elementAt(index).numberOfHardCards}/${items.elementAt(index).numberOfTickets}',
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              const TextScaler.linear(1.05),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: items
                                                          .elementAt(index)
                                                          .payed
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .disabledColor)),
                                          child: const Text(
                                            'Resend',
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.linear(1.05),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        separatorBuilder: (context, index) => const Divider(
                              indent: 30.0,
                              endIndent: 20.0,
                              height: 3.5,
                            ),
                        itemCount: items.length),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
