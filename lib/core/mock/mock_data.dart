import 'package:flutter/material.dart';
import '../../shared/models/vendor_model.dart';
import '../../shared/models/listing_model.dart';
import '../../shared/models/quote_model.dart';
import '../../shared/models/quote_line_item_model.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/message_model.dart';
import '../../shared/models/payout_model.dart';
import '../../shared/models/analytics_model.dart';
import '../../shared/models/top_listing_item_model.dart';
import '../../shared/models/notification_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/tracking_order_model.dart';

class MockData {
  // ─── Current Vendor User ──────────────────────────────────────────────────────
  static final currentUser = const UserModel(
    id: 'user-vendor-001',
    name: 'Chidinma Okafor',
    email: 'chidinma@sugareddreams.ng',
    phone: '+2348022334455',
    role: 'vendor',
    image: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
  );

  // ─── Current Vendor Profile ───────────────────────────────────────────────────
  static const currentVendor = VendorModel(
    id: 'vendor-001',
    businessName: 'Sugared Dreams',
    slug: 'sugared-dreams',
    description:
        'Premium cake and dessert studio based in Lagos. We create edible masterpieces for '
        'weddings, birthdays, corporate events, and every celebration in between. '
        'Our team of pastry artisans crafts each piece with imported couverture chocolate, '
        'French butter, and seasonal Nigerian fruits. Over 200 five-star reviews.',
    coverUrl:
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
    phone: '+2348022334455',
    email: 'chidinma@sugareddreams.ng',
    tags: ['Cakes', 'Desserts', 'Wedding Cakes', 'Custom Cakes', 'Confectionery'],
    portfolioUrls: [
      'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=600',
      'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=600',
      'https://images.unsplash.com/photo-1557308536-ee471ef2c390?w=600',
      'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=600',
      'https://images.unsplash.com/photo-1562777717-dc6984f65a63?w=600',
      'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=600',
    ],
    ratingAvg: 4.7,
    reviewCount: 200,
    subscriptionTier: 'featured',
    isVerified: true,
    location: {
      'city': 'Lagos',
      'state': 'Lagos State',
      'country': 'Nigeria',
      'address': '14 Adeola Odeku Street, Victoria Island, Lagos',
    },
  );

  // ─── Dashboard Quick Stats ────────────────────────────────────────────────────
  static const int activeEvents = 12;
  static const int pendingRequests = 7;
  static const double thisMonthEarnings = 430000;
  static const double ratingAvg = 4.7;

