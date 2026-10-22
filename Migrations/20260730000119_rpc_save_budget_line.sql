begin; -- 19: save_budget_line RPC

create function public.save_budget_line(
    p_category_id uuid,
    p_limit_minor bigint,
    p_budget_id uuid default null,
    p_local_date date default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_currency_code text := private.require_user_currency(v_user_id);
    v_budget_id uuid;
    v_budget_currency text;
    v_line_id uuid;
    v_local_date date := coalesce(p_local_date, current_date);
    v_month_start date := date_trunc('month', v_local_date::timestamp)::date;
    v_month_end date :=
        (date_trunc('month', v_local_date::timestamp) + interval '1 month')::date;
begin
    if abs(v_local_date - current_date) > 1 then
        raise exception 'The provided local date is outside the allowed range.'
            using errcode = '22023';
    end if;
    if p_limit_minor is null or p_limit_minor <= 0 then
        raise exception 'Enter a budget greater than zero.' using errcode = '22023';
    end if;
    if p_limit_minor > 9000000000000000 then
        raise exception 'The budget amount is too large.' using errcode = '22023';
    end if;
    perform private.assert_active_category(
        v_user_id, p_category_id, 'expense'::public.category_kind
    );

    if p_budget_id is null then
        insert into public.budgets (
            user_id, name, currency_code, starts_on, ends_on
        ) values (
            v_user_id, 'Monthly rhythm', v_currency_code,
            v_month_start, v_month_end
        )
        on conflict (user_id, starts_on, ends_on) do update
        set archived_at = null, updated_at = excluded.updated_at
        returning id into v_budget_id;
    else
        select budget.id, budget.currency_code
        into v_budget_id, v_budget_currency
        from public.budgets as budget
        where budget.user_id = v_user_id
          and budget.id = p_budget_id
          and budget.archived_at is null
        for update;
        if not found then
            raise exception 'That budget is unavailable.' using errcode = '22023';
        end if;
        if v_budget_currency <> v_currency_code then
            raise exception 'The budget currency does not match your primary currency.'
                using errcode = '22023';
        end if;
    end if;

    insert into public.budget_lines (
        user_id, budget_id, category_id, limit_minor
    ) values (
        v_user_id, v_budget_id, p_category_id, p_limit_minor
    )
    on conflict (user_id, budget_id, category_id) do update
    set limit_minor = excluded.limit_minor
    returning id into v_line_id;
    return v_line_id;
end;
$$;

revoke all on function public.save_budget_line(uuid,bigint,uuid,date)
from public, anon, authenticated;

commit;
