begin; -- 21: onboarding budget helper

create function private.create_onboarding_budget(
    p_amount_minor bigint,
    p_category_name text,
    p_local_date date
)
returns void
language plpgsql
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_category_id uuid;
begin
    if p_amount_minor is null or p_amount_minor = 0 then
        return;
    end if;
    if p_category_name is not null then
        select category.id into v_category_id
        from public.categories as category
        where category.user_id = v_user_id
          and category.kind = 'expense'
          and category.name = p_category_name
          and category.archived_at is null
        order by category.sort_order limit 1;
    end if;
    if v_category_id is null then
        select category.id into v_category_id
        from public.categories as category
        where category.user_id = v_user_id
          and category.kind = 'expense'
          and category.name = 'Other'
          and category.archived_at is null
        order by category.sort_order limit 1;
    end if;
    if v_category_id is null then
        raise exception 'A default expense category could not be created.'
            using errcode = '22023';
    end if;
    perform public.save_budget_line(
        p_category_id => v_category_id,
        p_limit_minor => p_amount_minor,
        p_budget_id => null,
        p_local_date => p_local_date
    );
end;
$$;

commit;
