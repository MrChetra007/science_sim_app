import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/subscription_service.dart';
import '../services/ad_service.dart';
import '../services/iap_service.dart';

void showGlobalPlanDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: const _PlanPickerView(),
    ),
  );
}

class _PlanPickerView extends StatefulWidget {
  const _PlanPickerView();

  @override
  State<_PlanPickerView> createState() => _PlanPickerViewState();
}

class _PlanPickerViewState extends State<_PlanPickerView> {
  final IAPService _iapService = IAPService();

  @override
  void initState() {
    super.initState();
    _iapService.onPurchaseSuccess = _showSuccessDialog;
  }

  @override
  void dispose() {
    _iapService.onPurchaseSuccess = null;
    super.dispose();
  }

  void _showSuccessDialog() {
    if (!mounted) return;
    final plan = _iapService.lastPurchasedPlan;
    final isLifetime = plan == SubscriptionPlan.lifetime;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D3D),
        title: Row(
          children: [
            Icon(
              isLifetime ? Icons.emoji_events : Icons.check_circle,
              color: Colors.amber,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome to Premium!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLifetime
                  ? 'You now have lifetime access to all labs!'
                  : 'Your monthly subscription is now active!',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '✅ All labs unlocked',
              style: TextStyle(color: Colors.greenAccent),
            ),
            const SizedBox(height: 4),
            Text(
              isLifetime
                  ? '✅ Zero ads forever'
                  : '✅ No ads while subscribed',
              style: const TextStyle(color: Colors.greenAccent),
            ),
            const SizedBox(height: 4),
            const Text(
              '✅ Future labs included free',
              style: TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('START EXPLORING'),
          ),
        ],
      ),
    );
  }

  static const String _cancelSubscriptionUrl = 
      'https://play.google.com/store/account/subscriptions?package=com.sozin.wave';

  void _showCancelDialog(BuildContext ctx) async {
    showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D3D),
        title: const Text(
          'Cancel Subscription?',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your subscription will remain active until the end of the current billing period.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(_cancelSubscriptionUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text('Manage Subscription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sub = Provider.of<SubscriptionService>(context, listen: false);
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      // App background behind cards
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E13), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Close button at top right
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),
            
            // FREE Plan Card
            _PlanCard(
              borderColor: const Color(0xFF1E2D3D),
              backgroundColor: const Color(0xFF131921),
              iconData: Icons.biotech,
              iconBgColor: const Color(0xFF1F2B3E),
              iconColor: const Color(0xFF90A4BE),
              titleText: 'FREE',
              titleColor: const Color(0xFF8699B3),
              priceMain: '\$0',
              priceSub: 'forever',
              priceMainColor: const Color(0xFF67778F),
              badge: null,
              bullets: const [
                'AC Electricity Lab – fully unlocked',
                'Watch ads to try any lab for 10 min',
                '4 labs locked',
                'Ads shown',
              ],
              bulletsColor: const Color(0xFF4C758F),
              buttonText: 'CONTINUE FREE',
              buttonBgColor: const Color(0xFF1A2639),
              buttonTextColor: const Color(0xFF6C81A0),
              onTapButton: () {
                sub.setPlan(SubscriptionPlan.free);
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 16),

            // MONTHLY Plan Card
            _PlanCard(
              borderColor: const Color(0xFF00BCD4),
              backgroundColor: const Color(0xFF0A1A24),
              iconData: Icons.calendar_month,
              iconBgColor: const Color(0xFF0D3B4D),
              iconColor: const Color(0xFF00BCD4),
              titleText: 'MONTHLY',
              titleColor: const Color(0xFF00E5FF),
              priceMain: '\$0.99',
              priceSub: 'per month',
              priceMainColor: const Color(0xFF00E5FF),
              badge: null,
              bullets: const [
                'All 5 labs – fully unlocked',
                'No ads – while subscribed',
                'Cancel anytime',
              ],
              bulletsColor: const Color(0xFF4DD0E1),
              buttonText: '⚡ GET MONTHLY – \$0.99/mo',
              buttonBgColor: const Color(0xFF00BCD4),
              buttonTextColor: Colors.black,
              onTapButton: () async {
                final iap = IAPService();
                await iap.buyMonthly();
              },
            ),

            const SizedBox(height: 16),

            // LIFETIME Plan Card
            _PlanCard(
              borderColor: const Color(0xFFD68A1B),
              backgroundColor: const Color(0xFF1E1405),
              iconData: Icons.emoji_events,
              iconBgColor: const Color(0xFF382312),
              iconColor: const Color(0xFFE8982D),
              titleText: 'LIFETIME',
              titleColor: const Color(0xFFD38B21),
              priceMain: '\$4.99',
              priceSub: 'one time · own forever',
              priceMainColor: const Color(0xFFF1B743),
              badge: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3A721),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white70, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'BEST VALUE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              bullets: const [
                'All 5 labs – fully unlocked forever',
                'Zero ads – permanently removed',
                'All future labs included free',
              ],
              bulletsColor: const Color(0xFFC0832C),
              buttonText: '⚡ GET LIFETIME – \$4.99',
              buttonBgColor: const Color(0xFFF39C12),
              buttonTextColor: Colors.black,
              onTapButton: () async {
                final iap = IAPService();
                await iap.buyLifetime();
              },
            ),
            const SizedBox(height: 16),
            // 10 MIN PREMIUM Card
            Consumer<SubscriptionService>(
              builder: (context, subService, child) {
                final isTempPro = subService.temporaryPremiumEndTime != null && DateTime.now().isBefore(subService.temporaryPremiumEndTime!);
                final progressText = '${subService.rewardedAdsWatched}/2';
                
                return _PlanCard(
                  borderColor: const Color(0xFF2E8B57),
                  backgroundColor: const Color(0xFF0F2618),
                  iconData: Icons.timer,
                  iconBgColor: const Color(0xFF1B4029),
                  iconColor: const Color(0xFF4CAF50),
                  titleText: '10 MIN TRIAL',
                  titleColor: const Color(0xFF66BB6A),
                  priceMain: isTempPro ? 'ACTIVE' : 'Free',
                  priceSub: 'watch 2 ads',
                  customPriceSub: isTempPro ? _CountdownTimer(endTime: subService.temporaryPremiumEndTime!) : null,
                  priceMainColor: isTempPro ? const Color(0xFF4CAF50) : const Color(0xFFB0BEC5),
                  badge: isTempPro
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'TRIAL ACTIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : null,
                  bullets: [
                    'Watch 2 short ads (${subService.rewardedAdsWatched}/2 done)',
                    'Unlocks all 5 labs for 10 minutes',
                    'Note: Ads still shown during trial',
                  ],
                  bulletsColor: const Color(0xFF81C784),
                  buttonText: isTempPro ? 'ENJOY LABS' : '▶ WATCH AD ($progressText)',
                  buttonBgColor: isTempPro ? const Color(0xFF1B4029) : const Color(0xFF2E8B57),
                  buttonTextColor: Colors.white,
                  onTapButton: () {
                    if (isTempPro) {
                      Navigator.pop(context);
                      return;
                    }
                    globalAdService.showRewardedAd(
                      onEarnedReward: () {
                         subService.watchingRewardedAdSuccess();
                      },
                      onClosed: () {},
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // Restore Purchases Button
            TextButton.icon(
              onPressed: () async {
                // Show loading
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 16),
                          Text('Checking for previous purchases...'),
                        ],
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }

                await IAPService().restorePurchases();
              },
              icon: const Icon(Icons.restore, color: Colors.white54, size: 18),
              label: const Text(
                'Restore Purchases',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            // Manage Subscription Button
            Consumer<SubscriptionService>(
              builder: (context, subService, child) {
                if (!subService.isPro) return const SizedBox.shrink();
                return TextButton.icon(
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                  icon: const Icon(Icons.cancel_outlined, color: Colors.orange, size: 18),
                  label: const Text(
                    'Cancel Subscription',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final IconData iconData;
  final Color iconBgColor;
  final Color iconColor;
  final String titleText;
  final Color titleColor;
  final String priceMain;
  final String priceSub;
  final Widget? customPriceSub;
  final Color priceMainColor;
  final Widget? badge;
  final List<String> bullets;
  final Color bulletsColor;
  final String buttonText;
  final Color buttonBgColor;
  final Color buttonTextColor;
  final VoidCallback onTapButton;

  const _PlanCard({
    required this.borderColor,
    required this.backgroundColor,
    required this.iconData,
    required this.iconBgColor,
    required this.iconColor,
    required this.titleText,
    required this.titleColor,
    required this.priceMain,
    required this.priceSub,
    this.customPriceSub,
    required this.priceMainColor,
    this.badge,
    required this.bullets,
    required this.bulletsColor,
    required this.buttonText,
    required this.buttonBgColor,
    required this.buttonTextColor,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: iconColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            titleText,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badge != null) Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: badge!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          priceMain,
                          style: TextStyle(
                            color: priceMainColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: customPriceSub ?? Text(
                            priceSub,
                            style: const TextStyle(
                              color: Color(0xFF4A5568),
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Divider(color: borderColor.withOpacity(0.5), thickness: 1, height: 1),
          const SizedBox(height: 16),
          
          // Bullets
          ...bullets.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(right: 8, top: 1),
                  decoration: BoxDecoration(
                    color: bulletsColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    b,
                    style: TextStyle(
                      color: bulletsColor,
                      fontSize: 12,
                      fontFamily: 'monospace', // Gives that techy look shown in image
                    ),
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 20),
          
          // Button
          ElevatedButton(
            onPressed: onTapButton,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBgColor,
              foregroundColor: buttonTextColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  final DateTime endTime;
  const _CountdownTimer({required this.endTime});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    if (widget.endTime.isAfter(now)) {
      if (mounted) {
        setState(() {
          _timeLeft = widget.endTime.difference(now);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _timeLeft = Duration.zero;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero) {
      return const Text(
        'expired',
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
    }
    
    final minutes = _timeLeft.inMinutes;
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');
    
    return Text(
      'expires in $minutes:$seconds',
      style: const TextStyle(
        color: Color(0xFF4CAF50),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}
