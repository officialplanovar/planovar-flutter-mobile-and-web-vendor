import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../vendor/data/vendor_repository.dart';
import '../../subscription/data/subscription_repository.dart';

enum SetupStatus { idle, submitting, success, error }

class SetupState extends Equatable {
  final SetupStatus status;
  final String? error;
  final String? checkoutUrl;
  final String? paymentReference;

  const SetupState({
    this.status = SetupStatus.idle,
    this.error,
    this.checkoutUrl,
    this.paymentReference,
  });

  SetupState copyWith({
    SetupStatus? status,
    String? error,
    String? checkoutUrl,
    String? paymentReference,
  }) =>
      SetupState(
        status: status ?? this.status,
        error: error,
        checkoutUrl: checkoutUrl ?? this.checkoutUrl,
        paymentReference: paymentReference ?? this.paymentReference,
      );

  @override
  List<Object?> get props => [status, error, checkoutUrl, paymentReference];
}

/// Collects the vendor onboarding wizard data across screens and submits it:
/// onboard → subscribe (if a paid/free plan chosen) → submit KYC (if provided).
/// Provided at app root so each setup screen can `context.read<SetupCubit>()`.
class SetupCubit extends Cubit<SetupState> {
  /// Paystack redirects here after a paid-plan payment; the in-app WebView
  /// watches for it to know checkout finished.
  static const paymentCallbackUrl = 'https://planovar.app/payment/complete';

  final VendorRepository _vendors;
  final SubscriptionRepository _subscriptions;

  SetupCubit({VendorRepository? vendors, SubscriptionRepository? subscriptions})
      : _vendors = vendors ?? VendorRepository(),
        _subscriptions = subscriptions ?? SubscriptionRepository(),
        super(const SetupState());

  // ── collected draft ──
  String? businessType; // LICENSED | FREELANCER
  String vendorType = 'BOTH';
  String? description;
  List<String> tags = const [];
  String? logoUrl;
  String country = 'Nigeria';
  String? city;
  String? planId;
  String billingCycle = 'MONTHLY';
  String? ninUrl;
  String? cacUrl;

  void setBusinessType(String uiValue) =>
      businessType = uiValue == 'licensed' ? 'LICENSED' : 'FREELANCER';

  void setProfile({
    String? description,
    required Set<String> tags,
    String? logoUrl,
    String? proofUrl,
  }) {
    this.description = description;
    this.tags = tags.toList();
    this.logoUrl = logoUrl;
    // "Proof of ownership" is the business-registration doc (CAC). It flows to
    // the KYC submission alongside the NIN collected on the dedicated KYC step.
    if (proofUrl != null && proofUrl.isNotEmpty) cacUrl = proofUrl;
  }

  void setLocation({
    required String country,
    String? city,
    required String vendorType,
  }) {
    this.country = country;
    this.city = city;
    this.vendorType = vendorType == 'products'
        ? 'PRODUCTS'
        : vendorType == 'services'
            ? 'SERVICES'
            : 'BOTH';
  }

  void setPlan(String? planId) => this.planId = planId;

  void setKyc({String? ninUrl, String? cacUrl}) {
    this.ninUrl = ninUrl;
    this.cacUrl = cacUrl;
  }

  Future<void> submit({required String businessName, String? deviceId}) async {
    emit(state.copyWith(status: SetupStatus.submitting));
    try {
      final name = businessName.trim().isEmpty ? 'Vendor' : businessName.trim();
      await _vendors.onboard(
        businessName: name,
        slug: _slugify(name),
        businessType: businessType,
        vendorType: vendorType,
        description: description,
        logoUrl: logoUrl,
        location: {'country': country, if (city != null) 'city': city},
        tags: tags,
      );

      String? checkoutUrl;
      String? paymentReference;
      if (planId != null) {
        try {
          final res = await _subscriptions.subscribe(
            planId: planId!,
            billingCycle: billingCycle,
            deviceId: deviceId,
            callbackUrl: paymentCallbackUrl,
          );
          checkoutUrl = res['checkoutUrl'] as String?;
          paymentReference = res['reference'] as String?;
        } catch (e) {
          // Resuming/redoing setup: an active subscription already exists — that's
          // fine, don't abort the rest of the flow (KYC).
          if (!e.toString().toLowerCase().contains('active subscription')) {
            rethrow;
          }
        }
      }

      if (ninUrl != null && ninUrl!.isNotEmpty) {
        await _vendors.submitKyc(ninDocumentUrl: ninUrl!, cacDocumentUrl: cacUrl);
      }

      emit(state.copyWith(
        status: SetupStatus.success,
        checkoutUrl: checkoutUrl,
        paymentReference: paymentReference,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SetupStatus.error,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Lightweight post-checkout verification — re-fetches the live subscription
  /// and returns its status (e.g. `active` / `trialing`), or null if none/error.
  Future<String?> currentSubscriptionStatus() async {
    try {
      final sub = await _subscriptions.getMySubscription();
      return sub?['status'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Confirm a paid plan's payment by Paystack reference; activates it on success.
  Future<void> verifyPayment(String reference) =>
      _subscriptions.verify(reference);

  String _slugify(String s) => s
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'(^-+)|(-+$)'), '');
}
