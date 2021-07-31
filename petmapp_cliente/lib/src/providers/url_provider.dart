class UrlProvider {
  String url() {
    // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
    // final apiUrl = 'http://10.0.2.2:8000/api/';
    // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
    final apiUrl = 'http://192.168.1.86:8000/api/';

    /*  
    PRIMERO CONECTAR EL CELULAR CON USB

    DIRECCION IP CELULAR  
    correr en la consola
      - adb tcip 5555 
      - adb connect 192.168.1.84  -> si conecta, desconectar el usb y darle f5
        - flutter run -d 192.168.1.84 -> si no, usar este comando en el shell
    */

    return apiUrl;
  }
}
