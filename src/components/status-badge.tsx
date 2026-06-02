import { View, Text, StyleSheet } from 'react-native';
import { TaskStatus, StatusColors } from '@/constants/theme';

const STATUS_LABELS: Record<TaskStatus, string> = {
  completed:   'Completed',
  in_progress: 'In Progress',
  not_started: 'Not Started',
  delayed:     'Delayed',
};

export function StatusBadge({ status }: { status: TaskStatus }) {
  const colors = StatusColors[status];
  return (
    <View style={[styles.badge, { backgroundColor: colors.bg }]}>
      <View style={[styles.dot, { backgroundColor: colors.dot }]} />
      <Text style={[styles.label, { color: colors.text }]}>{STATUS_LABELS[status]}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  badge: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 20,
    gap: 4,
    alignSelf: 'flex-start',
  },
  dot: {
    width: 6,
    height: 6,
    borderRadius: 3,
  },
  label: {
    fontSize: 11,
    fontWeight: '600',
    letterSpacing: 0.2,
  },
});
