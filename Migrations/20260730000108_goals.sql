begin; -- 08: goals and events

create table public.goals (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.profiles (id) on delete cascade,
    name text not null,
    kind public.goal_kind not null,
    currency_code text not null references public.currencies (code) on update cascade,
    target_minor bigint not null,
    target_on date,
    status public.goal_status not null default 'active',
    icon_key text not null default 'target',
    color_role public.color_role not null default 'savings',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint goals_owner_id_key unique (user_id, id),
    constraint goals_name_check
        check (name = btrim(name) and char_length(name) between 1 and 100),
    constraint goals_target_check
        check (target_minor between 1 and 9000000000000000),
    constraint goals_icon_key_check
        check (icon_key = btrim(icon_key) and char_length(icon_key) between 1 and 80)
);

create table public.goal_events (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null,
    goal_id uuid not null,
    event_kind public.goal_event_kind not null,
    amount_minor bigint not null,
    effective_on date not null default current_date,
    note text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint goal_events_goal_owner_fk
        foreign key (user_id, goal_id)
        references public.goals (user_id, id) on delete cascade,
    constraint goal_events_amount_direction_check
        check (
            amount_minor between -9000000000000000 and 9000000000000000
            and (
                (event_kind = 'contribution' and amount_minor > 0)
                or (event_kind = 'withdrawal' and amount_minor < 0)
                or (event_kind = 'adjustment' and amount_minor <> 0)
            )
        ),
    constraint goal_events_note_check
        check (
            note is null
            or (note = btrim(note) and char_length(note) between 1 and 500)
        )
);

revoke all on table public.goals, public.goal_events
from public, anon, authenticated;

commit;