  // ─── Listings ────────────────────────────────────────────────────────────────
  static final List<ListingModel> listings = [
    ListingModel(
      id: 'lst-001',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: '3-Tier Wedding Cake',
      description:
          'Handcrafted 3-tier wedding cakes in any flavour — champagne & strawberry, red velvet, '
          'vanilla bean, or dark chocolate. Fondant or buttercream finish with sugar flower accents.',
      pricingType: 'QUOTE',
      isActive: true,
      isFeatured: true,
      ratingAvg: 4.9,
      reviewCount: 87,
      viewCount: 243,
      createdAt: DateTime(2025, 3, 10),
      mediaUrls: [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
        'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=800',
        'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
    ),
    ListingModel(
      id: 'lst-002',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Birthday Cake (Custom)',
      description:
          'Fully customisable birthday cakes — sculpted novelty cakes, photo cakes, themed cakes. '
          'Available in half, single, and double kg. Delivery available across Lagos.',
      pricingType: 'FIXED',
      basePrice: 18000,
      isActive: true,
      isFeatured: false,
      ratingAvg: 4.8,
      reviewCount: 54,
      viewCount: 187,
      createdAt: DateTime(2025, 3, 15),
      mediaUrls: [
        'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800',
        'https://images.unsplash.com/photo-1557308536-ee471ef2c390?w=600',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800',
    ),
    ListingModel(
      id: 'lst-003',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Dessert Table Setup',
      description:
          'Stunning styled dessert tables for events of all sizes. Includes cupcakes, cake pops, '
          'macarons, chocolate truffles, and a centrepiece cake. Delivery and setup included.',
      pricingType: 'FIXED',
      basePrice: 180000,
      isActive: true,
      isFeatured: false,
      ratingAvg: 4.7,
      reviewCount: 33,
      viewCount: 142,
      createdAt: DateTime(2025, 4, 2),
      mediaUrls: [
        'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
    ),
    ListingModel(
      id: 'lst-004',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Cake Tasting Session',
      description:
          'A 1-hour private tasting session for brides and couples. Sample up to 5 cake flavours '
          'with curated fillings and frosting combos. Held at our studio in VI.',
      pricingType: 'FIXED',
      basePrice: 15000,
      isActive: true,
      isFeatured: false,
      ratingAvg: 5.0,
      reviewCount: 21,
      viewCount: 99,
      createdAt: DateTime(2025, 4, 10),
      mediaUrls: [
        'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=800',
    ),
    ListingModel(
      id: 'lst-005',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Gold Cake Stand Rental',
      description:
          'Premium gold 5-tier cake stand available for rental. Perfect for wedding cake displays '
          'and dessert tables. Deposit required.',
      pricingType: 'FIXED',
      basePrice: 25000,
      isActive: true,
      isFeatured: false,
      isRentable: true,
      perDayRate: 8000,
      depositAmount: 20000,
      ratingAvg: 4.6,
      reviewCount: 41,
      viewCount: 41,
      createdAt: DateTime(2025, 5, 1),
      mediaUrls: [
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
        'https://images.unsplash.com/photo-1478146059778-26028b07395a?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
    ),
    ListingModel(
      id: 'lst-006',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Gender Reveal Cake',
      description:
          'Surprise inside gender reveal cakes with hidden pink or blue coloured sponge. '
          'Order with or without gender knowledge — we keep the secret!',
      pricingType: 'FIXED',
      basePrice: 35000,
      isActive: true,
      isFeatured: false,
      ratingAvg: 4.8,
      reviewCount: 14,
      viewCount: 76,
      createdAt: DateTime(2025, 5, 12),
      mediaUrls: [
        'https://images.unsplash.com/photo-1562777717-dc6984f65a63?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1562777717-dc6984f65a63?w=800',
    ),
    ListingModel(
      id: 'lst-007',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Cupcake Bouquet',
      description:
          'Beautifully arranged cupcake bouquets — ideal for birthdays, anniversaries, and '
          'Valentine\'s Day. Choose your flavours and frosting colours.',
      pricingType: 'FIXED',
      basePrice: 12000,
      isActive: false,
      isFeatured: false,
      ratingAvg: 4.5,
      reviewCount: 8,
      viewCount: 55,
      createdAt: DateTime(2025, 6, 1),
      mediaUrls: [
        'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?w=800',
        'https://images.unsplash.com/photo-1587668178277-295251f900ce?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?w=800',
    ),
    ListingModel(
      id: 'lst-008',
      vendorId: 'vendor-001',
      categoryId: 'cat-12',
      categoryName: 'Confectionery',
      title: 'Corporate Branded Cake',
      description:
          'Logo-branded cakes for corporate events, product launches, and office celebrations. '
          'Minimum order 1kg. We match your brand colours and include edible logo printing.',
      pricingType: 'QUOTE',
      isActive: true,
      isFeatured: false,
      ratingAvg: 4.6,
      reviewCount: 19,
      viewCount: 88,
      createdAt: DateTime(2025, 6, 20),
      mediaUrls: [
        'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=800',
      ],
      coverUrl: 'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=800',
    ),
  ];

  // ─── Pending Quote Requests ───────────────────────────────────────────────────
  static final List<QuoteModel> pendingQuotes = [
    QuoteModel(
      id: 'qr-001',
      bookingId: 'bk-010',
      vendorId: 'vendor-001',
      clientId: 'client-011',
      clientName: 'Amaka Obi',
      clientImage:
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      eventName: 'White Wedding',
      eventDate: DateTime(2026, 9, 12),
      status: 'PENDING',
      totalAmount: 0,
      notes:
          'We need a 5-tier wedding cake for 300 guests — ivory and champagne gold theme. '
          'Please include delivery to Eko Hotel, VI.',
      lineItems: const [],
      createdAt: DateTime(2026, 5, 22, 9, 14),
    ),
    QuoteModel(
      id: 'qr-002',
      bookingId: 'bk-011',
      vendorId: 'vendor-001',
      clientId: 'client-012',
      clientName: 'Chinedu Eze',
      clientImage:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      eventName: 'Birthday Party (30th)',
      eventDate: DateTime(2026, 8, 5),
      status: 'PENDING',
      totalAmount: 0,
      notes: 'Looking for a sculpted football cake + 60 themed cupcakes. Red & gold colours.',
      lineItems: const [],
      createdAt: DateTime(2026, 5, 21, 14, 30),
    ),
    QuoteModel(
      id: 'qr-003',
      bookingId: 'bk-012',
      vendorId: 'vendor-001',
      clientId: 'client-013',
      clientName: 'Fatima Bello',
      clientImage:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      eventName: 'Bridal Shower',
      eventDate: DateTime(2026, 7, 18),
      status: 'SENT',
      totalAmount: 85000,
      notes: 'Dessert table for 40 ladies — blush pink and white theme.',
      lineItems: const [
        QuoteLineItem(
            id: 'li-001', label: 'Mini cupcakes × 60', amount: 30000),
        QuoteLineItem(
            id: 'li-002', label: 'Macarons × 40', amount: 24000),
        QuoteLineItem(
            id: 'li-003', label: 'Cake pops × 30', amount: 15000),
        QuoteLineItem(
            id: 'li-004', label: 'Styled table setup', amount: 16000),
      ],
      createdAt: DateTime(2026, 5, 20, 10, 0),
    ),
    QuoteModel(
      id: 'qr-004',
      bookingId: 'bk-013',
      vendorId: 'vendor-001',
      clientId: 'client-014',
      clientName: 'Emeka Johnson',
      clientImage: null,
      eventName: 'Corporate Dinner',
      eventDate: DateTime(2026, 6, 30),
      status: 'PENDING',
      totalAmount: 0,
      notes:
          'Need 5 identical branded cakes for our product launch. Logo and colours will be shared.',
      lineItems: const [],
      createdAt: DateTime(2026, 5, 19, 16, 45),
    ),
    QuoteModel(
      id: 'qr-005',
      bookingId: 'bk-014',
      vendorId: 'vendor-001',
      clientId: 'client-015',
      clientName: 'Ngozi Adeyemi',
      clientImage:
          'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=200',
      eventName: 'Gender Reveal Party',
      eventDate: DateTime(2026, 7, 4),
      status: 'PENDING',
      totalAmount: 0,
      notes:
          'Gender reveal cake — we want to be surprised too. Our ob-gyn will tell you the gender. '
          'Keep it a secret from us please! Elegant design for 40 people.',
      lineItems: const [],
      createdAt: DateTime(2026, 5, 18, 11, 20),
    ),
    QuoteModel(
      id: 'qr-006',
      bookingId: 'bk-015',
      vendorId: 'vendor-001',
      clientId: 'client-016',
      clientName: 'Tunde Afolabi',
      clientImage: null,
      eventName: 'Anniversary Dinner',
      eventDate: DateTime(2026, 6, 14),
      status: 'PENDING',
      totalAmount: 0,
      notes: '2-tier red velvet anniversary cake, romantic theme, roses on top.',
      lineItems: const [],
      createdAt: DateTime(2026, 5, 17, 8, 0),
    ),
  ];

  // ─── Active & Recent Bookings ─────────────────────────────────────────────────
  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'bk-001',
      clientId: 'client-001',
      clientName: 'Adaeze Okonkwo',
      clientImage:
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      vendorId: 'vendor-001',
      listingId: 'lst-001',
      listingTitle: '3-Tier Wedding Cake',
      eventName: 'White Wedding',
      eventDate: DateTime(2026, 8, 15),
      status: 'CONFIRMED',
      totalAmount: 320000,
      createdAt: DateTime(2026, 4, 10),
      escrowType: 'split',
    ),
    BookingModel(
      id: 'bk-002',
      clientId: 'client-002',
      clientName: 'Uche Nwosu',
      clientImage:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      vendorId: 'vendor-001',
      listingId: 'lst-004',
      listingTitle: 'Cake Tasting Session',
      eventName: 'Tasting — Wedding prep',
      eventDate: DateTime(2026, 5, 23, 9, 0),
      status: 'ACTIVE',
      totalAmount: 15000,
      createdAt: DateTime(2026, 5, 15),
      escrowType: 'full',
    ),
    BookingModel(
      id: 'bk-003',
      clientId: 'client-003',
      clientName: 'Kemi Afolabi',
      clientImage:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      vendorId: 'vendor-001',
      listingId: 'lst-002',
      listingTitle: 'Birthday Cake (Custom)',
      eventName: '50th Birthday Party',
      eventDate: DateTime(2026, 6, 5),
      status: 'PENDING',
      totalAmount: 35000,
      createdAt: DateTime(2026, 5, 10),
      escrowType: null,
    ),
    BookingModel(
      id: 'bk-004',
      clientId: 'client-004',
      clientName: 'Babatunde Owolabi',
      clientImage: null,
      vendorId: 'vendor-001',
      listingId: 'lst-003',
      listingTitle: 'Dessert Table Setup',
      eventName: 'Baby Shower',
      eventDate: DateTime(2026, 5, 28),
      status: 'CONFIRMED',
      totalAmount: 180000,
      createdAt: DateTime(2026, 5, 5),
      escrowType: 'split',
    ),
    BookingModel(
      id: 'bk-005',
      clientId: 'client-005',
      clientName: 'Chisom Igwe',
      clientImage:
          'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=200',
      vendorId: 'vendor-001',
      listingId: 'lst-001',
      listingTitle: '3-Tier Wedding Cake',
      eventName: 'Traditional Wedding',
      eventDate: DateTime(2026, 3, 22),
      status: 'COMPLETED',
      totalAmount: 280000,
      createdAt: DateTime(2026, 2, 10),
      escrowType: 'split',
    ),
    BookingModel(
      id: 'bk-006',
      clientId: 'client-006',
      clientName: 'Sola Adebayo',
      clientImage: null,
      vendorId: 'vendor-001',
      listingId: 'lst-006',
      listingTitle: 'Gender Reveal Cake',
      eventName: 'Gender Reveal Party',
      eventDate: DateTime(2026, 4, 14),
      status: 'COMPLETED',
      totalAmount: 35000,
      createdAt: DateTime(2026, 3, 30),
      escrowType: 'full',
    ),
    BookingModel(
      id: 'bk-007',
      clientId: 'client-007',
      clientName: 'Ifeoma Agu',
      clientImage:
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      vendorId: 'vendor-001',
      listingId: 'lst-002',
      listingTitle: 'Birthday Cake (Custom)',
      eventName: '1st Birthday',
      eventDate: DateTime(2026, 2, 5),
      status: 'CANCELLED',
      totalAmount: 18000,
      createdAt: DateTime(2026, 1, 20),
      escrowType: null,
    ),
  ];

  // ─── Analytics ────────────────────────────────────────────────────────────────
  static final analyticsData = const AnalyticsModel(
    totalEarnings: 430000,
    totalOrders: 23,
    profileViews: 1204,
    bookingRate: 0.40,
    weeklyEarnings: [34000, 56000, 23000, 78000, 120000, 89000, 30000],
    topListings: [
      TopListingItem(title: '3-Tier Wedding Cake', views: 243),
      TopListingItem(title: 'Cake Tasting Session', views: 99),
      TopListingItem(title: 'Gold Cake Stand Rental', views: 41),
    ],
  );

  // ─── Payouts ──────────────────────────────────────────────────────────────────
  static const double availableBalance = 430000;
  static const double thisMonthPayout = 430000;
  static const double availableForPayout = 195000;

  static final List<PayoutModel> recentPayouts = [
    PayoutModel(
      id: 'pay-001',
      amount: 280000,
      status: 'PAID',
      vendorId: 'vendor-001',
      description: 'Payout for booking #bk-005 (Traditional Wedding cake)',
      createdAt: DateTime(2026, 3, 25),
      bankName: 'Zenith Bank',
      accountNumber: '**** 4421',
    ),
    PayoutModel(
      id: 'pay-002',
      amount: 35000,
      status: 'PAID',
      vendorId: 'vendor-001',
      description: 'Payout for booking #bk-006 (Gender Reveal Cake)',
      createdAt: DateTime(2026, 4, 17),
      bankName: 'Zenith Bank',
      accountNumber: '**** 4421',
    ),
    PayoutModel(
      id: 'pay-003',
      amount: 195000,
      status: 'PENDING',
      vendorId: 'vendor-001',
      description: 'Pending payout — 3 completed orders (Apr–May 2026)',
      createdAt: DateTime(2026, 5, 20),
      bankName: 'Zenith Bank',
      accountNumber: '**** 4421',
    ),
    PayoutModel(
      id: 'pay-004',
      amount: 18000,
      status: 'FAILED',
      vendorId: 'vendor-001',
      description: 'Failed payout — bank details mismatch',
      createdAt: DateTime(2026, 4, 30),
      bankName: 'Zenith Bank',
      accountNumber: '**** 4421',
    ),
    PayoutModel(
      id: 'pay-005',
      amount: 120000,
      status: 'PAID',
      vendorId: 'vendor-001',
      description: 'Payout for March bookings batch',
      createdAt: DateTime(2026, 3, 10),
      bankName: 'Zenith Bank',
      accountNumber: '**** 4421',
    ),
  ];

  // ─── Conversations (from clients) ─────────────────────────────────────────────
  static final List<ConversationModel> conversations = [
    // ── State 1: Quote Requested (client initiated, no quote yet) ─────────────
    ConversationModel(
      id: 'conv-001',
      participantName: 'Esther Howard',
      participantImage: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      lastMessage: 'Quote Requested - Wedding Setup',
      statusLabel: 'Quote Requested - Wedding Setup',
      statusType: 'quote_requested',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 1)),
      unreadCount: 1,
      quoteStatus: null,
      status: 'active',
      isKycRequired: false,
      ratingAvg: 4.7,
      isOnline: true,
      eventName: 'Wedding',
      eventDate: DateTime(2026, 3, 14),
      type: 'direct',
    ),

    // ── State 2: Quote Sent (vendor sent a quote, awaiting client acceptance) ─
    ConversationModel(
      id: 'conv-002',
      participantName: 'Marvin McKinney',
      participantImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      lastMessage: 'Quote sent – awaiting your review',
      statusLabel: 'Quote Sent - Pending Approval',
      statusType: null,
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      quoteStatus: 'QUOTE_SENT',
      status: 'payment_pending',
      isKycRequired: false,
      ratingAvg: 4.6,
      isOnline: false,
      eventName: 'Corporate Dinner',
      eventDate: DateTime(2026, 6, 10),
      type: 'direct',
    ),

    // ── State 3: Quote Accepted (client accepted, invoice not yet sent) ───────
    ConversationModel(
      id: 'conv-003',
      participantName: 'Ronald Richards',
      participantImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      lastMessage: 'Quote accepted - Invoice Pending',
      statusLabel: 'Quote accepted - Invoice Pending',
      statusType: 'quote_accepted',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      quoteStatus: 'QUOTE_ACCEPTED',
      status: 'confirmed',
      isKycRequired: false,
      ratingAvg: 4.5,
      isOnline: false,
      eventName: 'Birthday Party',
      eventDate: DateTime(2026, 4, 20),
      type: 'direct',
    ),

    // ── State 4: Invoice Sent (full flow — invoice in transit) ────────────────
    ConversationModel(
      id: 'conv-004',
      participantName: 'Courtney Henry',
      participantImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      lastMessage: 'Looking forward to the cake tasting…',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      quoteStatus: 'INVOICE_SENT',
      status: 'payment_pending',
      isKycRequired: false,
      ratingAvg: 4.8,
      isOnline: true,
      eventName: 'Cake Tasting',
      eventDate: DateTime(2026, 5, 30),
      type: 'direct',
    ),

    // ── State 5: KYC Incomplete (vendor must complete KYC before acting) ──────
    ConversationModel(
      id: 'conv-005',
      participantName: 'Robert Fox',
      participantImage: 'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=200',
      lastMessage: 'How far chairman, you go fit do this for me?',
      lastMessageAt: DateTime(2026, 5, 21),
      unreadCount: 0,
      quoteStatus: null,
      status: 'active',
      isKycRequired: true,
      ratingAvg: 4.3,
      isOnline: false,
      eventName: 'Engagement Party',
      eventDate: DateTime(2026, 7, 5),
      type: 'direct',
    ),

    // ── State 6: Completed (payment received, job done) ───────────────────────
    ConversationModel(
      id: 'conv-006',
      participantName: 'Bessie Cooper',
      participantImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
      lastMessage: 'Thank you so much! Everything was perfect.',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
      quoteStatus: 'INVOICE_SENT',
      status: 'completed',
      isKycRequired: false,
      ratingAvg: 4.9,
      isOnline: false,
      eventName: 'Bridal Shower',
      eventDate: DateTime(2026, 5, 10),
      type: 'direct',
    ),

    // ── State 7: Plain chat (no quote flow started) ───────────────────────────
    ConversationModel(
      id: 'conv-007',
      participantName: 'Eleanor Pena',
      participantImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      lastMessage: 'That sounds perfect. When would you be available?',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 4)),
      unreadCount: 0,
      quoteStatus: null,
      status: 'active',
      isKycRequired: false,
      ratingAvg: 4.4,
      isOnline: true,
      eventName: 'Anniversary Dinner',
      eventDate: DateTime(2026, 8, 22),
      type: 'direct',
    ),

    // ── State 8: Disputed ─────────────────────────────────────────────────────
    ConversationModel(
      id: 'conv-008',
      participantName: 'Devon Lane',
      participantImage: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200',
      lastMessage: 'I paid for everything and nothing showed up.',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 6)),
      unreadCount: 2,
      quoteStatus: 'INVOICE_SENT',
      status: 'disputed',
      isKycRequired: false,
      ratingAvg: 3.8,
      isOnline: false,
      eventName: 'Graduation Party',
      eventDate: DateTime(2026, 5, 18),
      type: 'direct',
    ),

