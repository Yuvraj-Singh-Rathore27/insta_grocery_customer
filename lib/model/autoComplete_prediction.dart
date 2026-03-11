class AutoCompletePrediction {
  String? _description;
  List<MatchedSubstrings>? _matchedSubstrings;
  String? _placeId;
  double? lat;
  double? log;
  String? _reference;
  StructuredFormatting? _structuredFormatting;
  List<Terms>? _terms;
  List<String>? _types;

  AutoCompletePrediction(
      {String? description,
      List<MatchedSubstrings>? matchedSubstrings,
      String? placeId,
      String? reference,
      StructuredFormatting? structuredFormatting,
      List<Terms>? terms,
      List<String>? types}) {
    _description = description;
    _matchedSubstrings = matchedSubstrings;
    _placeId = placeId;
    _reference = reference;
    _structuredFormatting = structuredFormatting;
    _terms = terms;
    _types = types;
  }

  String? get description => _description;

  set description(String? description) => _description = description;

  List<MatchedSubstrings>? get matchedSubstrings => _matchedSubstrings;

  set matchedSubstrings(List<MatchedSubstrings>? matchedSubstrings) =>
      _matchedSubstrings = matchedSubstrings;



  String? get placeId => _placeId;

  set placeId(String? placeId) => _placeId = placeId;

  String? get reference => _reference;

  set reference(String? reference) => _reference = reference;

  StructuredFormatting? get structuredFormatting => _structuredFormatting;

  set structuredFormatting(StructuredFormatting? structuredFormatting) =>
      _structuredFormatting = structuredFormatting;

  List<Terms>? get terms => _terms;

  set terms(List<Terms>? terms) => _terms = terms;

  List<String>? get types => _types;

  set types(List<String>? types) => _types = types;

  AutoCompletePrediction.fromJson(Map<String, dynamic> json) {
    _description = json['description'];
    if (json['matched_substrings'] != null) {
      _matchedSubstrings = <MatchedSubstrings>[];
      json['matched_substrings'].forEach((v) {
        _matchedSubstrings!.add(MatchedSubstrings.fromJson(v));
      });
    }
    _placeId = json['place_id'];
    _reference = json['reference'];
    _structuredFormatting = json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    if (json['terms'] != null) {
      _terms = <Terms>[];
      json['terms'].forEach((v) {
        _terms!.add(Terms.fromJson(v));
      });
    }
    _types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = _description;
    if (_matchedSubstrings != null) {
      data['matched_substrings'] =
          _matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = _placeId;
    data['reference'] = _reference;
    if (_structuredFormatting != null) {
      data['structured_formatting'] = _structuredFormatting!.toJson();
    }
    if (_terms != null) {
      data['terms'] = _terms!.map((v) => v.toJson()).toList();
    }
    data['types'] = _types;
    return data;
  }
}

class MatchedSubstrings {
  int? _length;
  int? _offset;

  MatchedSubstrings({int? length, int? offset}) {
    _length = length;
    _offset = offset;
  }

  int? get length => _length;

  set length(int? length) => _length = length;

  int? get offset => _offset;

  set offset(int? offset) => _offset = offset;

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    _length = json['length'];
    _offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = _length;
    data['offset'] = _offset;
    return data;
  }
}

class StructuredFormatting {
  String? _mainText;
  List<MainTextMatchedSubstrings>? _mainTextMatchedSubstrings;
  String? _secondaryText;

  StructuredFormatting(
      {String? mainText,
      List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings,
      String? secondaryText}) {
    _mainText = mainText;
    _mainTextMatchedSubstrings = mainTextMatchedSubstrings;
    _secondaryText = secondaryText;
  }

  String? get mainText => _mainText;

  set mainText(String? mainText) => _mainText = mainText;

  List<MainTextMatchedSubstrings>? get mainTextMatchedSubstrings =>
      _mainTextMatchedSubstrings;

  set mainTextMatchedSubstrings(
          List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings) =>
      _mainTextMatchedSubstrings = mainTextMatchedSubstrings;

  String? get secondaryText => _secondaryText;

  set secondaryText(String? secondaryText) => _secondaryText = secondaryText;

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    _mainText = json['main_text'];
    if (json['main_text_matched_substrings'] != null) {
      _mainTextMatchedSubstrings = <MainTextMatchedSubstrings>[];
      json['main_text_matched_substrings'].forEach((v) {
        _mainTextMatchedSubstrings!.add(MainTextMatchedSubstrings.fromJson(v));
      });
    }
    _secondaryText = json['secondary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_text'] = _mainText;
    if (_mainTextMatchedSubstrings != null) {
      data['main_text_matched_substrings'] =
          _mainTextMatchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['secondary_text'] = _secondaryText;
    return data;
  }
}

class MainTextMatchedSubstrings {
  int? _length;
  int? _offset;

  MainTextMatchedSubstrings({int? length, int? offset}) {
    _length = length;
    _offset = offset;
  }

  int? get length => _length;

  set length(int? length) => _length = length;

  int? get offset => _offset;

  set offset(int? offset) => _offset = offset;

  MainTextMatchedSubstrings.fromJson(Map<String, dynamic> json) {
    _length = json['length'];
    _offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = _length;
    data['offset'] = _offset;
    return data;
  }
}

class Terms {
  int? _offset;
  String? _value;

  Terms({int? offset, String? value}) {
    _offset = offset;
    _value = value;
  }

  int? get offset => _offset;

  set offset(int? offset) => _offset = offset;

  String? get value => _value;

  set value(String? value) => _value = value;

  Terms.fromJson(Map<String, dynamic> json) {
    _offset = json['offset'];
    _value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = _offset;
    data['value'] = _value;
    return data;
  }
}
