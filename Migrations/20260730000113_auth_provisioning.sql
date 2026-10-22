begin; -- 13: auth provisioning

create function private.seed_default_categories(p_user_id uuid)
returns void
language sql
set search_path = ''
as $$
    insert into public.categories (
        user_id, kind, name, icon_key, color_role, sort_order
    )
    values
        (p_user_id, 'income',  'Salary',        'banknote.fill',        'income',      0),
        (p_user_id, 'income',  'Freelance',     'laptopcomputer',       'teal',        1),
        (p_user_id, 'income',  'Other income',  'plus.circle.fill',     'information', 2),
        (p_user_id, 'expense', 'Home',          'house.fill',           'savings',     3),
        (p_user_id, 'expense', 'Groceries',     'basket.fill',          'income',      4),
        (p_user_id, 'expense', 'Dining',        'fork.knife',           'expense',     5),
        (p_user_id, 'expense', 'Transport',     'car.fill',             'transfer',    6),
        (p_user_id, 'expense', 'Shopping',      'bag.fill',             'investment',  7),
        (p_user_id, 'expense', 'Utilities',     'bolt.fill',            'warning',     8),
        (p_user_id, 'expense', 'Subscriptions', 'repeat',               'debt',        9),
        (p_user_id, 'expense', 'Wellbeing',     'heart.fill',           'teal',       10),
        (p_user_id, 'expense', 'Other',         'square.grid.2x2.fill', 'neutral',    11)
    on conflict (user_id, kind, name) do nothing;
$$;

create function private.provision_auth_user()
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
        'Siyuli member'
    );
    insert into public.profiles (id, display_name, created_at)
    values (new.id, btrim(left(v_display_name, 100)), coalesce(new.created_at, now()))
    on conflict (id) do nothing;
    insert into public.user_preferences (user_id, currency_code)
    values (new.id, 'SAR') on conflict (user_id) do nothing;
    insert into public.onboarding_state (user_id)
    values (new.id) on conflict (user_id) do nothing;
    perform private.seed_default_categories(new.id);
    return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function private.provision_auth_user();

commit;
