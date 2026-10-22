begin; -- 12: journal validation helpers

create function private.assert_active_category(
    p_user_id uuid,
    p_category_id uuid,
    p_expected_kind public.category_kind
)
returns void
language plpgsql
stable
set search_path = ''
as $$
begin
    if p_category_id is null then
        raise exception 'Choose a category.' using errcode = '22023';
    end if;
    if not exists (
        select 1
        from public.categories as category
        where category.user_id = p_user_id
          and category.id = p_category_id
          and category.kind = p_expected_kind
          and category.archived_at is null
    ) then
        raise exception 'That category is unavailable for this transaction type.'
            using errcode = '22023';
    end if;
end;
$$;

create function private.validate_journal_input(
    p_user_id uuid,
    p_kind public.transaction_kind,
    p_amount_minor bigint,
    p_source_account_id uuid,
    p_destination_account_id uuid,
    p_category_id uuid
)
returns void
language plpgsql
stable
set search_path = ''
as $$
declare
    v_primary_currency text;
    v_source_currency text;
    v_destination_currency text;
begin
    if p_amount_minor is null or p_amount_minor <= 0 then
        raise exception 'Enter an amount greater than zero.' using errcode = '22023';
    end if;
    if p_amount_minor > 9000000000000000 then
        raise exception 'The amount is too large.' using errcode = '22023';
    end if;

    v_primary_currency := private.require_user_currency(p_user_id);
    v_source_currency := private.require_active_account(p_user_id, p_source_account_id);
    if v_source_currency <> v_primary_currency then
        raise exception 'The account currency does not match your primary currency.'
            using errcode = '22023';
    end if;

    if p_kind = 'transfer' then
        if p_destination_account_id is null
           or p_destination_account_id = p_source_account_id then
            raise exception 'Choose two different accounts.' using errcode = '22023';
        end if;
        if p_category_id is not null then
            raise exception 'Transfers cannot have a category.' using errcode = '22023';
        end if;
        v_destination_currency :=
            private.require_active_account(p_user_id, p_destination_account_id);
        if v_destination_currency <> v_source_currency then
            raise exception 'Transfers require accounts with the same currency.'
                using errcode = '22023';
        end if;
    else
        if p_destination_account_id is not null then
            raise exception 'Only transfers can have a destination account.'
                using errcode = '22023';
        end if;
        perform private.assert_active_category(
            p_user_id,
            p_category_id,
            case when p_kind = 'income'
                then 'income'::public.category_kind
                else 'expense'::public.category_kind
            end
        );
    end if;
end;
$$;

commit;
