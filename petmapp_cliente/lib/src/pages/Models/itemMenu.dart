import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    this.text,
    this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> itemsFirst = [
    itemConfig,
    itemSalir,
  ];

  static const itemConfig =
      MenuItem(text: 'Configuracion', icon: Icons.settings);

  static const itemSalir = MenuItem(text: 'Cerrar Sesión', icon: Icons.logout);
}
