import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:flutter/cupertino.dart';

import '../route/cards/allergens_widget.dart';

class StateManager with ChangeNotifier {
  List<TicketDocument> tickets = [];
  List<TicketDocument> viewTickets = [];
  String? searchValue;
  String sortBy = 'firstname', direction = 'asc';
  List<Allergy> allergens = [];

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
    for (var element in tickets) {
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

  void sort(String sortBy, String direction) {
    this.sortBy = sortBy;
    this.direction = direction;
    switch (sortBy) {
      case 'firstname':
        viewTickets.sort((a, b) => a.firstname.compareTo(b.firstname));
        if (direction == 'desc') {
          viewTickets = viewTickets.reversed.toList();
        }
        break;
      case 'lastname':
        viewTickets.sort((a, b) => a.lastname.compareTo(b.lastname));
        if (direction == 'desc') {
          viewTickets = viewTickets.reversed.toList();
        }
        break;
      case 'neighbourWish':
        viewTickets.sort((a, b) =>
            (a.neighbourWish ?? '--').compareTo(b.neighbourWish ?? '--'));
        if (direction == 'desc') {
          viewTickets = viewTickets.reversed.toList();
        }
        break;
      case 'placeNumber':
        viewTickets.sort(
            (a, b) => (a.placeNumber ?? '--').compareTo(b.placeNumber ?? '--'));
        if (direction == 'desc') {
          viewTickets = viewTickets.reversed.toList();
        }
        break;
      case 'cards':
        viewTickets
            .sort((a, b) => a.numberOfTickets > b.numberOfTickets ? 1 : 0);
        if (direction == 'desc') {
          viewTickets.reversed;
        }
        break;
      case 'payed':
        viewTickets
            .sort((a, b) => (a.payed == b.payed ? 0 : (a.payed ? 1 : -1)));
        if (direction == 'desc') {
          viewTickets = viewTickets.reversed.toList();
        }
        break;
    }
    notifyListeners();
  }

  void delete(Map visitor) {
    tickets.removeWhere((item) =>
        item.firstname == visitor['firstname'] &&
        item.lastname == visitor['lastname']);
    search(searchValue);
    notifyListeners();
  }
}
