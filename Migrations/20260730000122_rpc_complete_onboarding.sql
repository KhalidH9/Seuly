begin; -- 22: complete_onboarding RPC

create function public.complete_onboarding(
    p_request_id uuid,
    p_display_name text,
    p_currency_code text,
    p_account_name text,
    p_account_kind text,
    p_opening_balance_minor bigint,
    p_monthly_budget_minor bigint default null,
    p_monthly_budget_category_name text default null,
    p_local_date date default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_payload jsonb := private.onboarding_payload(
        p_display_name, p_currency_code, p_account_name, p_account_kind,
        p_opening_balance_minor, p_monthly_budget_minor,
        p_monthly_budget_category_name
    );
    v_display_name text := v_payload ->> 'display_name';
    v_currency_code text := v_payload ->> 'currency_code';
    v_account_name text := v_payload ->> 'account_name';
    v_account_kind text := v_payload ->> 'account_kind';
    v_budget_category text := v_payload ->> 'monthly_budget_category_name';
    v_local_date date := coalesce(p_local_date, current_date);
    v_completed_account_id uuid;
    v_account_id uuid;
begin
    if p_request_id is null then
        raise exception 'An onboarding request identifier is required.'
            using errcode = '22023';
    end if;
    insert into public.profiles (id, display_name)
    values (v_user_id, 'Siyuli member') on conflict (id) do nothing;
    insert into public.onboarding_state (user_id)
    values (v_user_id) on conflict (user_id) do nothing;

    v_completed_account_id := private.completed_onboarding_account(
        v_user_id, p_request_id, v_payload
    );
    if v_completed_account_id is not null then
        return v_completed_account_id;
    end if;
    if char_length(v_display_name) not between 1 and 100 then
        raise exception 'Enter your name.' using errcode = '22023';
    end if;
    if p_monthly_budget_minor is not null and p_monthly_budget_minor < 0 then
        raise exception 'The monthly budget cannot be negative.' using errcode = '22023';
    end if;
    if abs(v_local_date - current_date) > 1 then
        raise exception 'The provided local date is outside the allowed range.'
            using errcode = '22023';
    end if;
    if not exists (
        select 1 from public.currencies as currency
        where currency.code = v_currency_code and currency.is_active
    ) then
        raise exception 'Choose a supported currency.' using errcode = '22023';
    end if;
    update public.profiles set display_name = v_display_name where id = v_user_id;
    insert into public.user_preferences (user_id, currency_code)
    values (v_user_id, v_currency_code)
    on conflict (user_id) do update
    set currency_code = excluded.currency_code;
    perform private.seed_default_categories(v_user_id);
    v_account_id := public.save_account(
        p_name => v_account_name,
        p_kind => v_account_kind,
        p_opening_balance_minor => p_opening_balance_minor,
        p_icon_key => 'building.columns.fill',
        p_color_role => 'teal',
        p_account_id => p_request_id,
        p_institution_name => null
    );
    perform private.create_onboarding_budget(
        p_monthly_budget_minor, v_budget_category, v_local_date
    );
    update public.onboarding_state
    set completed_at = now(), completion_request_id = p_request_id,
        completion_payload = v_payload
    where user_id = v_user_id;
    return v_account_id;
end;
$$;

revoke all on function public.complete_onboarding(
    uuid,text,text,text,text,bigint,bigint,text,date
) from public, anon, authenticated;

commit;
