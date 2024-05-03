import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:flutter/cupertino.dart';

class StateManager with ChangeNotifier {
  List<TicketDocument> tickets = [];
  List<TicketDocument> viewTickets = [];
  String? searchValue;
  String sortBy = 'name';

  void addAll(List data) {
    tickets.clear();
    for (var visitor in data) {
      tickets.add(TicketDocument(
          visitor['firstname'],
          visitor['lastname'],
          visitor['email'],
          visitor['number_of_tickets'],
          visitor['number_of_hard_cards'],
          visitor['neighbour_wish'],
          visitor['meat'],
          visitor['vegetarian'],
          visitor['vegan'],
          visitor['allergens'],
          visitor['payed'] == 1,
          visitor['place_number'],
          visitor['money']));
    }
    tickets.sort((a, b) => a.toString().compareTo(b.toString()));
    search(searchValue);
    notifyListeners();
  }

  void insert(Map visitor) {
    tickets.add(TicketDocument(
        visitor['firstname'],
        visitor['lastname'],
        visitor['email'],
        visitor['number_of_tickets'],
        visitor['number_of_hard_cards'],
        visitor['neighbour_wish'],
        visitor['meat'],
        visitor['vegetarian'],
        visitor['vegan'],
        visitor['allergens'],
        visitor['payed'] == 1,
        visitor['place_number'],
        visitor['money']));
    tickets.sort((a, b) => a.toString().compareTo(b.toString()));
    search(searchValue);
    notifyListeners();
  }

  void update(Map visitor, Map condition) {
    TicketDocument document = tickets.elementAt(tickets.indexWhere((item) =>
        (item.firstname == condition['firstname'] &&
            item.lastname == condition['lastname']) ||
        (item.firstname == visitor['firstname'] &&
            item.lastname == visitor['lastname'])));
    document.fromMap(visitor);
    notifyListeners();
  }

  void search(String? search) {
    searchValue = search;
    viewTickets.clear();
    if (search != null) {
      for (var item in tickets) {
        if (item.toString().toLowerCase().contains(search.toLowerCase())) {
          viewTickets.add(item);
        }
      }
    } else {
      viewTickets.addAll(tickets);
    }
    notifyListeners();
  }

  void sort(String sortBy) {}

  void delete(Map visitor) {
    tickets.removeWhere((item) =>
        item.firstname == visitor['firstname'] &&
        item.lastname == visitor['lastname']);
    search(searchValue);
    notifyListeners();
  }
}
