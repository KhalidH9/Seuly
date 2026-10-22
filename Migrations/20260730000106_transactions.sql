begin; -- 06: journal transactions and legs

create table public.financial_transactions (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.profiles (id) on delete cascade,
    kind public.transaction_kind not null,
    status public.transaction_status not null default 'posted',
    effective_on date not null,
    occurred_at timestamptz,
    merchant text,
    memo text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint financial_transactions_owner_id_key unique (user_id, id),
    constraint financial_transactions_merchant_check
        check (
            merchant is null
            or (
                merchant = btrim(merchant)
                and char_length(merchant) between 1 and 120
            )
        ),
    constraint financial_transactions_memo_check
        check (
            memo is null
            or (memo = btrim(memo) and char_length(memo) between 1 and 500)
        )
);

create table public.transaction_legs (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null,
    transaction_id uuid not null,
    account_id uuid not null,
    category_id uuid,
    amount_minor bigint not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint transaction_legs_transaction_owner_fk
        foreign key (user_id, transaction_id)
        references public.financial_transactions (user_id, id) on delete cascade,
    constraint transaction_legs_account_owner_fk
        foreign key (user_id, account_id)
        references public.accounts (user_id, id) on delete restrict,
    constraint transaction_legs_category_owner_fk
        foreign key (user_id, category_id)
        references public.categories (user_id, id) on delete restrict,
    constraint transaction_legs_transaction_account_key
        unique (user_id, transaction_id, account_id),
    constraint transaction_legs_amount_check check (
        amount_minor <> 0
        and amount_minor between -9000000000000000 and 9000000000000000
    )
);

revoke all on table public.financial_transactions, public.transaction_legs
from public, anon, authenticated;

commit;
