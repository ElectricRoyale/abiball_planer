import 'package:flutter/material.dart';

class CounterView extends StatefulWidget {
  final int initNumber;
  final Function(int) counterCallback;
  final int minNumber;
  final int maxNumber;

  const CounterView(this.counterCallback,
      {this.initNumber = 1,
      this.minNumber = 0,
      this.maxNumber = 100,
      super.key});

  @override
  State createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _currentCount = 1;
  Function(int) _counterCallback = (int number) {};

  @override
  void initState() {
    _currentCount = widget.initNumber;
    _counterCallback = widget.counterCallback;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromARGB(255, 240, 240, 240),
      ),
      constraints: const BoxConstraints(minWidth: 84.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createIncrementDicrementButton(
              Icons.remove,
              _currentCount > widget.minNumber
                  ? const Color.fromARGB(255, 220, 220, 220)
                  : const Color.fromARGB(255, 230, 230, 230),
              _currentCount > widget.minNumber ? () => _dicrement() : null),
          Text(_currentCount.toString()),
          _createIncrementDicrementButton(
              Icons.add,
              _currentCount < widget.maxNumber
                  ? const Color.fromARGB(255, 220, 220, 220)
                  : const Color.fromARGB(255, 230, 230, 230),
              _currentCount < widget.maxNumber ? () => _increment() : null),
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      _currentCount++;
      _counterCallback(_currentCount);
    });
  }

  void _dicrement() {
    setState(() {
      if (_currentCount > widget.minNumber) {
        _currentCount--;
        _counterCallback(_currentCount);
      }
    });
  }

  Widget _createIncrementDicrementButton(
      IconData icon, Color fillColor, Function? onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: const BoxConstraints(minWidth: 32.0, minHeight: 32.0),
      onPressed: onPressed == null ? null : () => onPressed.call(),
      elevation: 2.0,
      fillColor: fillColor,
      shape: const CircleBorder(),
      child: Icon(
        icon,
        color: Colors.black,
        size: 12.0,
      ),
    );
  }
}
