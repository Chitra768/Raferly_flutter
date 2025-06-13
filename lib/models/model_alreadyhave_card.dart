class ModelAlreadyHaveCard {
  String? email;
  String? numero;
  String? loginUrl;

  ModelAlreadyHaveCard({this.email, this.numero, this.loginUrl});

  ModelAlreadyHaveCard.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    numero = json['numero'];
    loginUrl = json['login_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['numero'] = this.numero;
    data['login_url'] = this.loginUrl;
    return data;
  }
}