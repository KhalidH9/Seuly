begin; -- 04: financial accounts

create table public.accounts (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.profiles (id) on delete cascade,
    name text not null,
    kind public.account_kind not null,
    currency_code text not null references public.currencies (code) on update cascade,
    opening_balance_minor bigint not null default 0,
    institution_name text,
    icon_key text not null default 'building.columns.fill',
    color_role public.color_role not null default 'teal',
    include_in_net_worth boolean not null default true,
    sort_order integer not null default 0,
    archived_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint accounts_owner_id_key unique (user_id, id),
    constraint accounts_name_check
        check (name = btrim(name) and char_length(name) between 1 and 100),
    constraint accounts_institution_name_check
        check (
            institution_name is null
            or (
                institution_name = btrim(institution_name)
                and char_length(institution_name) between 1 and 120
            )
        ),
    constraint accounts_icon_key_check
        check (icon_key = btrim(icon_key) and char_length(icon_key) between 1 and 80),
    constraint accounts_sort_order_check check (sort_order >= 0),
    constraint accounts_opening_balance_range_check
        check (opening_balance_minor between -9000000000000000 and 9000000000000000),
    constraint accounts_liability_opening_balance_check
        check (
            kind not in ('credit_card', 'loan', 'other_liability')
            or opening_balance_minor <= 0
        )
);

revoke all on table public.accounts from public, anon, authenticated;

commit;
