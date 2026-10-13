-- XY 报价助手：数据表和权限
-- 在 Supabase 的 SQL Editor 里运行一次即可。

create table if not exists public.docs (
  collection text not null,
  id         text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);

-- 打开行级安全：没有登录的人什么都看不到、改不了
alter table public.docs enable row level security;

revoke all on public.docs from anon;
grant select, insert, update, delete on public.docs to authenticated;

drop policy if exists "signed-in users can read"   on public.docs;
drop policy if exists "signed-in users can write"  on public.docs;
drop policy if exists "signed-in users can update" on public.docs;
drop policy if exists "signed-in users can delete" on public.docs;

create policy "signed-in users can read"   on public.docs for select to authenticated using (true);
create policy "signed-in users can write"  on public.docs for insert to authenticated with check (true);
create policy "signed-in users can update" on public.docs for update to authenticated using (true) with check (true);
create policy "signed-in users can delete" on public.docs for delete to authenticated using (true);
