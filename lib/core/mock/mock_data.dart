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
    ConversationModel(
      id: 'conv-001',
      participantName: 'Amaka Obi',
      participantImage:
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
      lastMessage: 'Can you reduce the price a little?',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 14)),
      unreadCount: 2,
      type: 'direct',
    ),
    ConversationModel(
      id: 'conv-002',
      participantName: 'Adaeze Okonkwo',
      participantImage:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      lastMessage: 'Cake delivery confirmed for 10am!',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      type: 'direct',
    ),
    ConversationModel(
      id: 'conv-003',
      participantName: 'Chinedu Eze',
      participantImage: null,
      lastMessage: 'Thank you so much, it was perfect!',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 4)),
      unreadCount: 0,
      type: 'direct',
    ),
    ConversationModel(
      id: 'conv-004',
      participantName: 'Kemi Afolabi',
      participantImage:
          'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=200',
      lastMessage: 'Quote received, I\'ll confirm by Friday.',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      type: 'direct',
    ),
    ConversationModel(
      id: 'conv-005',
      participantName: 'Planovar Support',
      participantImage: null,
      lastMessage: 'Your verification is complete!',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 7)),
      unreadCount: 0,
      type: 'support',
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
          content: 'Hi! I need a 5-tier wedding cake for 300 guests. Ivory and gold theme.',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
          isMe: false,
        ),
        MessageModel(
          id: 'msg-c1-2',
          conversationId: 'conv-001',
          senderId: 'vendor-001',
          content:
              'Hello Amaka! Congratulations on your upcoming wedding! '
              'We would love to create your dream cake. Let me send over a quote for you.',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
          isMe: true,
        ),
        MessageModel(
          id: 'msg-c1-3',
          conversationId: 'conv-001',
          senderId: 'vendor-001',
          content:
              'Here is my preliminary estimate: 5-tier fondant cake (₦180,000) + '
              'delivery to Eko Hotel (₦15,000) + setup (₦10,000) = Total ₦205,000.',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
          isMe: true,
        ),
        MessageModel(
          id: 'msg-c1-4',
          conversationId: 'conv-001',
          senderId: 'client-011',
          content:
              'Can you reduce the price a little? Our budget is around ₦180,000 all in.',
          type: 'TEXT',
          createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
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
