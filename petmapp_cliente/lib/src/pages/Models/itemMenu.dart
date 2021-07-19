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
    itemEditar,
    itemSalir,
  ];

  static const itemConfig =
      MenuItem(text: 'Configuracion', icon: Icons.settings);

  static const itemEditar =
      MenuItem(text: 'Editar Perfil', icon: Icons.emoji_people);

  static const itemSalir = MenuItem(text: 'Cerrar Sesión', icon: Icons.logout);
}
