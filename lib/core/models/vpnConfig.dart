import 'vpnServer.dart';

class VpnConfig extends VpnServerModel {
  factory VpnConfig.fromJson(Map<String, dynamic> json) => VpnConfig(
        // id: json["id"] == null ? null : json["id"].toString(),
        id: json['id']?.toString(),
        name: json['name'],
        flag: json['flag'],
        country: json['country'],
        slug: json['slug'],
        status: json['status'],
        serverIp: json['server_ip'],
        port: json['port'],
        protocol: json['protocol'],
        username: json['username'],
        password: json['password'],
        config: json['config'],
      );
  VpnConfig({
    String? id,
    String? name,
    String? flag,
    String? country,
    String? slug,
    int? status,
    String? serverIp,
    String? port,
    String? protocol,
    this.username,
    this.password,
    this.config,
  }) : super(
            id: id,
            name: name,
            flag: flag,
            country: country,
            slug: slug,
            status: status,
            serverIp: serverIp,
            port: port,
            protocol: protocol);

  String? username;
  String? password;
  String? config;

  @override
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'slug': slug,
        'config': config,
      };
}
