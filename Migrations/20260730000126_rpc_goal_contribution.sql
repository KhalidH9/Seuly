begin; -- 26: record_goal_contribution RPC

create function public.record_goal_contribution(
    p_event_id uuid,
    p_goal_id uuid,
    p_amount_minor bigint,
    p_note text,
    p_local_date date default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_event_id uuid := p_event_id;
    v_note text := nullif(btrim(coalesce(p_note, '')), '');
    v_local_date date := coalesce(p_local_date, current_date);
begin
    if v_event_id is null then
        raise exception 'A contribution request identifier is required.'
            using errcode = '22023';
    end if;
    if p_amount_minor is null or p_amount_minor <= 0 then
        raise exception 'Enter a contribution greater than zero.' using errcode = '22023';
    end if;
    if p_amount_minor > 9000000000000000 then
        raise exception 'The contribution amount is too large.' using errcode = '22023';
    end if;
    if v_note is not null and char_length(v_note) > 500 then
        raise exception 'The contribution note is too long.' using errcode = '22023';
    end if;
    if exists (select 1 from public.goal_events where id = v_event_id) then
        perform 1 from public.goal_events as event
        where event.id = v_event_id and event.user_id = v_user_id
          and event.goal_id = p_goal_id and event.event_kind = 'contribution'
          and event.amount_minor = p_amount_minor
          and event.effective_on = v_local_date
          and event.note is not distinct from v_note;
        if not found then
            raise exception 'The contribution request identifier has different details.'
                using errcode = '22023';
        end if;
        return v_event_id;
    end if;
    if abs(v_local_date - current_date) > 1 then
        raise exception 'The provided local date is outside the allowed range.'
            using errcode = '22023';
    end if;
    perform 1 from public.goals as goal
    where goal.user_id = v_user_id
      and goal.id = p_goal_id
      and goal.status = 'active'
    for update;
    if not found then
        raise exception 'That goal is unavailable.' using errcode = '22023';
    end if;

    insert into public.goal_events (
        id, user_id, goal_id, event_kind, amount_minor, effective_on, note
    ) values (
        v_event_id, v_user_id, p_goal_id, 'contribution',
        p_amount_minor, v_local_date, v_note
    ) on conflict (id) do nothing;
    perform 1 from public.goal_events as event
    where event.id = v_event_id and event.user_id = v_user_id
      and event.goal_id = p_goal_id and event.event_kind = 'contribution'
      and event.amount_minor = p_amount_minor
      and event.effective_on = v_local_date
      and event.note is not distinct from v_note;
    if not found then
        raise exception 'The contribution request identifier has different details.'
            using errcode = '22023';
    end if;
    return v_event_id;
end;
$$;

revoke all on function public.record_goal_contribution(uuid,uuid,bigint,text,date)
from public, anon, authenticated;

commit;
