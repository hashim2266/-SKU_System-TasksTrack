import { View, Text, StyleSheet, Pressable } from 'react-native';
import { useTheme } from '@/hooks/use-theme';

const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

interface Props {
  data: { month: number; completed: number; total: number }[];
  color?: string;
  onMonthPress?: (month: number) => void;
  selectedMonth?: number | null;
}

export function MonthlyBarChart({ data, color = '#2563EB', onMonthPress, selectedMonth }: Props) {
  const theme = useTheme();
  const maxTotal = Math.max(...data.map(d => d.total), 1);

  return (
    <View style={styles.container}>
      <View style={styles.bars}>
        {data.map((d) => {
          const barHeight = Math.max((d.total / maxTotal) * 80, 4);
          const fillHeight = d.total === 0 ? 0 : (d.completed / d.total) * barHeight;
          const isSelected = selectedMonth === d.month;
          return (
            <Pressable
              key={d.month}
              style={styles.barCol}
              onPress={() => onMonthPress?.(d.month)}>
              <View style={[styles.barTrack, { height: barHeight, backgroundColor: theme.backgroundSelected }]}>
                <View style={[
                  styles.barFill,
                  { height: fillHeight, backgroundColor: isSelected ? color : color + 'BB' }
                ]} />
              </View>
              <Text style={[
                styles.monthLabel,
                { color: isSelected ? color : theme.textSecondary }
              ]}>
                {MONTHS[d.month - 1]}
              </Text>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingVertical: 8,
  },
  bars: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    gap: 4,
    height: 100,
  },
  barCol: {
    flex: 1,
    alignItems: 'center',
    gap: 4,
  },
  barTrack: {
    width: '100%',
    borderRadius: 4,
    overflow: 'hidden',
    justifyContent: 'flex-end',
  },
  barFill: {
    width: '100%',
    borderRadius: 4,
  },
  monthLabel: {
    fontSize: 9,
    fontWeight: '600',
  },
});
