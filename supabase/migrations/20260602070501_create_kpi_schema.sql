/*
  # KPI Monitoring System Schema

  ## Overview
  This migration creates the full schema for a division KPI monitoring system
  consisting of 5 sections, each with tasks tracked throughout the year.

  ## Tables

  ### sections
  - `id` (uuid, primary key)
  - `name` (text) - Section name
  - `code` (text) - Short code identifier
  - `color` (text) - Hex color for UI
  - `icon` (text) - Icon name string
  - `created_at` (timestamptz)

  ### kpi_tasks
  - `id` (uuid, primary key)
  - `section_id` (uuid, FK to sections)
  - `title` (text) - Task name
  - `description` (text) - Task details
  - `category` (text) - Task category label
  - `target` (numeric) - Numeric target value
  - `unit` (text) - Unit of measure (%, count, etc.)
  - `month` (int) - Month 1-12
  - `year` (int) - Year
  - `status` (text) - 'not_started' | 'in_progress' | 'completed' | 'delayed'
  - `actual_value` (numeric) - Actual achieved value
  - `pic` (text) - Person in charge
  - `notes` (text)
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ## Security
  - RLS enabled on all tables
  - Public read access for dashboard visibility
  - Authenticated users can insert/update/delete their section tasks
*/

-- Sections table
CREATE TABLE IF NOT EXISTS sections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text NOT NULL UNIQUE,
  color text NOT NULL DEFAULT '#3B82F6',
  icon text NOT NULL DEFAULT 'layers',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE sections ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read sections"
  ON sections FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert sections"
  ON sections FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update sections"
  ON sections FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- KPI Tasks table
CREATE TABLE IF NOT EXISTS kpi_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_id uuid NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  category text NOT NULL DEFAULT 'General',
  target numeric NOT NULL DEFAULT 100,
  unit text NOT NULL DEFAULT '%',
  month int NOT NULL CHECK (month BETWEEN 1 AND 12),
  year int NOT NULL DEFAULT EXTRACT(YEAR FROM now()),
  status text NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started','in_progress','completed','delayed')),
  actual_value numeric DEFAULT 0,
  pic text NOT NULL DEFAULT '',
  notes text NOT NULL DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE kpi_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read kpi_tasks"
  ON kpi_tasks FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert kpi_tasks"
  ON kpi_tasks FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update kpi_tasks"
  ON kpi_tasks FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete kpi_tasks"
  ON kpi_tasks FOR DELETE
  TO authenticated
  USING (true);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER kpi_tasks_updated_at
  BEFORE UPDATE ON kpi_tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Seed the 5 sections
INSERT INTO sections (name, code, color, icon) VALUES
  ('Operations', 'OPS', '#2563EB', 'settings'),
  ('Finance', 'FIN', '#16A34A', 'dollar-sign'),
  ('Human Resources', 'HR', '#D97706', 'users'),
  ('Marketing', 'MKT', '#DC2626', 'trending-up'),
  ('Technology', 'TECH', '#7C3AED', 'cpu')
ON CONFLICT (code) DO NOTHING;

-- Seed sample KPI tasks for current year across all sections
DO $$
DECLARE
  ops_id uuid;
  fin_id uuid;
  hr_id uuid;
  mkt_id uuid;
  tech_id uuid;
  cur_year int := EXTRACT(YEAR FROM now());
