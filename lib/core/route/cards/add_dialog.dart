import 'package:abiball_planer/core/route/cards/allergens_widget.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/service/websocketService.dart';
import 'package:abiball_planer/core/utils/counter_view.dart';
import 'package:flutter/material.dart';

class AddDialogLayout extends StatefulWidget {
  final int sold;
  final TicketDocument? document;

  const AddDialogLayout(this.sold, {this.document, super.key});

  @override
  State createState() {
    return _AddDialogLayoutState();
  }
}

class _AddDialogLayoutState extends State<AddDialogLayout> {
  GlobalKey<AllergensWidgetState> allergiesWidget = GlobalKey();
  TicketDocument personData =
      TicketDocument('', '', '', 0, 0, null, 0, 0, 0, null, false, null, 0);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController neighbourWishController = TextEditingController();
  TextEditingController placeNumberController = TextEditingController();
  TextEditingController placeNumberController1 = TextEditingController();

  bool nameError = false;
  String nameErrorMessage = '';
  bool emailError = false;
  String emailErrorMessage = '';

  int soldCards = 0;

  @override
  void initState() {
    personData = widget.document ?? personData;

    if (personData.firstname != '' && personData.lastname != '') {
      nameController.text = personData.toString();
    }
    emailController.text = personData.email;
    neighbourWishController.text = personData.neighbourWish ?? '';
    RegExp regExp = RegExp(r'(?<tableName>\w{2})(?<number>\d)');
    final p = regExp.allMatches((personData.placeNumber ?? ''));
    placeNumberController.text = p.firstOrNull?.groups([1, 2]).join() ?? '';
    placeNumberController1.text = p.lastOrNull?.groups([1, 2]).join() ?? '';

    soldCards = widget.sold;
    super.initState();
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  bool validation() {
    if (nameController.text.isNotEmpty) {
      if (!RegExp(r"^([a-zA-Z ,.'-äöüß]+ [a-zA-Z ,.'-äöü?]+)")
          .hasMatch(nameController.text)) {
        nameErrorMessage =
            'Der Name muss aus einem Vor- und Nachnamen bestehen!';
        nameError = true;
      }
    } else {
      nameErrorMessage = 'Dieses Feld muss ausgefüllt werden!';
      nameError = true;
    }
    if (emailController.text.isNotEmpty) {
      if (!RegExp(
              r'^(([^<>()[\]\\.,;:\s@]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(emailController.text)) {
        emailErrorMessage =
            'Keine gültige E-Mail Adresse. Bitte überprüfe die E-Mail Adresse und Korigiere sie!';
        emailError = true;
      }
    } else {
      emailErrorMessage = 'Dieses Feld muss ausgefüllt werden!';
      emailError = true;
    }
    setState(() {});
    return !nameError && !emailError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karten Hinzufügen'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: SingleChildScrollView(
                child: Column(children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(width: 1.5),
                      ),
                      hintText: 'Vorname NachName',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                      errorText: nameError ? nameErrorMessage : null,
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                    onTap: () => setState(() => nameError = false),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(width: 1.5),
                      ),
                      hintText: 'E-Mail Adresse',
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                      errorText: emailError ? emailErrorMessage : null,
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                    onTap: () => setState(() => emailError = false),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: neighbourWishController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(width: 1.5),
                      ),
                      hintText: 'Wunsch Sitznachbarn (max 2, nur Nachname)',
                      prefixIcon: Icon(
                        Icons.group,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                    ),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      'Anzahl an Karten:',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CounterView(
                                          initNumber:
                                              personData.numberOfTickets,
                                          minNumber: 1,
                                          maxNumber: 728 -
                                              (widget.sold -
                                                  int.parse(personData
                                                      .numberOfTickets
                                                      .toString())), (value) {
                                        setState(() {
                                          if (personData.numberOfHardCards ==
                                              personData.numberOfTickets) {
                                            personData.numberOfHardCards =
                                                value;
                                          }
                                          personData.numberOfTickets = value;
                                        });
                                      }),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${soldCards + personData.numberOfTickets}',
                                        style: TextStyle(
                                            color: widget.sold +
                                                        personData
                                                            .numberOfTickets <=
                                                    599
                                                ? Colors.green
                                                : (widget.sold +
                                                                personData
                                                                    .numberOfTickets >
                                                            599 &&
                                                        (widget.sold -
                                                                    int.parse(personData
                                                                        .numberOfTickets
                                                                        .toString())) +
                                                                personData
                                                                    .numberOfTickets <
                                                            728)
                                                    ? Colors.orange
                                                    : Colors.red),
                                      ),
                                      const Text('/728,'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      'davon Hardkarten:',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CounterView(
                                          initNumber:
                                              personData.numberOfHardCards,
                                          minNumber: 0,
                                          maxNumber: personData.numberOfTickets,
                                          (value) {
                                        setState(() {
                                          personData.numberOfHardCards = value;
                                        });
                                      }),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(
                                          personData.numberOfHardCards
                                              .toString(),
                                        ),
                                        Text('/${personData.numberOfTickets}'),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(children: [
                          Row(children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Bezahlt:',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Checkbox(
                                    value: personData.payed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (payed) async {
                                      personData.payed = !personData.payed;
                                      personData.money = personData.payed
                                          ? 39.0 * personData.numberOfTickets
                                          : 0.0;
                                      setState(() {});
                                    })),
                          ]),
                          Row(children: [
                            const Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Text(
                                  'Sitzplatz:',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                                flex: 3,
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: placeNumberController,
                                        textAlign: TextAlign.center,
                                      )),
                                  const Text('-'),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: placeNumberController1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]))
                          ])
                        ]),
                      ),
                      Expanded(flex: 2, child: Container()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Tierisch:',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 120,
                                child: CounterView(
                                    initNumber: personData.meat,
                                    minNumber: 0,
                                    maxNumber: (personData.numberOfTickets -
                                        (personData.vegetarian +
                                            personData.vegan)), (value) {
                                  setState(() {
                                    personData.meat = value;
                                  });
                                }),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Vegetarisch:',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 120,
                                child: CounterView(
                                    initNumber: personData.vegetarian,
                                    minNumber: 0,
                                    maxNumber: (personData.numberOfTickets -
                                        (personData.meat + personData.vegan)),
                                    (value) {
                                  setState(() {
                                    personData.vegetarian = value;
                                  });
                                }),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Vegan:',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 120,
                              child: CounterView(
                                  initNumber: personData.vegan,
                                  minNumber: 0,
                                  maxNumber: (personData.numberOfTickets -
                                      (personData.vegetarian +
                                          personData.meat)), (value) {
                                setState(() {
                                  personData.vegan = value;
                                });
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    widthFactor: 9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Allergene',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  AllergensWidget(
                    personData.allergies,
                    key: allergiesWidget,
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => closeDialog(),
                      child: const Text('Abrechen')),
                  TextButton(
                      onPressed: () {
                        if (validation()) {
                          personData.name = nameController.text;
                          personData.email = emailController.text;
                          personData.neighbourWish =
                              neighbourWishController.text.isNotEmpty
                                  ? neighbourWishController.text
                                  : null;
                          personData.placeNumber = placeNumberController
                                  .text.isNotEmpty
                              ? '${placeNumberController.text}-${placeNumberController1.text}'
                              : null;
                          personData.money = personData.payed
                              ? personData.numberOfTickets * 39.0
                              : 0;
                          personData.allergies = allergiesWidget
                                  .currentState!.getAllergens.isNotEmpty
                              ? allergiesWidget.currentState!.getAllergens
                              : null;
                          RealtimeDataService()
                              .insertVisitor(personData.getDocumentMap());
                          closeDialog();
                        }
                      },
                      child: const Text('Hinzufügen'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
