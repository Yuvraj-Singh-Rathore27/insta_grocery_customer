import 'autoComplete_prediction.dart';

class PlaceAutoCompleteResponse {
  List<AutoCompletePrediction>? _predictions;
  String? _status;

  PlaceAutoCompleteResponse(
      {List<AutoCompletePrediction>? predictions, String? status}) {
    _predictions = predictions;
    _status = status;
  }

  List<AutoCompletePrediction>? get predictions => _predictions;

  set predictions(List<AutoCompletePrediction>? predictions) =>
      _predictions = predictions;

  String? get status => _status;

  set status(String? status) => _status = status;

  PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      _predictions = <AutoCompletePrediction>[];
      json['predictions'].forEach((v) {
        _predictions!.add(AutoCompletePrediction.fromJson(v));
      });
    }
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_predictions != null) {
      data['predictions'] = _predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = _status;
    return data;
  }
}
