begin; -- 07: budgets and lines

create table public.budgets (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.profiles (id) on delete cascade,
    name text not null,
    currency_code text not null references public.currencies (code) on update cascade,
    starts_on date not null,
    ends_on date not null,
    archived_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint budgets_owner_id_key unique (user_id, id),
    constraint budgets_period_key unique (user_id, starts_on, ends_on),
    constraint budgets_name_check
        check (name = btrim(name) and char_length(name) between 1 and 100),
    constraint budgets_date_range_check check (starts_on < ends_on)
);

create table public.budget_lines (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null,
    budget_id uuid not null,
    category_id uuid not null,
    limit_minor bigint not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint budget_lines_budget_owner_fk
        foreign key (user_id, budget_id)
        references public.budgets (user_id, id) on delete cascade,
    constraint budget_lines_category_owner_fk
        foreign key (user_id, category_id)
        references public.categories (user_id, id) on delete restrict,
    constraint budget_lines_budget_category_key
        unique (user_id, budget_id, category_id),
    constraint budget_lines_limit_check
        check (limit_minor between 1 and 9000000000000000)
);

revoke all on table public.budgets, public.budget_lines
from public, anon, authenticated;

commit;
