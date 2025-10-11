import 'package:abiball_planer/core/service/web_socket_service.dart';

class TicketDocument {
  TicketDocument(
      this.firstname,
      this.lastname,
      this.email,
      this.numberOfTickets,
      this.numberOfHardCards,
      this.neighbourWish,
      this.meat,
      this.vegetarian,
      this.vegan,
      this.allergies,
      this.payed,
      this.placeNumber,
      this.money) {
    conditions = {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
    };
  }

  String firstname;
  String lastname;
  String email;
  int numberOfTickets;
  int numberOfHardCards;
  String? neighbourWish;
  int meat;
  int vegetarian;
  int vegan;
  String? allergies;
  bool payed;
  String? placeNumber;
  double money;
  Map conditions = {};

  @override
  String toString() {
    return '$firstname $lastname';
  }

  set name(String value) {
    RegExp regExp = RegExp(
        r"(?<firstname>\p{L}+(?:[-\s](?!von|von der|van|van der|de la|de|di|del|el)\p{L}+)*)\s+(?<lastname>(?:von|von der|van|van der|de la|de|di|del|el)*(?:\s+)?\p{L}+(?:[-\s]?\p{L}+)*)",
        unicode: true);
    if (regExp.hasMatch(value)) {
      var match = regExp.firstMatch(value);
      firstname = match!.namedGroup('firstname')!;
      lastname = match.namedGroup('lastname')!;
    }
  }

  Map getDocumentMap() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "number_of_tickets": numberOfTickets,
      "number_of_hard_cards": numberOfHardCards,
      "neighbour_wish": neighbourWish,
      "meat": meat,
      "vegetarian": vegetarian,
      "vegan": vegan,
      "allergens": allergies,
      "place_number": placeNumber,
      "money": money,
      "payed": payed,
    };
  }

  void fromMap(Map visitor) {
    firstname = visitor['firstname'];
    lastname = visitor['lastname'];
    email = visitor['email'];
    numberOfTickets = visitor['number_of_tickets'];
    numberOfHardCards = visitor['number_of_hard_cards'];
    neighbourWish = visitor['neighbour_wish'];
    meat = visitor['meat'];
    vegetarian = visitor['vegetarian'];
    vegan = visitor['vegan'];
    allergies = visitor['allergens'];
    payed = visitor['payed'] == 1;
    placeNumber = visitor['place_number'];
    money = visitor['money'];
    conditions = {
      "firstname": visitor['firstname'],
      "lastname": visitor['lastname'],
      "email": email,
    };
  }

  void update(
      {String? name,
      String? email,
      int? numberOfTickets,
      int? numberOfHardCards,
      String? neighbourWish,
      int? meat,
      int? vegetarian,
      int? vegan,
      String? allergies,
      bool? payed,
      String? placeNumber,
      double? money}) {
    name != null ? this.name = name : null;
    email != null ? this.email = email : null;
    numberOfTickets != null ? this.numberOfTickets = numberOfTickets : null;
    numberOfHardCards != null
        ? this.numberOfHardCards = numberOfHardCards
        : null;
    this.neighbourWish = neighbourWish;
    meat != null ? this.meat = meat : null;
    vegetarian != null ? this.vegetarian = vegetarian : null;
    vegan != null ? this.vegan = vegan : null;
    this.allergies = allergies;
    payed != null ? this.payed = payed : null;
    this.placeNumber = placeNumber;
    money != null ? this.money = money : null;
    RealtimeDataService().updateStudent(getDocumentMap(), conditions);
  }
}
