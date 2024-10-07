// lib/widgets/dial_pad.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Callback type for when the call button is pressed.
/// Provides the current phone number.
typedef DialPadCallCallback = void Function(String phoneNumber);

/// Callback type for when the phone number changes.
typedef DialPadNumberChangedCallback = void Function(String phoneNumber);

/// Callback type for when the delete button is pressed.
typedef DialPadDeleteCallback = void Function(String phoneNumber);

class DialPad extends StatefulWidget {
  /// Callback when the call button is pressed.
  final DialPadCallCallback onCallPressed;

  /// Optional callback when the phone number changes.
  final DialPadNumberChangedCallback? onNumberChanged;

  /// Optional callback when the delete button is pressed.
  final DialPadDeleteCallback? onDeletePressed;

  const DialPad({
    Key? key,
    required this.onCallPressed,
    this.onNumberChanged,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  _DialPadState createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  String phoneNumber = '';

  /// Handles the press of a number button.
  void _onNumberPressed(String number) {
    setState(() {
      phoneNumber += number;
    });
    if (widget.onNumberChanged != null) {
      widget.onNumberChanged!(phoneNumber);
    }
  }

  /// Handles the press of the delete button.
  void _onDeletePressedInternal() {
    setState(() {
      if (phoneNumber.isNotEmpty) {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      }
    });
    if (widget.onDeletePressed != null) {
      widget.onDeletePressed!(phoneNumber);
    }
  }

  /// Handles the press of the call button.
  void _onCallPressedInternal() {
    widget.onCallPressed(phoneNumber);
  }

  /// Builds the display area showing the entered phone number.
  Widget _buildDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              phoneNumber,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: _onDeletePressedInternal,
            child: Container(
              child: const Icon(Icons.backspace, color: Colors.grey, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single dial pad button.
  Widget _buildDialPadButton(String label,
      {IconData? icon, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed ??
          () {
            _onNumberPressed(label);
          },
      child: Container(
          padding: const EdgeInsets.all(4.0),
          margin: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: const Color.fromARGB(255, 243, 243, 240)),
          child: icon != null
              ? Icon(icon, size: 28, color: Colors.black87)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style:
                          const TextStyle(fontSize: 24, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    _getSubLabel(label),
                  ],
                )),
    );
  }

  /// Returns the letters associated with the number (like on a phone).
  Widget _getSubLabel(String label) {
    const Map<String, String> letterMap = {
      '1': '',
      '2': 'ABC',
      '3': 'DEF',
      '4': 'GHI',
      '5': 'JKL',
      '6': 'MNO',
      '7': 'PQRS',
      '8': 'TUV',
      '9': 'WXYZ',
      '*': '',
      '0': '+',
      '#': '',
    };

    String letters = letterMap[label] ?? '';
    return Text(
      letters,
      style: const TextStyle(fontSize: 12, color: Colors.black54),
    );
  }

  /// Builds the grid of dial pad buttons.
  Widget _buildDialPad() {
    const List<String> keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '*',
      '0',
      '#',
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        String key = keys[index];
        return _buildDialPadButton(key);
      },
    );
  }

  /// Builds the action buttons (Delete and Call).
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Delete Button
        InkWell(
          onTap: _onCallPressedInternal,
          child: Container(
            margin: const EdgeInsets.only(top: 24.0),
            padding: const EdgeInsets.fromLTRB(36.0, 16.0, 36.0, 16.0),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(16.0)),
            child: Row(
              children: [
                Icon(Icons.call, color: Colors.white, size: 28),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  "Call",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),

        // Call Button
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDisplay(),
          _buildDialPad(),
          _buildActionButtons(),
        ],
      ),
    );
  }
}
