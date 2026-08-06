import 'package:flutter/material.dart';

import '../api/models.dart';
import '../theme/tune_tokens.dart';
import 'quality_badge.dart';

/// Quality filter chips (CD / HR / DSD / lossy) for a track list — the
/// audiophile reflex: "show me only the DSD".
///
/// Only tiers actually present in [tracks] get a chip, so the bar never offers
/// an empty result. An empty [selected] set means "no filter".
class QualityFilterBar extends StatelessWidget {
  final List<Track> tracks;
  final Set<QualityTier> selected;
  final ValueChanged<Set<QualityTier>> onChanged;

  const QualityFilterBar({
    super.key,
    required this.tracks,
    required this.selected,
    required this.onChanged,
  });

  /// Tiers present in [tracks], in a stable display order.
  static List<QualityTier> tiersIn(List<Track> tracks) {
    final present = <QualityTier>{
      for (final t in tracks) ?qualityTierOf(t.quality),
    };
    return [
      for (final tier in QualityTier.values)
        if (present.contains(tier)) tier,
    ];
  }

  /// Keeps only the tracks matching [selected] (all of them when it is empty).
  static List<Track> apply(List<Track> tracks, Set<QualityTier> selected) {
    if (selected.isEmpty) return tracks;
    return [
      for (final t in tracks)
        if (selected.contains(qualityTierOf(t.quality))) t,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tiers = tiersIn(tracks);
    // A single tier offers no meaningful choice — hide the bar entirely.
    if (tiers.length < 2) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final tier in tiers)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _TierChip(
                tier: tier,
                active: selected.contains(tier),
                onTap: () {
                  final next = Set<QualityTier>.from(selected);
                  if (!next.remove(tier)) next.add(tier);
                  onChanged(next);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  final QualityTier tier;
  final bool active;
  final VoidCallback onTap;

  const _TierChip({required this.tier, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TuneTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          // Active chips carry their own tier colour, so the bar reads like the
          // badges it filters on.
          color: active ? tier.background : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(TuneTokens.radiusPill),
        ),
        child: Text(
          tier.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: active ? tier.foreground : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
