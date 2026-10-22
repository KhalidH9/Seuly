begin; -- 01: schemas and enum types

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create type public.account_kind as enum (
    'cash',
    'checking',
    'savings',
    'investment',
    'credit_card',
    'loan',
    'other_asset',
    'other_liability'
);
create type public.category_kind as enum ('income', 'expense');
create type public.transaction_kind as enum ('expense', 'income', 'transfer');
create type public.transaction_status as enum ('pending', 'posted', 'void');
create type public.goal_kind as enum ('savings', 'debt', 'investment', 'other');
create type public.goal_status as enum ('active', 'paused', 'completed', 'cancelled');
create type public.goal_event_kind as enum ('contribution', 'withdrawal', 'adjustment');
create type public.recurring_cadence as enum ('weekly', 'monthly', 'yearly');
create type public.recurring_status as enum ('active', 'paused', 'completed');
create type public.color_role as enum (
    'teal',
    'savings',
    'investment',
    'transfer',
    'income',
    'debt',
    'information',
    'warning',
    'expense',
    'neutral'
);

revoke all on type
    public.account_kind, public.category_kind, public.transaction_kind,
    public.transaction_status, public.goal_kind, public.goal_status,
    public.goal_event_kind, public.recurring_cadence, public.recurring_status,
    public.color_role
from public, anon, authenticated;

commit;
