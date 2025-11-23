import 'dart:convert';

class VerseModel {
  final String command;
  final String promise;
  final String rights;
  final String prayer;

  VerseModel({
    required this.command,
    required this.promise,
    required this.rights,
    required this.prayer,
  });

  Map<String, dynamic> toJson() => {
        'command': command,
        'promise': promise,
        'rights': rights,
        'prayer': prayer,
      };

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      command: json['command'] as String,
      promise: json['promise'] as String,
      rights: json['rights'] as String,
      prayer: json['prayer'] as String,
    );
  }
}
