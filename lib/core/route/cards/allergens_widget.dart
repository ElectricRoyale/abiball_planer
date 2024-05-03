import 'package:abiball_planer/core/utils/counter_view.dart';
import 'package:flutter/material.dart';

class AllergensWidget extends StatefulWidget {
  const AllergensWidget(this.allergens, {super.key});

  final String? allergens;

  @override
  State createState() => AllergensWidgetState();
}

class AllergensWidgetState extends State<AllergensWidget> {
  List<Widget> allergens = [];
  List<Allergy?> allergyList = [];

  @override
  void initState() {
    if (widget.allergens != null) {
      List<String> all =
          widget.allergens.toString().trim().split(RegExp(r'(?=;(?!$))'));
      int i = 0;
      allergens.addAll(all.map((rawData) {
        List<String> data = rawData.trim().replaceAll(';', '').split(',');
        Allergy allergy = Allergy(int.parse(data.first), data.last);
        return addAllergens(allergy, i++);
      }).toList());
    }
    super.initState();
  }

  Widget addAllergens(Allergy allergy, int index) {
    allergyList.add(allergy);
    TextEditingController controller = TextEditingController();
    controller.text = allergy.allergenType.trim();
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 120,
              child: CounterView(
                  initNumber: allergy.amount,
                  minNumber: 0,
                  (value) => setState(() {
                        allergy.amount = value;
                      })),
            ),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: TextField(
                controller: controller,
                onChanged: (allergenTypeChange) => setState(() {
                  allergy.allergenType = allergenTypeChange.trim();
                }),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  removeAllergen(index);
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                  size: 18,
                )),
          ],
        ),
      ),
    );
  }

  void removeAllergen(int pos) {
    allergens.removeAt(pos);
    allergyList.removeAt(pos);
    setState(() {});
  }

  String get getAllergens =>
      allergyList.map((allergy) => allergy.toString()).join(';');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...allergens,
        TextButton(
            onPressed: () => setState(() => allergens
                .add(addAllergens(Allergy(1, ''), allergens.length - 1))),
            child: const Text('+ Hinzufügen')),
      ],
    );
  }
}

class Allergy {
  int amount;
  String allergenType;

  Allergy(this.amount, this.allergenType);

  @override
  String toString() {
    return '$amount,$allergenType';
  }
}
