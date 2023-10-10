class Calculation {
  int? id;
  String? expression;
  double? result;
  DateTime? timestamp;

  Calculation({this.id, this.expression, this.result, this.timestamp});
  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'],
      expression: map['expression'],
      result: map['result'],
      timestamp: map['timestamp'] != null? DateTime.parse(map['timestamp']):null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': DateTime.now().toString(),
    };
  }
}
