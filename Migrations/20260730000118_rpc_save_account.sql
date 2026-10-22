begin; -- 18: save_account RPC

create function public.save_account(
    p_name text,
    p_kind text,
    p_opening_balance_minor bigint,
    p_icon_key text,
    p_color_role text,
    p_account_id uuid,
    p_institution_name text default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_account_id uuid := p_account_id;
    v_currency_code text;
    v_kind public.account_kind;
    v_color_role public.color_role;
    v_name text := btrim(coalesce(p_name, ''));
    v_institution_name text := nullif(btrim(coalesce(p_institution_name, '')), '');
    v_icon_key text := btrim(coalesce(p_icon_key, ''));
    v_sort_order integer;
begin
    if v_account_id is null then
        raise exception 'An account request identifier is required.' using errcode = '22023';
    end if;
    if char_length(v_name) not between 1 and 100 then
        raise exception 'Give the account a name.' using errcode = '22023';
    end if;
    if p_kind is null or p_kind not in (
        'cash', 'checking', 'savings', 'investment', 'credit_card',
        'loan', 'other_asset', 'other_liability'
    ) then
        raise exception 'Choose a valid account type.' using errcode = '22023';
    end if;
    if p_color_role is null or p_color_role not in (
        'teal', 'savings', 'investment', 'transfer', 'income',
        'debt', 'information', 'warning', 'expense', 'neutral'
    ) then
        raise exception 'Choose a valid account color.' using errcode = '22023';
    end if;
    if char_length(v_icon_key) not between 1 and 80 then
        raise exception 'Choose a valid account icon.' using errcode = '22023';
    end if;
    if v_institution_name is not null and char_length(v_institution_name) > 120 then
        raise exception 'The institution name is too long.' using errcode = '22023';
    end if;
    if p_opening_balance_minor is null then
        raise exception 'Enter a valid opening balance.' using errcode = '22023';
    end if;
    if p_opening_balance_minor not between -9000000000000000 and 9000000000000000 then
        raise exception 'The opening balance is too large.' using errcode = '22023';
    end if;

    v_kind := p_kind::public.account_kind;
    v_color_role := p_color_role::public.color_role;
    if v_kind in ('credit_card', 'loan', 'other_liability')
       and p_opening_balance_minor > 0 then
        raise exception 'Liability opening balances must be zero or negative.'
            using errcode = '22023';
    end if;
    v_currency_code := private.require_user_currency(v_user_id);

    select coalesce(max(account.sort_order), -1) + 1 into v_sort_order
    from public.accounts as account where account.user_id = v_user_id;
    insert into public.accounts (
        id, user_id, name, kind, currency_code, opening_balance_minor,
        institution_name, icon_key, color_role, sort_order
    ) values (
        v_account_id, v_user_id, v_name, v_kind, v_currency_code,
        p_opening_balance_minor, v_institution_name, v_icon_key,
        v_color_role, v_sort_order
    ) on conflict (id) do nothing;
    update public.accounts
    set name = v_name, kind = v_kind,
        opening_balance_minor = p_opening_balance_minor,
        institution_name = v_institution_name,
        icon_key = v_icon_key, color_role = v_color_role
    where user_id = v_user_id and id = v_account_id and archived_at is null
    returning id into v_account_id;
    if not found then
        raise exception 'That account is unavailable.' using errcode = '22023';
    end if;
    return v_account_id;
end;
$$;

revoke all on function public.save_account(text,text,bigint,text,text,uuid,text)
from public, anon, authenticated;

commit;
