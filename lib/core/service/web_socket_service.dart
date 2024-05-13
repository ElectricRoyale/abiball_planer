import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:abiball_planer/core/mainlayout.dart';
import 'package:abiball_planer/core/managment/managerProvider.dart';
import 'package:abiball_planer/core/route/cards/add_dialog.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RealtimeDataService {
  static final RealtimeDataService _instance = RealtimeDataService._internal();

  BuildContext? context;

  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  String wsUrl = "ws://192.168.0.131:8000/ws";
  late WebSocket _channel;

  factory RealtimeDataService() => _instance;

  RealtimeDataService._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    if (kDebugMode) {
      print("conecting...");
    }
    _channel = await connectWs();
    if (kDebugMode) {
      print("socket connection initializied");
    }
    _channel.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  void broadcastNotifications() {
    _channel.listen((data) {
      if (kDebugMode) {
        print(data);
      }
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
                  surfaceTintColor: Colors.white,
                  title: Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      SizedBox(width: MediaQuery.sizeOf(context).width * 0.01),
                      const Text(
                        'Insert error!',
                        style: TextStyle(color: Colors.black),
                      ),
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
    }, onDone: () {
      if (kDebugMode) {
        print("connecting aborted");
      }
      initWebSocketConnection();
    }, onError: (error) {
      if (kDebugMode) {
        print('Server error: $error');
      }
      initWebSocketConnection();
    });
  }

  connectWs() async {
    try {
      return await WebSocket.connect(wsUrl);
    } catch (e) {
      if (kDebugMode) {
        print("Error! can not connect WS connectWs $e");
      }
      await Future.delayed(const Duration(milliseconds: 10000));
      return await connectWs();
    }
  }

  void _onDisconnected() {

    initWebSocketConnection();
  }

  void getVisitors() =>
      _channel.add(jsonEncode({"method": "getVisitors"}));

  void getSingleVisitor(Map condition) {
    _channel
        .add(jsonEncode({"method": "getSingleVisitor", "args": condition}));
  }

  void insertVisitor(Map args) =>
      _channel.add(jsonEncode({"method": "addVisitor", "args": args}));

  void updateVisitor(Map args, Map condition) {
    _channel.add(jsonEncode({
      "method": "updateVisitor",
      "args": {"update_data": args, "condition": condition}
    }));
  }

  void deleteVisitor(Map condition) => _channel
      .add(jsonEncode({"method": "deleteVisitor", "args": condition}));

  void close() {
    _channel.close();
  }
}
