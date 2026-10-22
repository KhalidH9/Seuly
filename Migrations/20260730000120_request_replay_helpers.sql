begin; -- 20: onboarding and goal replay helpers

create function private.onboarding_payload(
    p_display_name text,
    p_currency_code text,
    p_account_name text,
    p_account_kind text,
    p_opening_balance_minor bigint,
    p_monthly_budget_minor bigint,
    p_monthly_budget_category_name text
)
returns jsonb
language sql
immutable
set search_path = ''
as $$
    select jsonb_build_object(
        'display_name', btrim(coalesce(p_display_name, '')),
        'currency_code', upper(btrim(coalesce(p_currency_code, ''))),
        'account_name', btrim(coalesce(p_account_name, '')),
        'account_kind', btrim(coalesce(p_account_kind, '')),
        'opening_balance_minor', p_opening_balance_minor,
        'monthly_budget_minor', p_monthly_budget_minor,
        'monthly_budget_category_name',
            nullif(btrim(coalesce(p_monthly_budget_category_name, '')), '')
    );
$$;

create function private.completed_onboarding_account(
    p_user_id uuid,
    p_request_id uuid,
    p_payload jsonb
)
returns uuid
language plpgsql
set search_path = ''
as $$
declare
    v_completed_at timestamptz;
    v_saved_request_id uuid;
    v_saved_payload jsonb;
begin
    select state.completed_at, state.completion_request_id,
        state.completion_payload
    into v_completed_at, v_saved_request_id, v_saved_payload
    from public.onboarding_state as state
    where state.user_id = p_user_id
    for update;
    if not found then
        raise exception 'Onboarding state is unavailable.' using errcode = '22023';
    end if;
    if v_completed_at is null then
        return null;
    end if;
    if v_saved_request_id is distinct from p_request_id
       or v_saved_payload is distinct from p_payload then
        raise exception 'Onboarding was already completed with different details.'
            using errcode = '22023';
    end if;
    perform 1 from public.accounts as account
    where account.user_id = p_user_id and account.id = v_saved_request_id;
    if not found then
        raise exception 'The original onboarding account is unavailable.'
            using errcode = '22023';
    end if;
    return v_saved_request_id;
end;
$$;

create function private.goal_payload_matches(
    p_user_id uuid, p_goal_id uuid, p_name text,
    p_kind public.goal_kind, p_currency_code text,
    p_target_minor bigint, p_target_on date,
    p_icon_key text, p_color_role public.color_role
)
returns boolean
language sql
stable
set search_path = ''
as $$
    select exists (
        select 1 from public.goals as goal
        where goal.user_id = p_user_id and goal.id = p_goal_id
          and goal.name = p_name and goal.kind = p_kind
          and goal.currency_code = p_currency_code
          and goal.target_minor = p_target_minor
          and goal.target_on is not distinct from p_target_on
          and goal.icon_key = p_icon_key and goal.color_role = p_color_role
    );
$$;

commit;