    // ── State 9: Support conversation ─────────────────────────────────────────
    ConversationModel(
      id: 'conv-009',
      participantName: 'Planovar Support',
      participantImage: 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=200',
      lastMessage: 'Hi there! How can we help you today?',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      quoteStatus: null,
      status: 'active',
      isKycRequired: false,
      ratingAvg: 5.0,
      isOnline: true,
      type: 'support',
    ),

    // ── State 10: Group conversation ──────────────────────────────────────────
    ConversationModel(
      id: 'conv-010',
      participantName: 'Ngozi, Chidi + 4 others',
      participantImage: null,
      lastMessage: 'Chidi: Confirmed! The venue is booked.',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 3,
      quoteStatus: null,
      status: 'confirmed',
      isKycRequired: false,
      ratingAvg: 4.6,
      isOnline: false,
      eventName: 'Gold & White Wedding',
      eventDate: DateTime(2026, 9, 12),
      type: 'group',
      isGroup: true,
      groupName: 'Gold & White Wedding Team',
      groupParticipantCount: 6,
      groupAvatars: [
        'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      ],
    ),
  ];

  // ─── Orders ───────────────────────────────────────────────────────────────────
  static final List<OrderModel> orders = [
    // order-001: confirmed, invoice accepted, payment pending
    OrderModel(
      id: 'order-001',
      orderNumber: 'EF-2026-0341',
      eventName: 'Our Wedding',
      serviceName: 'Full-day wedding photography',
      vendorName: 'Lumière Photography',
      clientName: 'Anita Chimdi',
      clientImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      thumbnailUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
      eventDate: DateTime(2026, 3, 14),
      eventLocation: 'Festac, Lokogoma Abuja',
      eventVenue: 'Eko Hotel',
      guestCount: 200,
      category: 'Wedding Decoration',
      duration: '2 Hours',
      additionalInfo: 'Please use butter for the frosting instead of artificial cream',
      clientRating: 4.7,
      accountNumber: '2938*********',
      bankName: 'Zenith Bank',
      amount: 300000,
      status: 'confirmed',
      invoiceAcceptedAt: DateTime(2026, 2, 14),
      paymentConfirmedAt: null,
      serviceDeliveredAt: null,
      reviewedAt: null,
    ),

    // order-002: confirmed, invoice accepted + payment confirmed, service pending
    OrderModel(
      id: 'order-002',
      orderNumber: 'EF-2026-0342',
      eventName: 'Our Wedding',
      serviceName: 'Full-day wedding photography',
      vendorName: 'Lumière Photography',
      clientName: 'Anita Chimdi',
      clientImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      thumbnailUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
      eventDate: DateTime(2026, 3, 14),
      eventLocation: 'Festac, Lokogoma Abuja',
      eventVenue: 'Eko Hotel',
      guestCount: 200,
      category: 'Wedding Decoration',
      duration: '2 Hours',
      additionalInfo: 'Please use butter for the frosting instead of artificial cream',
      clientRating: 4.7,
      accountNumber: '2938*********',
      bankName: 'Zenith Bank',
      amount: 300000,
      status: 'confirmed',
      invoiceAcceptedAt: DateTime(2026, 2, 14),
      paymentConfirmedAt: DateTime(2026, 2, 20),
      serviceDeliveredAt: null,
      reviewedAt: null,
    ),

    // order-003: completed, all steps done except review
    OrderModel(
      id: 'order-003',
      orderNumber: 'EF-2026-0289',
      eventName: 'Birthday Bash',
      serviceName: 'DJ & Sound System',
      vendorName: 'Lumière Photography',
      clientName: 'Kolade Bello',
      clientImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      thumbnailUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400',
      eventDate: DateTime(2026, 5, 14),
      eventLocation: 'Lekki Phase 1, Lagos',
      eventVenue: 'The Podium',
      guestCount: 150,
      category: 'Entertainment',
      duration: '5 Hours',
      additionalInfo: null,
      clientRating: 4.5,
      accountNumber: '1234*********',
      bankName: 'GTBank',
      amount: 180000,
      status: 'completed',
      invoiceAcceptedAt: DateTime(2026, 5, 14),
      paymentConfirmedAt: DateTime(2026, 5, 14),
      serviceDeliveredAt: DateTime(2026, 5, 14),
      reviewedAt: null,
    ),

    // order-004: completed, ALL steps done including review
    OrderModel(
      id: 'order-004',
      orderNumber: 'EF-2026-0290',
      eventName: 'Birthday Bash',
      serviceName: 'DJ & Sound System',
      vendorName: 'Lumière Photography',
      clientName: 'Kolade Bello',
      clientImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      thumbnailUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400',
      eventDate: DateTime(2026, 5, 14),
      eventLocation: 'Lekki Phase 1, Lagos',
      eventVenue: 'The Podium',
      guestCount: 150,
      category: 'Entertainment',
      duration: '5 Hours',
      additionalInfo: null,
      clientRating: 4.5,
      accountNumber: '1234*********',
      bankName: 'GTBank',
      amount: 180000,
      status: 'completed',
      invoiceAcceptedAt: DateTime(2026, 5, 14),
      paymentConfirmedAt: DateTime(2026, 5, 14),
      serviceDeliveredAt: DateTime(2026, 5, 14),
      reviewedAt: DateTime(2026, 5, 16),
    ),

    // order-005: cancelled
    OrderModel(
      id: 'order-005',
      orderNumber: 'EF-2026-0210',
      eventName: 'Engagement Party',
      serviceName: 'Event Decoration',
      vendorName: 'Lumière Photography',
      clientName: 'Fatima Abubakar',
      clientImage: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      thumbnailUrl: 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400',
      eventDate: DateTime(2026, 4, 5),
      eventLocation: 'Wuse 2, Abuja',
      eventVenue: 'Sheraton Hotel',
      guestCount: 80,
      category: 'Decoration',
      duration: '3 Hours',
      additionalInfo: null,
      clientRating: 4.2,
      accountNumber: '5678*********',
      bankName: 'Access Bank',
      amount: 120000,
      status: 'cancelled',
      invoiceAcceptedAt: DateTime(2026, 3, 1),
      paymentConfirmedAt: null,
      serviceDeliveredAt: null,
      reviewedAt: null,
    ),
  ];

