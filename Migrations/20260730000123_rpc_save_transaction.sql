begin; -- 23: save_financial_transaction RPC

create function public.save_financial_transaction(
    p_kind text,
    p_effective_on date,
    p_merchant text,
    p_memo text,
    p_amount_minor bigint,
    p_transaction_id uuid,
    p_source_account_id uuid default null,
    p_destination_account_id uuid default null,
    p_category_id uuid default null,
    p_local_date date default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_transaction_id uuid := p_transaction_id;
    v_kind public.transaction_kind;
    v_merchant text := nullif(btrim(coalesce(p_merchant, '')), '');
    v_memo text := nullif(btrim(coalesce(p_memo, '')), '');
    v_local_date date := coalesce(p_local_date, current_date);
    v_earliest_date date := (
        date_trunc('month', v_local_date::timestamp) - interval '23 months'
    )::date;
begin
    if v_transaction_id is null then
        raise exception 'A transaction request identifier is required.'
            using errcode = '22023';
    end if;
    if p_kind is null or p_kind not in ('expense', 'income', 'transfer') then
        raise exception 'Choose a valid transaction type.' using errcode = '22023';
    end if;
    if abs(v_local_date - current_date) > 1 then
        raise exception 'The provided local date is outside the allowed range.'
            using errcode = '22023';
    end if;
    if p_effective_on is null
       or p_effective_on not between v_earliest_date and v_local_date then
        raise exception 'Choose a date inside the available 24-month history.'
            using errcode = '22023';
    end if;
    if v_merchant is not null and char_length(v_merchant) > 120 then
        raise exception 'The merchant name is too long.' using errcode = '22023';
    end if;
    if v_memo is not null and char_length(v_memo) > 500 then
        raise exception 'The transaction note is too long.' using errcode = '22023';
    end if;
    v_kind := p_kind::public.transaction_kind;
    perform private.validate_journal_input(
        v_user_id, v_kind, p_amount_minor, p_source_account_id,
        p_destination_account_id, p_category_id
    );

    insert into public.financial_transactions (
        id, user_id, kind, status, effective_on, occurred_at, merchant, memo
    ) values (
        v_transaction_id, v_user_id, v_kind, 'posted', p_effective_on,
        now(), v_merchant, v_memo
    ) on conflict (id) do nothing;
    update public.financial_transactions
    set kind = v_kind, status = 'posted', effective_on = p_effective_on,
        merchant = v_merchant, memo = v_memo
    where user_id = v_user_id and id = v_transaction_id and status <> 'void'
    returning id into v_transaction_id;
    if not found then
        raise exception 'That transaction is unavailable.' using errcode = '22023';
    end if;
    delete from public.transaction_legs
    where user_id = v_user_id and transaction_id = v_transaction_id;

    insert into public.transaction_legs (
        user_id, transaction_id, account_id, category_id, amount_minor
    ) values (
        v_user_id, v_transaction_id, p_source_account_id,
        case when v_kind = 'transfer' then null else p_category_id end,
        case when v_kind = 'income' then p_amount_minor else -p_amount_minor end
    );
    if v_kind = 'transfer' then
        insert into public.transaction_legs (
            user_id, transaction_id, account_id, category_id, amount_minor
        ) values (
            v_user_id, v_transaction_id, p_destination_account_id, null, p_amount_minor
        );
    end if;
    return v_transaction_id;
end;
$$;

revoke all on function public.save_financial_transaction(
    text,date,text,text,bigint,uuid,uuid,uuid,uuid,date
) from public, anon, authenticated;

commit;
