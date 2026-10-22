begin; -- 14: existing-user backfill and profile view

insert into public.profiles (id, display_name, created_at)
select
    auth_user.id,
    btrim(left(
        coalesce(
            nullif(btrim(auth_user.raw_user_meta_data ->> 'display_name'), ''),
            nullif(split_part(coalesce(auth_user.email, ''), '@', 1), ''),
            'Siyuli member'
        ),
        100
    )),
    coalesce(auth_user.created_at, now())
from auth.users as auth_user
on conflict (id) do nothing;

insert into public.user_preferences (user_id, currency_code)
select profile.id, 'SAR' from public.profiles as profile
on conflict (user_id) do nothing;

insert into public.onboarding_state (user_id)
select profile.id from public.profiles as profile
on conflict (user_id) do nothing;

do $$
declare
    v_user_id uuid;
begin
    for v_user_id in select profile.id from public.profiles as profile
    loop
        perform private.seed_default_categories(v_user_id);
    end loop;
end;
$$;

create view public.profile_overview
with (security_invoker = true, security_barrier = true)
as
select
    profile.id,
    profile.display_name,
    preferences.currency_code,
    onboarding.completed_at is not null as onboarding_completed,
    profile.created_at
from public.profiles as profile
join public.user_preferences as preferences
  on preferences.user_id = profile.id
join public.onboarding_state as onboarding
  on onboarding.user_id = profile.id;

revoke all on table public.profile_overview from public, anon, authenticated;

create view public.goal_overview
with (security_invoker = true, security_barrier = true)
as
select
    goal.id, goal.user_id, goal.name, goal.kind, goal.currency_code,
    goal.target_minor, goal.target_on, goal.status,
    goal.icon_key, goal.color_role,
    greatest(
        0,
        least(
            coalesce(sum(event.amount_minor), 0),
            9223372036854775807
        )
    )::bigint as progress_minor
from public.goals as goal
left join public.goal_events as event
  on event.user_id = goal.user_id and event.goal_id = goal.id
group by goal.id;

revoke all on table public.goal_overview from public, anon, authenticated;

commit;
