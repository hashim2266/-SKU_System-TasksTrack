import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type TaskStatus = 'not_started' | 'in_progress' | 'completed' | 'delayed';

export interface Section {
  id: string;
  name: string;
  code: string;
  color: string;
  icon: string;
  created_at: string;
}

export interface KpiTask {
  id: string;
  section_id: string;
  title: string;
  description: string;
  category: string;
  target: number;
  unit: string;
  month: number;
  year: number;
  status: TaskStatus;
  actual_value: number;
  pic: string;
  notes: string;
  created_at: string;
  updated_at: string;
}

export interface KpiTaskWithSection extends KpiTask {
  sections: Section;
}
