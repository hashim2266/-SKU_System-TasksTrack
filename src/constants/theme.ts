import '@/global.css';

import { Platform } from 'react-native';

export const Colors = {
  light: {
    text: '#0F172A',
    background: '#F8FAFC',
    backgroundElement: '#FFFFFF',
    backgroundSelected: '#E2E8F0',
    textSecondary: '#64748B',
    border: '#E2E8F0',
  },
  dark: {
    text: '#F1F5F9',
    background: '#0F172A',
    backgroundElement: '#1E293B',
    backgroundSelected: '#334155',
    textSecondary: '#94A3B8',
    border: '#334155',
  },
} as const;

export type ThemeColor = keyof typeof Colors.light & keyof typeof Colors.dark;

export const StatusColors = {
  completed:   { bg: '#DCFCE7', text: '#166534', dot: '#16A34A' },
  in_progress: { bg: '#DBEAFE', text: '#1D4ED8', dot: '#2563EB' },
  not_started: { bg: '#F1F5F9', text: '#475569', dot: '#94A3B8' },
  delayed:     { bg: '#FEE2E2', text: '#991B1B', dot: '#DC2626' },
} as const;

export const SectionMeta: Record<string, { color: string; label: string }> = {
  OPS:  { color: '#2563EB', label: 'Operations' },
  FIN:  { color: '#16A34A', label: 'Finance' },
  HR:   { color: '#D97706', label: 'Human Resources' },
  MKT:  { color: '#DC2626', label: 'Marketing' },
  TECH: { color: '#0891B2', label: 'Technology' },
};

export const Fonts = Platform.select({
  ios: {
    sans: 'system-ui',
    serif: 'ui-serif',
    rounded: 'ui-rounded',
    mono: 'ui-monospace',
  },
  default: {
    sans: 'normal',
    serif: 'serif',
    rounded: 'normal',
    mono: 'monospace',
  },
  web: {
    sans: 'var(--font-display)',
    serif: 'var(--font-serif)',
    rounded: 'var(--font-rounded)',
    mono: 'var(--font-mono)',
  },
});

export const Spacing = {
  half: 2,
  one: 4,
  two: 8,
  three: 16,
  four: 24,
  five: 32,
  six: 64,
} as const;

export const BottomTabInset = Platform.select({ ios: 50, android: 80 }) ?? 0;
export const MaxContentWidth = 1100;
