import { View, Text, StyleSheet } from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import { Spacing } from '@/constants/theme';

interface Props {
  label: string;
  value: string | number;
  sub?: string;
  accent?: string;
}

export function StatCard({ label, value, sub, accent = '#2563EB' }: Props) {
  const theme = useTheme();
  return (
    <View style={[styles.card, { backgroundColor: theme.backgroundElement, borderColor: theme.border }]}>
      <View style={[styles.accentBar, { backgroundColor: accent }]} />
      <View style={styles.content}>
        <Text style={[styles.value, { color: theme.text }]}>{value}</Text>
        <Text style={[styles.label, { color: theme.textSecondary }]}>{label}</Text>
        {sub ? <Text style={[styles.sub, { color: accent }]}>{sub}</Text> : null}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 12,
    borderWidth: 1,
    flexDirection: 'row',
    overflow: 'hidden',
    flex: 1,
    minWidth: 120,
  },
  accentBar: {
    width: 4,
  },
  content: {
    padding: Spacing.three,
    gap: 2,
    flex: 1,
  },
  value: {
    fontSize: 26,
    fontWeight: '700',
    lineHeight: 32,
  },
  label: {
    fontSize: 12,
    fontWeight: '500',
  },
  sub: {
    fontSize: 11,
    fontWeight: '600',
    marginTop: 2,
  },
});
