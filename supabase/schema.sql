-- ReL Rekapan Retribusi Web 2026
-- Run this script in Supabase SQL Editor. It is safe to run once on a new project.

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category smallint not null check (category between 0 and 6),
  transaction_date date not null,
  ticket_start integer,
  ticket_end integer,
  ticket_price integer,
  ticket_count integer,
  amount bigint not null check (amount >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint ticket_fields_consistent check (
    (
      ticket_start is null and ticket_end is null and
      ticket_price is null and ticket_count is null
    )
    or
    (
      ticket_start is not null and ticket_end is not null and
      ticket_price is not null and ticket_count is not null and
      ticket_start > 0 and ticket_end >= ticket_start and
      ticket_price between 1000 and 10000 and
      mod(ticket_price, 1000) = 0 and
      ticket_count = ticket_end - ticket_start + 1 and
      amount = ticket_count * ticket_price
    )
  ),
  constraint one_category_per_day_per_user unique (user_id, category, transaction_date)
);

create index if not exists transactions_user_date_idx
  on public.transactions (user_id, transaction_date desc);

alter table public.transactions enable row level security;

drop policy if exists "Users can read their own transactions" on public.transactions;
create policy "Users can read their own transactions"
  on public.transactions for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own transactions" on public.transactions;
create policy "Users can insert their own transactions"
  on public.transactions for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own transactions" on public.transactions;
create policy "Users can update their own transactions"
  on public.transactions for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own transactions" on public.transactions;
create policy "Users can delete their own transactions"
  on public.transactions for delete
  to authenticated
  using (auth.uid() = user_id);

create or replace function public.set_transaction_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_transactions_updated_at on public.transactions;
create trigger set_transactions_updated_at
before update on public.transactions
for each row execute function public.set_transaction_updated_at();
