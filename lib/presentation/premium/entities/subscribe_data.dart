import 'package:zeusfile/presentation/premium/entities/detail_subscribe.dart';
import 'package:zeusfile/purchase/purchase_service.dart';

class SubscribeData {
  final String name;
  final String price;
  bool isVisible;
  final DetailSubscribe detailSubscribe;
  final SubscriptionType subscriptionType;
  final String? traffic;

  SubscribeData({
    required this.name,
    required this.price,
    this.traffic,
    this.isVisible = false,
    required this.detailSubscribe,
    required this.subscriptionType,
  });
}

List<SubscribeData> subscribeDataNovaFile = [
  SubscribeData(
    subscriptionType: SubscriptionType.premium,
    name: 'Premium',
    price: '8.35',
    detailSubscribe: DetailSubscribe(
      trafficAdditional: '20 Gb for 3 days',
      premium: 'Maximum download speed',
      traffic: 'No captcha',
      space: 'Instant file upload',
      size: 'Stopping and resuming download',
      channel: 'Download manager support',
      prioroty: 'Parallel file download',
    ),
  ),
  SubscribeData(
    subscriptionType: SubscriptionType.vip,
    name: 'Premium VIP',
    price: '10.85',
    detailSubscribe: DetailSubscribe(
      trafficAdditional: '55 Gb for 3 days',
      premium: 'All premium features',
      traffic: 'Full traffic encryption',
      space: '2Х More disk space',
      size: 'Unlimited file size',
      channel: 'Dedicated download channels',
      prioroty: 'Priority support and service',
    ),
  ),
];

List<SubscribeData> subscribeDataFileJoker = [
  SubscribeData(
    subscriptionType: SubscriptionType.premium,
    name: 'Premium',
    price: '11.25',
    detailSubscribe: DetailSubscribe(
      trafficAdditional: '60 Gb for 5 days',
      premium: 'Maximum download speed',
      traffic: 'No captcha',
      space: 'Instant file upload',
      size: 'Stopping and resuming download',
      channel: 'Download manager support',
      prioroty: 'Parallel file download',
    ),
  ),
  SubscribeData(
    subscriptionType: SubscriptionType.vip,
    name: 'Premium VIP',
    price: '14.45',
    detailSubscribe: DetailSubscribe(
      trafficAdditional: '300 Gb for 5 days',
      premium: 'All premium features',
      traffic: 'Full traffic encryption',
      space: '2Х More disk space',
      size: 'Unlimited file size',
      channel: 'Dedicated download channels',
      prioroty: 'Priority support and service',
    ),
  ),
];
