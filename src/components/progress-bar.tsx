import { View, Text, StyleSheet } from 'react-native';
import { useTheme } from '@/hooks/use-theme';

interface BarProps {
  value: number;
  total: number;
  color: string;
  height?: number;
}

export function ProgressBar({ value, total, color, height = 6 }: BarProps) {
  const theme = useTheme();
  const pct = total === 0 ? 0 : Math.min(100, (value / total) * 100);
  return (
    <View style={[styles.track, { height, backgroundColor: theme.backgroundSelected }]}>
      <View style={[styles.fill, { width: `${pct}%`, backgroundColor: color, height }]} />
    </View>
  );
}

interface SectionBarProps {
  label: string;
  color: string;
  completed: number;
  total: number;
}

export function SectionProgressBar({ label, color, completed, total }: SectionBarProps) {
  const theme = useTheme();
  const pct = total === 0 ? 0 : Math.round((completed / total) * 100);
  return (
    <View style={styles.row}>
      <View style={styles.labelRow}>
        <View style={[styles.colorDot, { backgroundColor: color }]} />
        <Text style={[styles.label, { color: theme.text }]}>{label}</Text>
        <Text style={[styles.pct, { color: theme.textSecondary }]}>{pct}%</Text>
      </View>
      <ProgressBar value={completed} total={total} color={color} height={8} />
      <Text style={[styles.count, { color: theme.textSecondary }]}>{completed}/{total} tasks</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  track: {
    borderRadius: 99,
    overflow: 'hidden',
  },
  fill: {
    borderRadius: 99,
  },
  row: {
    gap: 6,
  },
  labelRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  colorDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
  },
  label: {
    fontSize: 13,
    fontWeight: '600',
    flex: 1,
  },
  pct: {
    fontSize: 13,
    fontWeight: '700',
  },
  count: {
    fontSize: 11,
  },
});
