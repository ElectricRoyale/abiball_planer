import 'dart:convert';
import 'dart:ui';

import 'package:abiball_planer/core/mainlayout.dart';
import 'package:abiball_planer/core/managment/managerProvider.dart';
import 'package:abiball_planer/core/route/cards/add_dialog.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RealtimeDataService {
  static final RealtimeDataService _instance = RealtimeDataService._internal();

  factory RealtimeDataService() => _instance;

  RealtimeDataService._internal() {
    initializeWebsocketService();
  }

  BuildContext? context;

  final _channel =
      WebSocketChannel.connect(Uri.parse("ws://192.168.0.131:8000/ws"));

  void initializeWebsocketService() {
    _channel.stream.listen((data) {
      print(data);
      Map dataMap = jsonDecode(data.toString());
      if (context != null) {
        switch (dataMap["type"]) {
          case 'getVisitors':
            ManagerProvider.of(context!).addAll(dataMap["args"]);
            break;
          case 'getSingleVisitor':
            ManagerProvider.of(context!)
                .update(dataMap["args"].first, dataMap["condition"]);
            break;
          case 'insert':
            ManagerProvider.of(context!).insert(dataMap["args"].first);
            break;
          case 'error':
            if (dataMap["caused"] == 'insert') {
              showDialog(
                context: context!,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      Text('Insert error!'),
                    ],
                  ),
                  titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                  content: Text(dataMap['errorMessage']),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Dialog(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.1),
                                child: AddDialogLayout(
                                  soldCards(ManagerProvider.of(this.context!)
                                      .tickets),
                                  document: TicketDocument(
                                      dataMap['args']['firstname'],
                                      dataMap['args']['lastname'],
                                      dataMap['args']['email'],
                                      dataMap['args']['number_of_tickets'],
                                      dataMap['args']['number_of_hard_cards'],
                                      dataMap['args']['neighbour_wish'],
                                      dataMap['args']['meat'],
                                      dataMap['args']['vegetarian'],
                                      dataMap['args']['vegan'],
                                      dataMap['args']['allergens'],
                                      dataMap['args']['payed'] == 1,
                                      dataMap['args']['place_number'],
                                      dataMap['args']['money']),
                                ),
                              ),
                            ),
                          ).then((value) => this
                              .context!
                              .findAncestorStateOfType<MainLayoutState>()!
                              .focusNode
                              .requestFocus());
                        },
                        child: const Text('Edit data'))
                  ],
                ),
              ).then((value) => context!
                  .findAncestorStateOfType<MainLayoutState>()!
                  .focusNode
                  .requestFocus());
            }
            break;
          case 'update':
            ManagerProvider.of(context!)
                .update(dataMap["args"].first, dataMap["condition"]);
            break;
          case 'delete':
            ManagerProvider.of(context!).delete(dataMap["args"].first);
            break;
          default:
            break;
        }
      }
    }, onDone: () => close, onError: (error) => print(error));
  }

  void getVisitors() =>
      _channel.sink.add(jsonEncode({"method": "getVisitors"}));

  void getSingleVisitor(Map condition) {
    _channel.sink
        .add(jsonEncode({"method": "getSingleVisitor", "args": condition}));
  }

  void insertVisitor(Map args) =>
      _channel.sink.add(jsonEncode({"method": "addVisitor", "args": args}));

  void updateVisitor(Map args, Map condition) {
    _channel.sink.add(jsonEncode({
      "method": "updateVisitor",
      "args": {"update_data": args, "condition": condition}
    }));
  }

  void deleteVisitor(Map condition) => _channel.sink
      .add(jsonEncode({"method": "deleteVisitor", "args": condition}));

  void close() {
    _channel.sink.close();
  }
}