  // ─── Tracking Orders ─────────────────────────────────────────────────────────
  static final List<TrackingOrderModel> trackingOrders = [
    // track-001: Purchase — newly placed, needs vendor action (Accept/Decline)
    TrackingOrderModel(
      id: 'track-001',
      orderNumber: 'PO-2026-1041',
      orderType: 'purchase',
      productName: 'Gold Candelabra Set (x10)',
      productImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      clientName: 'Amara Nwosu',
      clientImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      orderDate: DateTime(2026, 5, 25),
      status: 'requested',
      amount: 45000,
      platformFee: 2250,
      deliveryCost: 3500,
      hasDelivery: true,
      deliveryAddress: '14 Bourdillon Road, Ikoyi, Lagos',
      deliveryRoute: 'Lagos → Ikoyi',
      orderPlacedAt: DateTime(2026, 5, 25, 9, 14),
    ),

    // track-002: Purchase — vendor confirmed, needs to mark "In Production"
    TrackingOrderModel(
      id: 'track-002',
      orderNumber: 'PO-2026-0998',
      orderType: 'purchase',
      productName: 'White Drape Backdrop (3m × 6m)',
      productImage: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400',
      clientName: 'Tunde Fashola',
      clientImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      orderDate: DateTime(2026, 5, 24),
      status: 'confirmed',
      amount: 28000,
      platformFee: 1400,
      deliveryCost: 2500,
      hasDelivery: true,
      deliveryAddress: '3 Ahmadu Bello Way, Victoria Island, Lagos',
      deliveryRoute: 'Lagos → VI',
      orderPlacedAt: DateTime(2026, 5, 24, 10, 0),
      vendorConfirmedAt: DateTime(2026, 5, 24, 11, 30),
    ),

    // track-003: Purchase — in production, ready to "Send for Delivery"
    TrackingOrderModel(
      id: 'track-003',
      orderNumber: 'PO-2026-0951',
      orderType: 'purchase',
      productName: 'Floral Centrepiece Bundles (x20)',
      productImage: 'https://images.unsplash.com/photo-1490750967868-88df5691cc5e?w=400',
      clientName: 'Ngozi Okonkwo',
      clientImage: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      orderDate: DateTime(2026, 5, 23),
      status: 'in_production',
      amount: 62000,
      platformFee: 3100,
      deliveryCost: 4000,
      hasDelivery: true,
      deliveryAddress: '7 Ademola Adetokunbo Crescent, Wuse 2, Abuja',
      deliveryRoute: 'Lagos → Abuja',
      orderPlacedAt: DateTime(2026, 5, 23, 8, 0),
      vendorConfirmedAt: DateTime(2026, 5, 23, 9, 0),
      inProductionAt: DateTime(2026, 5, 23, 15, 0),
    ),

    // track-004: Purchase — out for delivery
    TrackingOrderModel(
      id: 'track-004',
      orderNumber: 'PO-2026-0910',
      orderType: 'purchase',
      productName: 'Crystal Chandelier Hire (Large)',
      productImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      clientName: 'Emeka Obi',
      clientImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      orderDate: DateTime(2026, 5, 22),
      status: 'out_for_delivery',
      amount: 95000,
      platformFee: 4750,
      deliveryCost: 6500,
      hasDelivery: true,
      deliveryAddress: 'Plot 1234 Usman Dan Fodio Road, Asokoro, Abuja',
      deliveryRoute: 'Lagos → Abuja',
      driverName: 'Chukwuemeka Eze',
      driverPhone: '+2348056781234',
      orderPlacedAt: DateTime(2026, 5, 22, 7, 30),
      vendorConfirmedAt: DateTime(2026, 5, 22, 9, 0),
      inProductionAt: DateTime(2026, 5, 22, 12, 0),
      outForDeliveryAt: DateTime(2026, 5, 24, 8, 0),
    ),

    // track-005: Purchase — delivered (completed)
    TrackingOrderModel(
      id: 'track-005',
      orderNumber: 'PO-2026-0860',
      orderType: 'purchase',
      productName: 'Custom Neon Sign – "Mr & Mrs"',
      productImage: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400',
      clientName: 'Bisi Adeyemi',
      clientImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      orderDate: DateTime(2026, 5, 20),
      status: 'delivered',
      amount: 38000,
      platformFee: 1900,
      deliveryCost: 2800,
      hasDelivery: true,
      deliveryAddress: '22 Kofo Abayomi Street, Victoria Island',
      deliveryRoute: 'Lagos → VI',
      driverName: 'Taiwo Olawale',
      driverPhone: '+2348022445566',
      orderPlacedAt: DateTime(2026, 5, 20, 10, 0),
      vendorConfirmedAt: DateTime(2026, 5, 20, 11, 0),
      inProductionAt: DateTime(2026, 5, 20, 14, 0),
      outForDeliveryAt: DateTime(2026, 5, 22, 8, 0),
      deliveredAt: DateTime(2026, 5, 23, 14, 30),
    ),

    // track-006: Rental — newly requested (Accept/Decline, no timeline yet)
    TrackingOrderModel(
      id: 'track-006',
      orderNumber: 'RN-2026-0503',
      orderType: 'rental',
      productName: 'Gold Tiffany Chair Set (x50)',
      productImage: 'https://images.unsplash.com/photo-1581539250439-c96689b516dd?w=400',
      clientName: 'Chinyere Okeke',
      clientImage: 'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=200',
      orderDate: DateTime(2026, 5, 25),
      status: 'requested',
      amount: 50000,
      platformFee: 2500,
      depositAmount: 10000,
      perDayRate: 25000,
      rentalDays: 2,
      pickupTime: DateTime(2026, 5, 28, 9, 0),
      returnByTime: DateTime(2026, 5, 30, 18, 0),
      orderPlacedAt: DateTime(2026, 5, 25, 14, 0),
    ),

    // track-007: Rental — payment confirmed, needs pickup confirmation
    TrackingOrderModel(
      id: 'track-007',
      orderNumber: 'RN-2026-0478',
      orderType: 'rental',
      productName: 'Photo Booth Machine (Premium)',
      productImage: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400',
      clientName: 'Damilola Adebayo',
      clientImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      orderDate: DateTime(2026, 5, 24),
      status: 'payment_confirmed',
      amount: 40000,
      platformFee: 2000,
      depositAmount: 8000,
      perDayRate: 40000,
      rentalDays: 1,
      pickupTime: DateTime(2026, 5, 26, 10, 0),
      returnByTime: DateTime(2026, 5, 27, 10, 0),
      hasDelivery: true,
      deliveryAddress: '5 Idejo Street, Victoria Island, Lagos',
      deliveryRoute: 'Lagos → VI',
      orderPlacedAt: DateTime(2026, 5, 24, 11, 0),
      paymentConfirmedAt: DateTime(2026, 5, 24, 16, 0),
    ),

    // track-008: Rental — pickup confirmed, sent for delivery
    TrackingOrderModel(
      id: 'track-008',
      orderNumber: 'RN-2026-0441',
      orderType: 'rental',
      productName: 'PA Sound System (2000W)',
      productImage: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400',
      clientName: 'Seun Kuti',
      clientImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      orderDate: DateTime(2026, 5, 23),
      status: 'out_for_delivery',
      amount: 35000,
      platformFee: 1750,
      depositAmount: 7000,
      perDayRate: 35000,
      rentalDays: 1,
      pickupTime: DateTime(2026, 5, 25, 9, 0),
      returnByTime: DateTime(2026, 5, 26, 9, 0),
      hasDelivery: true,
      deliveryAddress: '12 Awolowo Road, Ikoyi',
      deliveryRoute: 'Lagos → Ikoyi',
      driverName: 'Biodun Olatunji',
      driverPhone: '+2348011223344',
      orderPlacedAt: DateTime(2026, 5, 23, 9, 0),
      paymentConfirmedAt: DateTime(2026, 5, 23, 10, 0),
      pickupConfirmedAt: DateTime(2026, 5, 25, 9, 0),
      outForDeliveryAt: DateTime(2026, 5, 25, 10, 30),
    ),

    // track-009: Rental — active/out, awaiting return confirmation
    TrackingOrderModel(
      id: 'track-009',
      orderNumber: 'RN-2026-0399',
      orderType: 'rental',
      productName: 'LED Dance Floor (4m × 4m)',
      productImage: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
      clientName: 'Kemi Afolabi',
      clientImage: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      orderDate: DateTime(2026, 5, 21),
      status: 'pickup_confirmed',
      amount: 80000,
      platformFee: 4000,
      depositAmount: 16000,
      perDayRate: 40000,
      rentalDays: 2,
      pickupTime: DateTime(2026, 5, 23, 10, 0),
      returnByTime: DateTime(2026, 5, 25, 18, 0),
      orderPlacedAt: DateTime(2026, 5, 21, 8, 0),
      paymentConfirmedAt: DateTime(2026, 5, 21, 14, 0),
      pickupConfirmedAt: DateTime(2026, 5, 23, 10, 0),
    ),

    // track-010: Rental — fully completed, leave review
    TrackingOrderModel(
      id: 'track-010',
      orderNumber: 'RN-2026-0342',
      orderType: 'rental',
      productName: 'Stretch Limousine (8 hrs)',
      productImage: 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=400',
      clientName: 'Victor Onah',
      clientImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      orderDate: DateTime(2026, 5, 18),
      status: 'return_confirmed',
      amount: 120000,
      platformFee: 6000,
      depositAmount: 24000,
      perDayRate: 120000,
      rentalDays: 1,
      pickupTime: DateTime(2026, 5, 20, 12, 0),
      returnByTime: DateTime(2026, 5, 21, 20, 0),
      orderPlacedAt: DateTime(2026, 5, 18, 10, 0),
      paymentConfirmedAt: DateTime(2026, 5, 18, 15, 0),
      pickupConfirmedAt: DateTime(2026, 5, 20, 12, 0),
      returnConfirmedAt: DateTime(2026, 5, 21, 20, 30),
    ),
  ];

