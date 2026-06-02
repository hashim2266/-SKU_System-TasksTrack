import { View, Text, StyleSheet } from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import { StatusColors, TaskStatus } from '@/constants/theme';

interface Props {
  completed: number;
  inProgress: number;
  notStarted: number;
  delayed: number;
}

export function DonutChart({ completed, inProgress, notStarted, delayed }: Props) {
  const theme = useTheme();
  const total = completed + inProgress + notStarted + delayed;
  if (total === 0) return null;

  const segments: { status: TaskStatus; value: number }[] = [
    { status: 'completed',   value: completed },
    { status: 'in_progress', value: inProgress },
    { status: 'not_started', value: notStarted },
    { status: 'delayed',     value: delayed },
  ];

  const pct = Math.round((completed / total) * 100);

  return (
    <View style={styles.container}>
      {/* Visual donut via stacked rings */}
      <View style={styles.donutWrapper}>
        <View style={[styles.outerRing, { borderColor: theme.backgroundSelected }]}>
          {segments.filter(s => s.value > 0).map((seg) => (
            <View
              key={seg.status}
              style={[styles.segmentBar, {
                flex: seg.value,
                backgroundColor: StatusColors[seg.status].dot,
              }]}
            />
          ))}
        </View>
        <View style={[styles.centerHole, { backgroundColor: theme.backgroundElement }]}>
          <Text style={[styles.centerPct, { color: theme.text }]}>{pct}%</Text>
          <Text style={[styles.centerLabel, { color: theme.textSecondary }]}>done</Text>
        </View>
      </View>

      {/* Legend */}
      <View style={styles.legend}>
        {segments.map(seg => (
          <View key={seg.status} style={styles.legendItem}>
            <View style={[styles.legendDot, { backgroundColor: StatusColors[seg.status].dot }]} />
            <Text style={[styles.legendCount, { color: theme.text }]}>{seg.value}</Text>
            <Text style={[styles.legendLabel, { color: theme.textSecondary }]}>
              {seg.status.replace('_', ' ')}
            </Text>
          </View>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    gap: 16,
  },
  donutWrapper: {
    width: 120,
    height: 120,
    position: 'relative',
    alignItems: 'center',
    justifyContent: 'center',
  },
  outerRing: {
    width: 120,
    height: 120,
    borderRadius: 60,
    borderWidth: 14,
    flexDirection: 'row',
    overflow: 'hidden',
    position: 'absolute',
  },
  segmentBar: {
    height: '100%',
  },
  centerHole: {
    width: 80,
    height: 80,
    borderRadius: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },
  centerPct: {
    fontSize: 20,
    fontWeight: '700',
    lineHeight: 24,
  },
  centerLabel: {
    fontSize: 10,
    fontWeight: '500',
  },
  legend: {
    gap: 6,
    width: '100%',
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  legendDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  legendCount: {
    fontSize: 13,
    fontWeight: '700',
    minWidth: 20,
  },
  legendLabel: {
    fontSize: 12,
    textTransform: 'capitalize',
    flex: 1,
  },
});
