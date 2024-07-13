import 'package:abiball_planer/core/managment/managerProviderEmail.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/utils/searchfield.dart';
import 'package:flutter/material.dart';

class EmailView extends StatefulWidget {
  const EmailView(this.focusNode, {super.key});

  final FocusNode focusNode;

  @override
  State createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  GlobalKey<AutoCompleteTextFieldState<TicketDocument>> key =
      GlobalKey<AutoCompleteTextFieldState<TicketDocument>>();
  FocusNode focusNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Inboxing',
                            style: TextStyle(fontWeight: FontWeight.w600),
                            textScaler: TextScaler.linear(1.5),
                          ),
                          DropdownButtonHideUnderline(child: DropdownButton(
                            items: const [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text('All'),
                              ),
                              DropdownMenuItem(
                                value: 'unread',
                                child: Text('Unread'),
                              ),
                              DropdownMenuItem(
                                value: 'read',
                                child: Text('Read'),
                              ),
                            ],
                            onChanged: (value) {
                              //ManagerProviderEmail.of(context).filterMails(value);
                            },
                          )),
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
                                    /*Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Checkbox(
                                            value: ManagerProviderEmail.of(context).viewMails.elementAt(index).payed,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            onChanged: (selected) {}),
                                      ),
                                    ),*/
                                    Expanded(
                                      flex: 7,
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ManagerProviderEmail.of(context)
                                                    .viewMails
                                                    .elementAt(index)
                                                    .from!
                                                    .join(', '),
                                                textScaler:
                                                    const TextScaler.linear(
                                                        1.15),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                ManagerProviderEmail.of(context)
                                                    .viewMails
                                                    .elementAt(index)
                                                    .decodeTextHtmlPart()!,
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
                                          ManagerProviderEmail.of(context)
                                              .viewMails
                                              .elementAt(index)
                                              .decodeDate()
                                              .toString(),
                                          textScaler:
                                              const TextScaler.linear(1.05),
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
                        itemCount:
                            ManagerProviderEmail.of(context).viewMails.length),
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