  // ─── Messages for conversations ───────────────────────────────────────────────
  static List<MessageModel> messagesForConversation(String conversationId) {
    if (conversationId == 'conv-001') {
      return [
        MessageModel(
          id: 'msg-c1-1',
          conversationId: 'conv-001',
          senderId: 'client-011',
          content: "Hi! We're planning a wedding for 200 guests on 14 March. Need a 3-tier fondant cake + table centerpieces for all tables.",
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: false,
        ),
      ];
    }
    if (conversationId == 'conv-002') {
      return [
        MessageModel(
          id: 'msg-c2-1',
          conversationId: 'conv-002',
          senderId: 'client-001',
          content: 'Good morning! Just confirming delivery time for tomorrow?',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: false,
        ),
        MessageModel(
          id: 'msg-c2-2',
          conversationId: 'conv-002',
          senderId: 'vendor-001',
          content:
              'Good morning Adaeze! We will be there at 10am sharp. '
              'Please ensure there is a 1.5m table reserved near the entrance for setup.',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isMe: true,
        ),
        MessageModel(
          id: 'msg-c2-3',
          conversationId: 'conv-002',
          senderId: 'client-001',
          content: 'Cake delivery confirmed for 10am!',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          isMe: false,
        ),
      ];
    }
    return [
      MessageModel(
        id: 'msg-default-1',
        conversationId: conversationId,
        senderId: 'client-999',
        content: 'Hi, I would like to enquire about your services.',
        type: 'TEXT',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      MessageModel(
        id: 'msg-default-2',
        conversationId: conversationId,
        senderId: 'vendor-001',
        content: 'Hello! Thanks for reaching out. How can I help you today?',
        type: 'TEXT',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isMe: true,
      ),
    ];
  }

  // ─── Notifications ────────────────────────────────────────────────────────────
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif-001',
      title: 'New Quote Request',
      body: 'Amaka Obi has sent you a new quote request for a 5-tier wedding cake.',
      type: 'quote',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
    ),
    NotificationModel(
      id: 'notif-002',
      title: 'Booking Confirmed',
      body: 'Your booking with Adaeze Okonkwo (3-Tier Wedding Cake) has been confirmed.',
      type: 'booking',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-003',
      title: 'Payment Received',
      body: '₦160,000 (50% deposit) has been received from Uche Nwosu and is held in escrow.',
      type: 'payment',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'notif-004',
      title: 'Payout Processed',
      body: '₦280,000 has been sent to your Zenith Bank account (**** 4421).',
      type: 'payout',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'notif-005',
      title: 'New Review',
      body: 'Chisom Igwe left you a 5-star review: "Absolutely stunning cake, exceeded expectations!"',
      type: 'review',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    NotificationModel(
      id: 'notif-006',
      title: 'Subscription Renewal',
      body: 'Your Featured plan renews in 7 days. Ensure your payment method is up to date.',
      type: 'general',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  // ─── Today's Schedule ─────────────────────────────────────────────────────────
  static final List<ScheduleItem> todaySchedule = [
    ScheduleItem(
      time: '09:00 AM',
      title: 'Cake Tasting',
      clientName: 'Amaka O.',
      color: Colors.orange,
    ),
    ScheduleItem(
      time: '02:00 PM',
      title: 'Delivery — Birthday Cake',
      clientName: 'Lekki Phase 1 · Chinedu C.',
      color: Colors.blue,
    ),
  ];

  // ─── Search & Recommendation ────────────────────────────────────────────────

  /// Full-text search across listing name, description, category, and tags.
  /// Returns results ranked by relevance:
  ///   1. Tag exact match  (score 4)
  ///   2. Name match       (score 3)
  ///   3. Category match   (score 2)
  ///   4. Description word (score 1)
  static List<ListingModel> searchListings(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return listings;

    final terms = q.split(RegExp(r'\s+')); // support multi-word queries

    final scored = listings.map((l) {
      int score = 0;

      for (final term in terms) {
        // Tags — highest signal (exact match)
        if (l.tags.any((t) => t.toLowerCase() == term)) score += 4;
        // Tags — partial match
        else if (l.tags.any((t) => t.toLowerCase().contains(term))) score += 2;

        // Title
        if (l.title.toLowerCase().contains(term)) score += 3;

        // Category
        if ((l.categoryName ?? '').toLowerCase().contains(term)) score += 2;

        // Description words
        if ((l.description ?? '').toLowerCase().contains(term)) score += 1;
      }

      return (listing: l, score: score);
    }).where((r) => r.score > 0).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scored.map((r) => r.listing).toList();
  }

  /// Returns listings whose tags overlap with [tags], excluding [excludeId].
  /// Used by recommendation carousels ("You might also like").
  static List<ListingModel> recommendedFor(
    List<String> tags, {
    String? excludeId,
    int limit = 5,
  }) {
    final lower = tags.map((t) => t.toLowerCase()).toSet();

    final scored = listings
        .where((l) => l.id != excludeId)
        .map((l) {
          final overlap = l.tags
              .where((t) => lower.contains(t.toLowerCase()))
              .length;
          return (listing: l, score: overlap);
        })
        .where((r) => r.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scored.take(limit).map((r) => r.listing).toList();
  }
}

// ─── ScheduleItem ─────────────────────────────────────────────────────────────
class ScheduleItem {
  final String time;
  final String title;
  final String clientName;
  final Color color;

  const ScheduleItem({
    required this.time,
    required this.title,
    required this.clientName,
    required this.color,
  });
}
