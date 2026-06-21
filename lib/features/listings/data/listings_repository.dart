import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';
import '../../../shared/models/listing_model.dart';

class CategoryOption {
  final String id;
  final String name;
  final String slug;
  const CategoryOption({required this.id, required this.name, required this.slug});
}

class ListingsRepository {
  final ApiClient _api;
  ListingsRepository({ApiClient? api}) : _api = api ?? ApiClient();

  /// The current vendor's listings (all statuses).
  Future<List<ListingModel>> listMine() async {
    final res = await _api.dio.get('/listings');
    ensureOk(res);
    final list = res.data as List? ?? const [];
    return list
        .map((e) => ListingModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<ListingModel> getById(String id) async {
    final res = await _api.dio.get('/listings/$id');
    ensureOk(res);
    return ListingModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  /// Creates a listing. Throws with the API's message on tier-limit 403s
  /// ("Your current plan does not include listings…").
  Future<ListingModel> create({
    required String categoryId,
    required String title,
    required String description,
    required String pricingType, // FIXED | QUOTE | STARTING_FROM
    double? basePrice,
    bool isRentable = false,
    double? perDayRate,
    double? depositAmount,
    List<String>? tags,
    Map<String, dynamic>? location,
    List<String>? mediaUrls,
  }) async {
    final res = await _api.dio.post('/listings', data: {
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'pricingType': pricingType,
      if (basePrice != null) 'basePrice': basePrice,
      'isRentable': isRentable,
      if (perDayRate != null) 'perDayRate': perDayRate,
      if (depositAmount != null) 'depositAmount': depositAmount,
      if (tags != null) 'tags': tags,
      if (location != null) 'location': location,
      if (mediaUrls != null && mediaUrls.isNotEmpty) 'mediaUrls': mediaUrls,
    });
    ensureOk(res);
    return ListingModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<ListingModel> update(String id, Map<String, dynamic> changes) async {
    final res = await _api.dio.patch('/listings/$id', data: changes);
    ensureOk(res);
    return ListingModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<ListingModel> setActive(String id, bool isActive) =>
      update(id, {'isActive': isActive});

  /// Soft-deletes (deactivates) on the backend.
  Future<void> delete(String id) async {
    final res = await _api.dio.delete('/listings/$id');
    ensureOk(res);
  }

  /// Active categories for the add/edit listing pickers.
  Future<List<CategoryOption>> categories() async {
    final res = await _api.dio.get('/categories');
    ensureOk(res);
    final list = res.data as List? ?? const [];
    return list
        .map((e) => CategoryOption(
              id: e['id'] as String,
              name: e['name'] as String,
              slug: e['slug'] as String? ?? '',
            ))
        .toList();
  }
}
