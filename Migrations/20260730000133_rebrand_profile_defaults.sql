begin; -- 33: Seuly profile default compatibility

update public.profiles
set display_name = 'Seuly member'
where display_name = 'Siyuli member';

create or replace function private.provision_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_display_name text;
begin
    v_display_name := coalesce(
        nullif(btrim(new.raw_user_meta_data ->> 'display_name'), ''),
        nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
        'Seuly member'
    );
    insert into public.profiles (id, display_name, created_at)
    values (
        new.id,
        btrim(left(v_display_name, 100)),
        coalesce(new.created_at, now())
    )
    on conflict (id) do nothing;
    insert into public.user_preferences (user_id, currency_code)
    values (new.id, 'SAR') on conflict (user_id) do nothing;
    insert into public.onboarding_state (user_id)
    values (new.id) on conflict (user_id) do nothing;
    perform private.seed_default_categories(new.id);
    return new;
end;
$$;

commit;
