-- شغّله مرة واحدة في Supabase: SQL Editor > New query > Run
-- (في مشروع خطة الشغل، مش مشروع السيستم المالي)

create table public.planner_clients (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  store text not null default '',
  svc text not null default '',
  days int not null check (days > 0),
  start_date date not null,
  created_at timestamptz not null default now()
);

create table public.planner_tasks (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.planner_clients(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  t text not null,
  d int not null check (d > 0),
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create index on public.planner_clients (user_id);
create index on public.planner_tasks (user_id);
create index on public.planner_tasks (client_id);

alter table public.planner_clients enable row level security;
alter table public.planner_tasks enable row level security;

create policy "own clients" on public.planner_clients
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "own tasks" on public.planner_tasks
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
