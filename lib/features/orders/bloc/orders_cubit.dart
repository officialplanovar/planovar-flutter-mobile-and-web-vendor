import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/models/tracking_order_model.dart';
import '../data/bookings_repository.dart';

enum OrdersStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderModel> orders;
  final List<TrackingOrderModel> tracking;
  final InboxSummary summary;
  final String? error;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.tracking = const [],
    this.summary = const InboxSummary(),
    this.error,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderModel>? orders,
    List<TrackingOrderModel>? tracking,
    InboxSummary? summary,
    String? error,
  }) =>
      OrdersState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        tracking: tracking ?? this.tracking,
        summary: summary ?? this.summary,
        error: error,
      );

  @override
  List<Object?> get props => [status, orders, tracking, summary, error];
}

class OrdersCubit extends Cubit<OrdersState> {
  final BookingsRepository _repo;

  OrdersCubit({BookingsRepository? repo})
      : _repo = repo ?? BookingsRepository(),
        super(const OrdersState());

  Future<void> load() async {
    emit(state.copyWith(status: OrdersStatus.loading));
    try {
      final results = await Future.wait([
        _repo.listMine(),
        _repo.inboxSummary(),
        _repo.tracking(),
      ]);
      emit(state.copyWith(
        status: OrdersStatus.loaded,
        orders: results[0] as List<OrderModel>,
        summary: results[1] as InboxSummary,
        tracking: results[2] as List<TrackingOrderModel>,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> confirm(String id) async {
    await _repo.confirm(id);
    await load();
  }

  Future<void> reject(String id, {String? reason}) async {
    await _repo.reject(id, reason: reason);
    await load();
  }

  /// Accept a direct product/rental order request (creates the invoice).
  Future<void> acceptOrder(String id) async {
    await _repo.acceptOrder(id);
    await load();
  }

  /// Decline a direct product/rental order request.
  Future<void> declineOrder(String id) async {
    await _repo.declineOrder(id);
    await load();
  }

  Future<void> complete(String id) async {
    await _repo.complete(id);
    await load();
  }
}
