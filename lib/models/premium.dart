enum PremiumPlan { jamb, jambWaec, allAccess }
enum PremiumDuration { week, month, year }

class PremiumOption {
  final PremiumPlan plan;
  final PremiumDuration duration;
  final int price;

  const PremiumOption(this.plan, this.duration, this.price);

  String get planName {
    switch (plan) {
      case PremiumPlan.jamb: return 'JAMB';
      case PremiumPlan.jambWaec: return 'JAMB + WAEC';
      case PremiumPlan.allAccess: return 'ALL ACCESS';
    }
  }

  String get durationName {
    switch (duration) {
      case PremiumDuration.week: return '1 Week';
      case PremiumDuration.month: return '1 Month';
      case PremiumDuration.year: return '1 Year';
    }
  }
}

const premiumOptions = <PremiumOption>[
  PremiumOption(PremiumPlan.jamb, PremiumDuration.week, 500),
  PremiumOption(PremiumPlan.jamb, PremiumDuration.month, 1500),
  PremiumOption(PremiumPlan.jamb, PremiumDuration.year, 5000),
  PremiumOption(PremiumPlan.jambWaec, PremiumDuration.week, 800),
  PremiumOption(PremiumPlan.jambWaec, PremiumDuration.month, 2000),
  PremiumOption(PremiumPlan.jambWaec, PremiumDuration.year, 7000),
  PremiumOption(PremiumPlan.allAccess, PremiumDuration.week, 1000),
  PremiumOption(PremiumPlan.allAccess, PremiumDuration.month, 3000),
  PremiumOption(PremiumPlan.allAccess, PremiumDuration.year, 10000),
];
