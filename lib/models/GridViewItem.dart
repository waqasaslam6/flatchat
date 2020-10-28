import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  final String _iconData;
  final bool _isSelected;

  GridViewItem(this._iconData, this._isSelected);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Image.asset(_iconData,
      width: 50,
      ),
      shape: StadiumBorder(),
   //   fillColor: _isSelected ? Theme.of(context).accentColor : Theme.of(context).canvasColor,
      onPressed: null,
    );
  }
}