import 'package:abiball_planer/core/route/cards/allergens_widget.dart';
import 'package:abiball_planer/core/route/cards/ticket_document.dart';
import 'package:abiball_planer/core/service/web_socket_service.dart';
import 'package:abiball_planer/core/utils/counter_view.dart';
import 'package:flutter/material.dart';

class EditDialogLayout extends StatefulWidget {
  final int sold;

  final TicketDocument personData;

  const EditDialogLayout(this.sold, this.personData, {super.key});

  @override
  State createState() {
    return _EditDialogLayoutState();
  }
}

class _EditDialogLayoutState extends State<EditDialogLayout> {
  GlobalKey<AllergensWidgetState> allergiesWidget = GlobalKey();

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
    setState(() {
      nameController.text = widget.personData.toString();
      emailController.text = widget.personData.email;
      neighbourWishController.text = widget.personData.neighbourWish ?? '';
      RegExp regExp = RegExp(r'(?<tableName>\w{2})(?<number>\d)');
      final p = regExp.allMatches((widget.personData.placeNumber ?? ''));
      placeNumberController.text = p.firstOrNull?.groups([1, 2]).join() ?? '';
      placeNumberController1.text = p.lastOrNull?.groups([1, 2]).join() ?? '';
      soldCards = widget.sold - widget.personData.numberOfTickets;
    });
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
        title: const Text('Karten Bearbeiten'),
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
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.018),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: SingleChildScrollView(
                child: Column(children: [
                  TextField(
                    controller: nameController,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.027),
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
                                              widget.personData.numberOfTickets,
                                          minNumber: 1,
                                          maxNumber: 728 -
                                              (widget.sold -
                                                  int.parse(widget.personData
                                                      .numberOfTickets
                                                      .toString())), (value) {
                                        setState(() {
                                          if (widget.personData
                                                  .numberOfHardCards ==
                                              widget
                                                  .personData.numberOfTickets) {
                                            widget.personData
                                                .numberOfHardCards = value;
                                          }
                                          widget.personData.numberOfTickets =
                                              value;
                                        });
                                      }),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${soldCards + widget.personData.numberOfTickets}',
                                        style: TextStyle(
                                            color: widget.sold +
                                                        widget.personData
                                                            .numberOfTickets <=
                                                    599
                                                ? Colors.green
                                                : (widget.sold +
                                                                widget
                                                                    .personData
                                                                    .numberOfTickets >
                                                            599 &&
                                                        (widget.sold -
                                                                    int.parse(widget
                                                                        .personData
                                                                        .numberOfTickets
                                                                        .toString())) +
                                                                widget
                                                                    .personData
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.018
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
                                          initNumber: widget
                                              .personData.numberOfHardCards,
                                          minNumber: 0,
                                          maxNumber: widget.personData
                                              .numberOfTickets, (value) {
                                        setState(() {
                                          widget.personData.numberOfHardCards =
                                              value;
                                        });
                                      }),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.personData.numberOfHardCards
                                              .toString(),
                                        ),
                                        Text(
                                            '/${widget.personData.numberOfTickets}'),
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
                                    value: widget.personData.payed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (payed) async {
                                      widget.personData.payed =
                                          !widget.personData.payed;
                                      widget.personData.money = widget
                                              .personData.payed
                                          ? 39.0 *
                                              widget.personData.numberOfTickets
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.027),
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
                                    initNumber: widget.personData.meat,
                                    minNumber: 0,
                                    maxNumber: (widget
                                            .personData.numberOfTickets -
                                        (widget.personData.vegetarian +
                                            widget.personData.vegan)), (value) {
                                  setState(() {
                                    widget.personData.meat = value;
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
                                    initNumber: widget.personData.vegetarian,
                                    minNumber: 0,
                                    maxNumber: (widget
                                            .personData.numberOfTickets -
                                        (widget.personData.meat +
                                            widget.personData.vegan)), (value) {
                                  setState(() {
                                    widget.personData.vegetarian = value;
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
                                  initNumber: widget.personData.vegan,
                                  minNumber: 0,
                                  maxNumber: (widget
                                          .personData.numberOfTickets -
                                      (widget.personData.vegetarian +
                                          widget.personData.meat)), (value) {
                                setState(() {
                                  widget.personData.vegan = value;
                                });
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.022),
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
                    widget.personData.allergies,
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
                      onPressed: () {
                        RealtimeDataService()
                            .getSingleVisitor(widget.personData.conditions);
                        closeDialog();
                      },
                      child: const Text('Abrechen')),
                  TextButton(
                      onPressed: () {
                        if (validation()) {
                          widget.personData.update(
                            name: nameController.text,
                            email: emailController.text,
                            neighbourWish: neighbourWishController.text == ''
                                ? null
                                : neighbourWishController.text,
                            placeNumber: placeNumberController.text != ''
                                ? '${placeNumberController.text}-${placeNumberController1.text}'
                                : null,
                            money: widget.personData.payed
                                ? widget.personData.numberOfTickets * 39.0
                                : 0,
                            allergies: allergiesWidget
                                    .currentState!.getAllergens.isNotEmpty
                                ? allergiesWidget.currentState!.getAllergens
                                : null,
                          );
                          closeDialog();
                        }
                      },
                      child: const Text('Aktualisieren'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
