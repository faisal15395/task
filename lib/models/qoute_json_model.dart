class QuoteModel {
  int? id;
  String? quote;
  String? author;

  QuoteModel({this.id, this.quote, this.author});

  QuoteModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    quote = json['quote'];
    author = json['author'];
  }
}
