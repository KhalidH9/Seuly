begin; -- 25: create_goal RPC

create function public.create_goal(
    p_goal_id uuid,
    p_name text,
    p_kind text,
    p_target_minor bigint,
    p_icon_key text,
    p_color_role text,
    p_target_on date default null,
    p_local_date date default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_goal_id uuid := p_goal_id;
    v_name text := btrim(coalesce(p_name, ''));
    v_icon_key text := btrim(coalesce(p_icon_key, ''));
    v_local_date date := coalesce(p_local_date, current_date);
    v_kind public.goal_kind;
    v_color_role public.color_role;
    v_currency_code text;
begin
    if v_goal_id is null then
        raise exception 'A goal request identifier is required.' using errcode = '22023';
    end if;
    if char_length(v_name) not between 1 and 100 then
        raise exception 'Give the goal a name.' using errcode = '22023';
    end if;
    if p_kind is null or p_kind not in ('savings', 'debt', 'investment', 'other') then
        raise exception 'Choose a valid goal type.' using errcode = '22023';
    end if;
    if p_target_minor is null or p_target_minor <= 0 then
        raise exception 'Enter a target greater than zero.' using errcode = '22023';
    end if;
    if p_target_minor > 9000000000000000 then
        raise exception 'The target amount is too large.' using errcode = '22023';
    end if;
    if char_length(v_icon_key) not between 1 and 80 then
        raise exception 'Choose a valid goal icon.' using errcode = '22023';
    end if;
    if p_color_role is null or p_color_role not in (
        'teal', 'savings', 'investment', 'transfer', 'income',
        'debt', 'information', 'warning', 'expense', 'neutral'
    ) then
        raise exception 'Choose a valid goal color.' using errcode = '22023';
    end if;
    v_kind := p_kind::public.goal_kind;
    v_color_role := p_color_role::public.color_role;
    v_currency_code := private.require_user_currency(v_user_id);
    if exists (select 1 from public.goals where id = v_goal_id) then
        if not private.goal_payload_matches(
            v_user_id, v_goal_id, v_name, v_kind, v_currency_code,
            p_target_minor, p_target_on, v_icon_key, v_color_role
        ) then
            raise exception 'The goal request identifier has different details.'
                using errcode = '22023';
        end if;
        return v_goal_id;
    end if;
    if abs(v_local_date - current_date) > 1 then
        raise exception 'The provided local date is outside the allowed range.'
            using errcode = '22023';
    end if;
    if p_target_on is not null and p_target_on < v_local_date then
        raise exception 'Choose a target date that is today or later.'
            using errcode = '22023';
    end if;

    insert into public.goals (
        id, user_id, name, kind, currency_code, target_minor,
        target_on, status, icon_key, color_role
    ) values (
        v_goal_id, v_user_id, v_name, v_kind, v_currency_code, p_target_minor,
        p_target_on, 'active', v_icon_key, v_color_role
    ) on conflict (id) do nothing;
    if not private.goal_payload_matches(
        v_user_id, v_goal_id, v_name, v_kind, v_currency_code,
        p_target_minor, p_target_on, v_icon_key, v_color_role
    ) then
        raise exception 'The goal request identifier has different details.'
            using errcode = '22023';
    end if;
    return v_goal_id;
end;
$$;

revoke all on function public.create_goal(uuid,text,text,bigint,text,text,date,date)
from public, anon, authenticated;

commit;