BEGIN
  SELECT id INTO ops_id FROM sections WHERE code = 'OPS';
  SELECT id INTO fin_id FROM sections WHERE code = 'FIN';
  SELECT id INTO hr_id FROM sections WHERE code = 'HR';
  SELECT id INTO mkt_id FROM sections WHERE code = 'MKT';
  SELECT id INTO tech_id FROM sections WHERE code = 'TECH';

  -- Operations tasks
  INSERT INTO kpi_tasks (section_id, title, category, target, unit, month, year, status, actual_value, pic, description) VALUES
    (ops_id, 'Process Efficiency Improvement', 'Efficiency', 95, '%', 1, cur_year, 'completed', 97, 'Ahmad Fauzi', 'Improve core process efficiency to 95%'),
    (ops_id, 'Reduce Downtime Hours', 'Reliability', 10, 'hours', 2, cur_year, 'completed', 7, 'Budi Santoso', 'Reduce monthly downtime to under 10 hours'),
    (ops_id, 'Equipment Maintenance Compliance', 'Maintenance', 100, '%', 3, cur_year, 'completed', 100, 'Ahmad Fauzi', 'All scheduled maintenance completed on time'),
    (ops_id, 'SOP Documentation Update', 'Documentation', 15, 'docs', 4, cur_year, 'in_progress', 11, 'Citra Dewi', 'Update 15 standard operating procedures'),
    (ops_id, 'Vendor Performance Review', 'Procurement', 8, 'vendors', 5, cur_year, 'in_progress', 5, 'Budi Santoso', 'Review all active vendor contracts'),
    (ops_id, 'Safety Incident Target', 'Safety', 0, 'incidents', 6, cur_year, 'not_started', 0, 'Ahmad Fauzi', 'Zero safety incidents for the month'),
    (ops_id, 'Capacity Utilization Rate', 'Efficiency', 85, '%', 7, cur_year, 'not_started', 0, 'Citra Dewi', 'Achieve 85% capacity utilization'),
    (ops_id, 'Cost Reduction Initiative', 'Cost', 5, '%', 8, cur_year, 'not_started', 0, 'Budi Santoso', 'Reduce operational costs by 5%'),
    (ops_id, 'Quality Assurance Score', 'Quality', 98, '%', 9, cur_year, 'not_started', 0, 'Ahmad Fauzi', 'Maintain QA pass rate above 98%'),
    (ops_id, 'Process Audit Completion', 'Audit', 3, 'audits', 10, cur_year, 'not_started', 0, 'Citra Dewi', 'Complete 3 internal process audits'),
    (ops_id, 'Year-End Equipment Review', 'Maintenance', 100, '%', 11, cur_year, 'not_started', 0, 'Budi Santoso', 'Complete full equipment condition review'),
    (ops_id, 'Annual Operations Report', 'Reporting', 1, 'report', 12, cur_year, 'not_started', 0, 'Ahmad Fauzi', 'Submit comprehensive annual operations report');

  -- Finance tasks
  INSERT INTO kpi_tasks (section_id, title, category, target, unit, month, year, status, actual_value, pic, description) VALUES
    (fin_id, 'Budget Variance Control', 'Budget', 5, '%', 1, cur_year, 'completed', 3.2, 'Dewi Rahayu', 'Keep budget variance under 5%'),
    (fin_id, 'Invoice Processing Time', 'Accounts', 3, 'days', 2, cur_year, 'completed', 2.5, 'Eko Prasetyo', 'Process invoices within 3 business days'),
    (fin_id, 'Cash Flow Forecast Accuracy', 'Forecasting', 90, '%', 3, cur_year, 'completed', 92, 'Dewi Rahayu', 'Maintain 90% forecast accuracy'),
    (fin_id, 'Expense Report Audit', 'Audit', 100, '%', 4, cur_year, 'in_progress', 75, 'Eko Prasetyo', 'Audit all submitted expense reports'),
    (fin_id, 'Tax Compliance Filing', 'Compliance', 100, '%', 5, cur_year, 'in_progress', 60, 'Dewi Rahayu', 'All tax filings submitted on time'),
    (fin_id, 'Mid-Year Financial Review', 'Reporting', 1, 'report', 6, cur_year, 'not_started', 0, 'Eko Prasetyo', 'Complete mid-year financial performance review'),
    (fin_id, 'Cost Center Analysis', 'Analysis', 12, 'centers', 7, cur_year, 'not_started', 0, 'Dewi Rahayu', 'Analyze all 12 cost centers'),
    (fin_id, 'Financial Risk Assessment', 'Risk', 1, 'assessment', 8, cur_year, 'not_started', 0, 'Eko Prasetyo', 'Complete quarterly risk assessment'),
    (fin_id, 'Budget Planning FY+1', 'Budget', 100, '%', 9, cur_year, 'not_started', 0, 'Dewi Rahayu', 'Draft next fiscal year budget'),
    (fin_id, 'Accounts Receivable Collection', 'Accounts', 95, '%', 10, cur_year, 'not_started', 0, 'Eko Prasetyo', 'Collect 95% of outstanding AR'),
    (fin_id, 'Year-End Closing Preparation', 'Reporting', 100, '%', 11, cur_year, 'not_started', 0, 'Dewi Rahayu', 'Prepare all year-end closing documents'),
    (fin_id, 'Annual Financial Audit', 'Audit', 100, '%', 12, cur_year, 'not_started', 0, 'Eko Prasetyo', 'Support external audit completion');

  -- HR tasks
  INSERT INTO kpi_tasks (section_id, title, category, target, unit, month, year, status, actual_value, pic, description) VALUES
    (hr_id, 'Employee Satisfaction Survey', 'Engagement', 85, '%', 1, cur_year, 'completed', 88, 'Fitri Handayani', 'Conduct Q1 employee satisfaction survey'),
    (hr_id, 'Training Hours per Employee', 'Training', 8, 'hours', 2, cur_year, 'completed', 10, 'Gani Wijaya', 'Minimum 8 training hours per employee'),
    (hr_id, 'Recruitment Cycle Time', 'Recruitment', 21, 'days', 3, cur_year, 'completed', 18, 'Fitri Handayani', 'Fill vacancies within 21 days'),
    (hr_id, 'Turnover Rate Control', 'Retention', 5, '%', 4, cur_year, 'in_progress', 3.5, 'Gani Wijaya', 'Keep monthly turnover below 5%'),
    (hr_id, 'Performance Review Completion', 'Performance', 100, '%', 5, cur_year, 'in_progress', 70, 'Fitri Handayani', 'Complete all mid-year performance reviews'),
    (hr_id, 'Benefits Enrollment Update', 'Benefits', 100, '%', 6, cur_year, 'not_started', 0, 'Gani Wijaya', 'Update all employee benefits enrollment'),
    (hr_id, 'Leadership Development Program', 'Training', 20, 'participants', 7, cur_year, 'not_started', 0, 'Fitri Handayani', 'Enroll 20 employees in leadership program'),
    (hr_id, 'Compliance Training Completion', 'Compliance', 100, '%', 8, cur_year, 'not_started', 0, 'Gani Wijaya', 'All employees complete compliance training'),
    (hr_id, 'Succession Planning Update', 'Planning', 10, 'positions', 9, cur_year, 'not_started', 0, 'Fitri Handayani', 'Update succession plans for 10 key positions'),
    (hr_id, 'Employee Wellness Program', 'Wellness', 75, '%', 10, cur_year, 'not_started', 0, 'Gani Wijaya', '75% participation in wellness activities'),
    (hr_id, 'Year-End Performance Review', 'Performance', 100, '%', 11, cur_year, 'not_started', 0, 'Fitri Handayani', 'Complete all year-end performance reviews'),
    (hr_id, 'Annual HR Report', 'Reporting', 1, 'report', 12, cur_year, 'not_started', 0, 'Gani Wijaya', 'Submit comprehensive annual HR report');

  -- Marketing tasks
  INSERT INTO kpi_tasks (section_id, title, category, target, unit, month, year, status, actual_value, pic, description) VALUES
    (mkt_id, 'Lead Generation Campaign', 'Campaigns', 500, 'leads', 1, cur_year, 'completed', 612, 'Hana Sari', 'Generate 500 qualified leads'),
    (mkt_id, 'Social Media Engagement', 'Digital', 10, '%', 2, cur_year, 'completed', 12.3, 'Irwan Kusuma', 'Achieve 10% engagement rate'),
    (mkt_id, 'Brand Awareness Survey', 'Brand', 70, '%', 3, cur_year, 'completed', 68, 'Hana Sari', 'Brand recognition target 70%'),
    (mkt_id, 'Q2 Campaign Launch', 'Campaigns', 1, 'campaign', 4, cur_year, 'in_progress', 0, 'Irwan Kusuma', 'Launch Q2 marketing campaign'),
    (mkt_id, 'Content Marketing Output', 'Content', 20, 'pieces', 5, cur_year, 'in_progress', 14, 'Hana Sari', 'Publish 20 content pieces'),
    (mkt_id, 'Mid-Year Marketing Review', 'Reporting', 1, 'report', 6, cur_year, 'not_started', 0, 'Irwan Kusuma', 'Complete H1 marketing performance review'),
    (mkt_id, 'Customer Acquisition Cost', 'Performance', 50, 'USD', 7, cur_year, 'not_started', 0, 'Hana Sari', 'Keep CAC below $50'),
    (mkt_id, 'Partnership Outreach', 'Business Dev', 5, 'partners', 8, cur_year, 'not_started', 0, 'Irwan Kusuma', 'Establish 5 new partnerships'),
    (mkt_id, 'Product Launch Campaign', 'Campaigns', 1, 'launch', 9, cur_year, 'not_started', 0, 'Hana Sari', 'Execute product launch marketing'),
    (mkt_id, 'Customer Retention Campaign', 'Retention', 90, '%', 10, cur_year, 'not_started', 0, 'Irwan Kusuma', 'Maintain 90% customer retention'),
    (mkt_id, 'Year-End Brand Campaign', 'Brand', 1, 'campaign', 11, cur_year, 'not_started', 0, 'Hana Sari', 'Launch year-end brand campaign'),
    (mkt_id, 'Annual Marketing Report', 'Reporting', 1, 'report', 12, cur_year, 'not_started', 0, 'Irwan Kusuma', 'Submit comprehensive annual marketing report');

  -- Technology tasks
  INSERT INTO kpi_tasks (section_id, title, category, target, unit, month, year, status, actual_value, pic, description) VALUES
    (tech_id, 'System Uptime SLA', 'Infrastructure', 99.9, '%', 1, cur_year, 'completed', 99.95, 'Joko Susilo', 'Maintain 99.9% system uptime'),
    (tech_id, 'Security Patch Compliance', 'Security', 100, '%', 2, cur_year, 'completed', 100, 'Kartika Sari', 'Apply all critical security patches'),
    (tech_id, 'Incident Response Time', 'Support', 4, 'hours', 3, cur_year, 'completed', 2.8, 'Joko Susilo', 'Resolve P1 incidents within 4 hours'),
    (tech_id, 'Digital Transformation Milestone', 'Strategy', 1, 'milestone', 4, cur_year, 'in_progress', 0, 'Kartika Sari', 'Complete Q2 digital transformation milestone'),
    (tech_id, 'IT Asset Inventory Update', 'Asset Mgmt', 100, '%', 5, cur_year, 'in_progress', 65, 'Joko Susilo', 'Update full IT asset inventory'),
    (tech_id, 'Application Performance Review', 'Performance', 5, 'apps', 6, cur_year, 'not_started', 0, 'Kartika Sari', 'Review performance of 5 critical apps'),
    (tech_id, 'Cybersecurity Awareness Training', 'Security', 100, '%', 7, cur_year, 'not_started', 0, 'Joko Susilo', 'All staff complete cybersecurity training'),
    (tech_id, 'Backup & Recovery Testing', 'Infrastructure', 100, '%', 8, cur_year, 'not_started', 0, 'Kartika Sari', 'Test disaster recovery procedures'),
    (tech_id, 'New System Implementation', 'Development', 1, 'system', 9, cur_year, 'not_started', 0, 'Joko Susilo', 'Deploy new ERP module'),
    (tech_id, 'Tech Debt Reduction', 'Development', 20, '%', 10, cur_year, 'not_started', 0, 'Kartika Sari', 'Reduce technical debt by 20%'),
    (tech_id, 'Year-End Security Audit', 'Security', 1, 'audit', 11, cur_year, 'not_started', 0, 'Joko Susilo', 'Complete annual security audit'),
    (tech_id, 'Annual Technology Report', 'Reporting', 1, 'report', 12, cur_year, 'not_started', 0, 'Kartika Sari', 'Submit comprehensive annual technology report');
END $$;
