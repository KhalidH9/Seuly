begin; -- 28: create_recurring_rule RPC
create function public.create_recurring_rule(
    p_rule_id uuid, p_kind text, p_amount_minor bigint,
    p_source_account_id uuid, p_merchant text, p_memo text,
    p_cadence text, p_next_run_on date,
    p_destination_account_id uuid default null, p_category_id uuid default null,
    p_local_date date default null
)
returns uuid language plpgsql security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user(); v_rule_id uuid;
    v_kind public.transaction_kind; v_cadence public.recurring_cadence;
    v_merchant text := nullif(btrim(coalesce(p_merchant, '')), ''); v_memo text := nullif(btrim(coalesce(p_memo, '')), '');
    v_local_date date := coalesce(p_local_date, current_date);
begin
    if p_rule_id is null then
        raise exception 'A recurring request identifier is required.' using errcode = '22023';
    end if;
    if p_kind is null or p_kind not in ('expense', 'income', 'transfer') then
        raise exception 'Choose a valid recurring transaction type.' using errcode = '22023';
    end if;
    if p_cadence is null or p_cadence not in ('weekly', 'monthly', 'yearly') then
        raise exception 'Choose a valid recurring cadence.' using errcode = '22023';
    end if;
    if p_amount_minor is null or p_amount_minor <= 0
       or p_amount_minor > 9000000000000000 then
        raise exception 'Enter a valid recurring amount.' using errcode = '22023';
    end if;
    if v_merchant is null or char_length(v_merchant) > 120 then
        raise exception 'Enter a valid merchant or recurring item name.' using errcode = '22023';
    end if;
    if v_memo is not null and char_length(v_memo) > 500 then
        raise exception 'The recurring note is too long.' using errcode = '22023';
    end if;
    v_kind := p_kind::public.transaction_kind;
    v_cadence := p_cadence::public.recurring_cadence;
    if exists (select 1 from public.recurring_rules where id = p_rule_id) then
        if not private.recurring_payload_matches(
            v_user_id, p_rule_id, v_kind, p_amount_minor, p_source_account_id,
            p_destination_account_id, p_category_id, v_merchant, v_memo,
            v_cadence, p_next_run_on
        ) then
            raise exception 'The recurring request identifier has different details.'
                using errcode = '22023';
        end if;
        return p_rule_id;
    end if;
    if abs(v_local_date - current_date) > 1 then
        raise exception 'The provided local date is outside the allowed range.'
            using errcode = '22023';
    end if;
    if p_next_run_on is null or p_next_run_on < v_local_date then
        raise exception 'Choose a next date that is today or later.' using errcode = '22023';
    end if;
    perform private.validate_journal_input(
        v_user_id, v_kind, p_amount_minor, p_source_account_id,
        p_destination_account_id, p_category_id
    );
    insert into public.recurring_rules (
        id, user_id, transaction_kind, merchant, memo,
        cadence, next_run_on, status
    ) values (
        p_rule_id, v_user_id, v_kind, v_merchant, v_memo,
        v_cadence, p_next_run_on, 'active'
    ) on conflict (id) do nothing returning id into v_rule_id;
    if v_rule_id is null then
        if not private.recurring_payload_matches(
            v_user_id, p_rule_id, v_kind, p_amount_minor, p_source_account_id,
            p_destination_account_id, p_category_id, v_merchant, v_memo,
            v_cadence, p_next_run_on
        ) then
            raise exception 'The recurring request identifier has different details.'
                using errcode = '22023';
        end if;
        return p_rule_id;
    end if;
    insert into public.recurring_rule_legs (
        user_id, recurring_rule_id, account_id, category_id, amount_minor
    ) values (
        v_user_id, v_rule_id, p_source_account_id,
        case when v_kind = 'transfer' then null else p_category_id end,
        case when v_kind = 'income' then p_amount_minor else -p_amount_minor end
    );
    if v_kind = 'transfer' then
        insert into public.recurring_rule_legs (
            user_id, recurring_rule_id, account_id, category_id, amount_minor
        ) values (v_user_id, v_rule_id, p_destination_account_id, null, p_amount_minor);
    end if;
    return v_rule_id;
end;
$$;
revoke all on function public.create_recurring_rule(
    uuid,text,bigint,uuid,text,text,text,date,uuid,uuid,date
) from public, anon, authenticated;
commit;
