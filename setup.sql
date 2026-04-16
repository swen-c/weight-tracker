-- profiles 表
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  height numeric,
  target_weight numeric,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
create policy "Users can view own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can insert own profile" on public.profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- weight_records 表
create table if not exists public.weight_records (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  weight numeric not null,
  body_fat numeric,
  date date not null,
  created_at timestamptz default now()
);

alter table public.weight_records enable row level security;
create policy "Users can view own records" on public.weight_records for select using (auth.uid() = user_id);
create policy "Users can insert own records" on public.weight_records for insert with check (auth.uid() = user_id);
create policy "Users can delete own records" on public.weight_records for delete using (auth.uid() = user_id);
