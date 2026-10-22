begin; -- 17: child aggregate policies

create policy transaction_legs_read_through_transaction
on public.transaction_legs
for select to authenticated
using (
    user_id = auth.uid()
    and exists (
        select 1
        from public.financial_transactions as financial_transaction
        where financial_transaction.user_id = auth.uid()
          and financial_transaction.id = transaction_legs.transaction_id
    )
);

create policy budgets_read_own on public.budgets
for select to authenticated using (user_id = auth.uid());

create policy budget_lines_read_through_budget
on public.budget_lines
for select to authenticated
using (
    user_id = auth.uid()
    and exists (
        select 1
        from public.budgets as budget
        where budget.user_id = auth.uid()
          and budget.id = budget_lines.budget_id
    )
);

create policy goals_read_own on public.goals
for select to authenticated using (user_id = auth.uid());

create policy goal_events_read_through_goal
on public.goal_events
for select to authenticated
using (
    user_id = auth.uid()
    and exists (
        select 1
        from public.goals as goal
        where goal.user_id = auth.uid()
          and goal.id = goal_events.goal_id
    )
);

create policy recurring_rules_read_own on public.recurring_rules
for select to authenticated using (user_id = auth.uid());

create policy recurring_rule_legs_read_through_rule
on public.recurring_rule_legs
for select to authenticated
using (
    user_id = auth.uid()
    and exists (
        select 1
        from public.recurring_rules as recurring_rule
        where recurring_rule.user_id = auth.uid()
          and recurring_rule.id = recurring_rule_legs.recurring_rule_id
    )
);

commit;
