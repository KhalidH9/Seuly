begin; -- 16: forced RLS and root policies

alter table public.currencies enable row level security;
alter table public.currencies force row level security;
alter table public.profiles enable row level security;
alter table public.profiles force row level security;
alter table public.user_preferences enable row level security;
alter table public.user_preferences force row level security;
alter table public.onboarding_state enable row level security;
alter table public.onboarding_state force row level security;
alter table public.accounts enable row level security;
alter table public.accounts force row level security;
alter table public.categories enable row level security;
alter table public.categories force row level security;
alter table public.financial_transactions enable row level security;
alter table public.financial_transactions force row level security;
alter table public.transaction_legs enable row level security;
alter table public.transaction_legs force row level security;
alter table public.budgets enable row level security;
alter table public.budgets force row level security;
alter table public.budget_lines enable row level security;
alter table public.budget_lines force row level security;
alter table public.goals enable row level security;
alter table public.goals force row level security;
alter table public.goal_events enable row level security;
alter table public.goal_events force row level security;
alter table public.recurring_rules enable row level security;
alter table public.recurring_rules force row level security;
alter table public.recurring_rule_legs enable row level security;
alter table public.recurring_rule_legs force row level security;

create policy currencies_read_authenticated on public.currencies
for select to authenticated using (
    is_active or code = (
        select preference.currency_code
        from public.user_preferences as preference
        where preference.user_id = auth.uid()
    )
);
create policy profiles_read_own on public.profiles
for select to authenticated using (id = auth.uid());
create policy user_preferences_read_own on public.user_preferences
for select to authenticated using (user_id = auth.uid());
create policy onboarding_state_read_own on public.onboarding_state
for select to authenticated using (user_id = auth.uid());
create policy accounts_read_own on public.accounts
for select to authenticated using (user_id = auth.uid());
create policy categories_read_own on public.categories
for select to authenticated using (user_id = auth.uid());
create policy financial_transactions_read_own on public.financial_transactions
for select to authenticated using (user_id = auth.uid());

commit;
