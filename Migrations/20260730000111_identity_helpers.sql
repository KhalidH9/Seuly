begin; -- 11: identity and account helpers

create function private.require_authenticated_user()
returns uuid
language plpgsql
stable
set search_path = ''
as $$
declare
    v_user_id uuid := auth.uid();
begin
    if v_user_id is null then
        raise exception 'Authentication is required.' using errcode = '28000';
    end if;
    return v_user_id;
end;
$$;

create function private.require_user_currency(p_user_id uuid)
returns text
language plpgsql
stable
set search_path = ''
as $$
declare
    v_currency_code text;
begin
    select preferences.currency_code
    into v_currency_code
    from public.user_preferences as preferences
    where preferences.user_id = p_user_id;

    if not found then
        raise exception 'User preferences are unavailable.' using errcode = '22023';
    end if;
    return v_currency_code;
end;
$$;

create function private.require_active_account(
    p_user_id uuid,
    p_account_id uuid
)
returns text
language plpgsql
stable
set search_path = ''
as $$
declare
    v_currency_code text;
begin
    if p_account_id is null then
        raise exception 'Choose an account.' using errcode = '22023';
    end if;

    select account.currency_code
    into v_currency_code
    from public.accounts as account
    where account.user_id = p_user_id
      and account.id = p_account_id
      and account.archived_at is null;

    if not found then
        raise exception 'That account is unavailable.' using errcode = '22023';
    end if;
    return v_currency_code;
end;
$$;

commit;
