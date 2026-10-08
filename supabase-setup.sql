-- Cogniss Roadmap: comments table
-- Run this once in Supabase: Dashboard → SQL Editor → New query → paste → Run.

create table if not exists public.comments (
  id         uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name       text not null check (char_length(btrim(name)) between 1 and 80),
  body       text not null check (char_length(btrim(body)) between 1 and 2000),
  ref        text not null default '' check (char_length(ref) <= 64)
);

-- Resolved / archived state (safe to re-run on an existing table)
alter table public.comments add column if not exists resolved    boolean not null default false;
alter table public.comments add column if not exists resolved_at timestamptz;

alter table public.comments enable row level security;

-- Visitors (no login) can read all comments, add new ones, and mark them
-- resolved or reopen them. They can't change a comment's name or text, or
-- delete anything. You moderate from the Supabase dashboard
-- (Table Editor → comments → select a row → Delete).
drop policy if exists "Anyone can read comments" on public.comments;
create policy "Anyone can read comments"
  on public.comments for select
  to anon
  using (true);

drop policy if exists "Anyone can add comments" on public.comments;
create policy "Anyone can add comments"
  on public.comments for insert
  to anon
  with check (true);

drop policy if exists "Anyone can resolve comments" on public.comments;
create policy "Anyone can resolve comments"
  on public.comments for update
  to anon
  using (true)
  with check (true);

-- New comments always start active; only the resolved columns can be updated.
revoke insert, update on public.comments from anon;
grant select on public.comments to anon;
grant insert (name, body, ref) on public.comments to anon;
grant update (resolved, resolved_at) on public.comments to anon;
