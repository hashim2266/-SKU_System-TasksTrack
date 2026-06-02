import { useEffect, useState, useCallback } from 'react';
import { supabase, KpiTask, Section } from '@/lib/supabase';

export function useSections() {
  const [sections, setSections] = useState<Section[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    const { data } = await supabase.from('sections').select('*').order('name');
    if (data) setSections(data);
    setLoading(false);
  }, []);

  useEffect(() => { load(); }, [load]);
  return { sections, loading, reload: load };
}

export function useKpiTasks(sectionId?: string, year?: number) {
  const [tasks, setTasks] = useState<KpiTask[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    setLoading(true);
    let q = supabase.from('kpi_tasks').select('*');
    if (sectionId) q = q.eq('section_id', sectionId);
    if (year)      q = q.eq('year', year);
    q = q.order('month').order('title');
    const { data } = await q;
    if (data) setTasks(data);
    setLoading(false);
  }, [sectionId, year]);

  useEffect(() => { load(); }, [load]);
  return { tasks, loading, reload: load };
}

export function useAllTasks(year: number) {
  const [tasks, setTasks] = useState<KpiTask[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from('kpi_tasks')
      .select('*, sections(*)')
      .eq('year', year)
      .order('month');
    if (data) setTasks(data as KpiTask[]);
    setLoading(false);
  }, [year]);

  useEffect(() => { load(); }, [load]);
  return { tasks, loading, reload: load };
}

export async function upsertTask(task: Partial<KpiTask> & { section_id: string }) {
  if (task.id) {
    return supabase.from('kpi_tasks').update(task).eq('id', task.id);
  }
  return supabase.from('kpi_tasks').insert(task);
}

export async function deleteTask(id: string) {
  return supabase.from('kpi_tasks').delete().eq('id', id);
}
