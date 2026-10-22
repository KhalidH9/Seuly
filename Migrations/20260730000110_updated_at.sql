begin; -- 10: shared updated-at triggers

create function private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
    new.updated_at := now();
    return new;
end;
$$;

create trigger currencies_set_updated_at before update on public.currencies
for each row execute function private.set_updated_at();
create trigger profiles_set_updated_at before update on public.profiles
for each row execute function private.set_updated_at();
create trigger user_preferences_set_updated_at before update on public.user_preferences
for each row execute function private.set_updated_at();
create trigger onboarding_state_set_updated_at before update on public.onboarding_state
for each row execute function private.set_updated_at();
create trigger accounts_set_updated_at before update on public.accounts
for each row execute function private.set_updated_at();
create trigger categories_set_updated_at before update on public.categories
for each row execute function private.set_updated_at();
create trigger financial_transactions_set_updated_at
before update on public.financial_transactions
for each row execute function private.set_updated_at();
create trigger transaction_legs_set_updated_at before update on public.transaction_legs
for each row execute function private.set_updated_at();
create trigger budgets_set_updated_at before update on public.budgets
for each row execute function private.set_updated_at();
create trigger budget_lines_set_updated_at before update on public.budget_lines
for each row execute function private.set_updated_at();
create trigger goals_set_updated_at before update on public.goals
for each row execute function private.set_updated_at();
create trigger goal_events_set_updated_at before update on public.goal_events
for each row execute function private.set_updated_at();
create trigger recurring_rules_set_updated_at before update on public.recurring_rules
for each row execute function private.set_updated_at();
create trigger recurring_rule_legs_set_updated_at
before update on public.recurring_rule_legs
for each row execute function private.set_updated_at();

commit;
