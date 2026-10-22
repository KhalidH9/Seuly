begin; -- 15: query and ownership indexes

create index accounts_user_sort_idx on public.accounts (user_id, sort_order);
create index categories_user_sort_idx on public.categories (user_id, sort_order);
create index categories_parent_idx on public.categories (user_id, parent_id)
where parent_id is not null;
create index financial_transactions_user_effective_idx
on public.financial_transactions (user_id, effective_on desc, created_at desc)
where status <> 'void';
create index financial_transactions_user_cursor_idx
on public.financial_transactions (user_id, created_at desc, id desc)
where status <> 'void';
create index transaction_legs_transaction_idx
on public.transaction_legs (user_id, transaction_id);
create index transaction_legs_account_idx
on public.transaction_legs (user_id, account_id);
create index transaction_legs_category_idx
on public.transaction_legs (user_id, category_id)
where category_id is not null;
create index budgets_user_starts_idx
on public.budgets (user_id, starts_on desc) where archived_at is null;
create index budget_lines_budget_idx on public.budget_lines (user_id, budget_id);
create index budget_lines_category_idx on public.budget_lines (user_id, category_id);
create index goals_user_status_created_idx
on public.goals (user_id, status, created_at);
create index goal_events_goal_effective_idx
on public.goal_events (user_id, goal_id, effective_on desc);
create index recurring_rules_user_next_run_idx
on public.recurring_rules (user_id, status, next_run_on);
create index recurring_rule_legs_rule_idx
on public.recurring_rule_legs (user_id, recurring_rule_id);
create index recurring_rule_legs_account_idx
on public.recurring_rule_legs (user_id, account_id);
create index recurring_rule_legs_category_idx
on public.recurring_rule_legs (user_id, category_id)
where category_id is not null;

commit;
