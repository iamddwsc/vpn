enum VpnType { special, country }

class SpecialVpnServer {
  factory SpecialVpnServer.fromJson(Map<String, dynamic> json) {
    return SpecialVpnServer(
      icon: json['icon'],
      title: json['title'] ?? 'title',
      description: json['description'] ?? 'description',
      subDescription: json['subDescription'],
      tag: json['tag'],
      countryId: json['countryId'],
      type: json['type'],
    );
  }

  SpecialVpnServer(
      {this.icon,
      this.title,
      this.description,
      this.subDescription,
      this.tag,
      this.countryId,
      this.type});
  final String? countryId;
  final String? icon;
  final String? title;
  final String? description;
  final String? subDescription;
  final String? tag;
  final VpnType? type;
}
