class UrlProvider {
  String url() {
    // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
    //  apiUrl = 'http://10.0.2.2:8000/api/';
    // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
    final apiUrl = 'http://192.168.1.86:8000/api/';
    return apiUrl;
  }
}
