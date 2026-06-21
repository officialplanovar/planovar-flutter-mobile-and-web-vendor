import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/listing_model.dart';
import '../data/listings_repository.dart';

enum ListingsStatus { initial, loading, loaded, error }

class ListingsState extends Equatable {
  final ListingsStatus status;
  final List<ListingModel> listings;
  final String? error;

  const ListingsState({
    this.status = ListingsStatus.initial,
    this.listings = const [],
    this.error,
  });

  ListingsState copyWith({
    ListingsStatus? status,
    List<ListingModel>? listings,
    String? error,
  }) =>
      ListingsState(
        status: status ?? this.status,
        listings: listings ?? this.listings,
        error: error,
      );

  @override
  List<Object?> get props => [status, listings, error];
}

class ListingsCubit extends Cubit<ListingsState> {
  final ListingsRepository _repo;

  ListingsCubit({ListingsRepository? repo})
      : _repo = repo ?? ListingsRepository(),
        super(const ListingsState());

  Future<void> load() async {
    emit(state.copyWith(status: ListingsStatus.loading));
    try {
      final listings = await _repo.listMine();
      emit(state.copyWith(status: ListingsStatus.loaded, listings: listings));
    } catch (e) {
      emit(state.copyWith(
        status: ListingsStatus.error,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> toggleActive(String id, bool isActive) async {
    final updated = await _repo.setActive(id, isActive);
    emit(state.copyWith(
      listings:
          state.listings.map((l) => l.id == id ? updated : l).toList(),
    ));
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    await load();
  }
}
