begin; -- 29: table, view, type, and helper access

grant select on table
    public.currencies,
    public.profiles,
    public.user_preferences,
    public.onboarding_state,
    public.accounts,
    public.categories,
    public.financial_transactions,
    public.transaction_legs,
    public.budgets,
    public.budget_lines,
    public.goals,
    public.goal_events,
    public.recurring_rules,
    public.recurring_rule_legs,
    public.profile_overview,
    public.goal_overview
to authenticated;

grant all privileges on table
    public.currencies,
    public.profiles,
    public.user_preferences,
    public.onboarding_state,
    public.accounts,
    public.categories,
    public.financial_transactions,
    public.transaction_legs,
    public.budgets,
    public.budget_lines,
    public.goals,
    public.goal_events,
    public.recurring_rules,
    public.recurring_rule_legs
to service_role;
grant select on table public.profile_overview, public.goal_overview
to service_role;

grant usage on type
    public.account_kind,
    public.category_kind,
    public.transaction_kind,
    public.transaction_status,
    public.goal_kind,
    public.goal_status,
    public.goal_event_kind,
    public.recurring_cadence,
    public.recurring_status,
    public.color_role
to authenticated, service_role;

revoke execute on all functions in schema private
from public, anon, authenticated;

commit;
