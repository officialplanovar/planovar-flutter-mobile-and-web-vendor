import 'package:equatable/equatable.dart';

class TopListingItem extends Equatable {
  final String title;
  final int views;

  const TopListingItem({
    required this.title,
    required this.views,
  });

  factory TopListingItem.fromJson(Map<String, dynamic> json) {
    return TopListingItem(
      title: json['title'] as String,
      views: json['views'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'views': views,
      };

  TopListingItem copyWith({String? title, int? views}) {
    return TopListingItem(
      title: title ?? this.title,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [title, views];
}
