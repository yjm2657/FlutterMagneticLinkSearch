class ListDataModel {
  final String status;
  final ListDataDataModel data;

  ListDataModel({this.status, this.data});
  factory ListDataModel.fromJson(Map<String, dynamic> parsedJson) {
    return ListDataModel(
        status: parsedJson['status'].toString(),
        data: ListDataDataModel.fromJson(parsedJson['data']));
  }
}

class ListDataDataModel {
  final ListDataDataResultModel result;
  ListDataDataModel({this.result});

  factory ListDataDataModel.fromJson(Map<String, dynamic> parsedJson) {
    return ListDataDataModel(
      result: ListDataDataResultModel.fromJson(parsedJson['result']),
    );
  }
}

class ListDataDataResultModel {
  final int total_pages;
  final bool last;
  final int total_elements;
  final int number_of_elements;
  final bool first;
  final int size;
  final int number;
  final List<ListDataModelResultContentModel> content;

  ListDataDataResultModel(
      {this.total_pages,
      this.last,
      this.total_elements,
      this.number,
      this.number_of_elements,
      this.first,
      this.size,
      this.content});

  factory ListDataDataResultModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['content'] as List;

    for (var obj in list) {
      if (obj is String) {
        list.remove(obj);
        break;
      }
    }
    List<ListDataModelResultContentModel> contentList =
        list.map((i) => ListDataModelResultContentModel.fromJson(i)).toList();

    return ListDataDataResultModel(
        total_pages: parsedJson['total_pages'],
        last: parsedJson['last'],
        total_elements: parsedJson['total_elements'],
        number_of_elements: parsedJson['number_of_elements'],
        first: parsedJson['first'],
        size: parsedJson['size'],
        number: parsedJson['number'],
        content: contentList);
  }
}

class ListDataModelResultContentModel {
  final String title;
  final String infohash;
  final bool favorite;
  final int file_count;
  final int content_size;
  final String created_time;

  ListDataModelResultContentModel(
      {this.title,
      this.infohash,
      this.favorite,
      this.file_count,
      this.content_size,
      this.created_time});

  factory ListDataModelResultContentModel.fromJson(
      Map<String, dynamic> parsedJson) {
    return ListDataModelResultContentModel(
        title: parsedJson['title'].toString(),
        infohash: parsedJson['infohash'].toString(),
        favorite: parsedJson['favorite'],
        file_count: parsedJson['file_count'],
        content_size: parsedJson['content_size'],
        created_time: parsedJson['created_time'].toString());
  }
}
