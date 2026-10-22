begin; -- 09: recurring rules and legs

create table public.recurring_rules (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.profiles (id) on delete cascade,
    transaction_kind public.transaction_kind not null,
    merchant text,
    memo text,
    cadence public.recurring_cadence not null,
    next_run_on date not null,
    status public.recurring_status not null default 'active',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint recurring_rules_owner_id_key unique (user_id, id),
    constraint recurring_rules_merchant_check
        check (
            merchant is null
            or (
                merchant = btrim(merchant)
                and char_length(merchant) between 1 and 120
            )
        ),
    constraint recurring_rules_memo_check
        check (
            memo is null
            or (memo = btrim(memo) and char_length(memo) between 1 and 500)
        )
);

create table public.recurring_rule_legs (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null,
    recurring_rule_id uuid not null,
    account_id uuid not null,
    category_id uuid,
    amount_minor bigint not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint recurring_rule_legs_rule_owner_fk
        foreign key (user_id, recurring_rule_id)
        references public.recurring_rules (user_id, id) on delete cascade,
    constraint recurring_rule_legs_account_owner_fk
        foreign key (user_id, account_id)
        references public.accounts (user_id, id) on delete restrict,
    constraint recurring_rule_legs_category_owner_fk
        foreign key (user_id, category_id)
        references public.categories (user_id, id) on delete restrict,
    constraint recurring_rule_legs_rule_account_key
        unique (user_id, recurring_rule_id, account_id),
    constraint recurring_rule_legs_amount_check check (
        amount_minor <> 0
        and amount_minor between -9000000000000000 and 9000000000000000
    )
);

revoke all on table public.recurring_rules, public.recurring_rule_legs
from public, anon, authenticated;

commit;
