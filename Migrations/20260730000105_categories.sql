begin; -- 05: finance categories

create table public.categories (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.profiles (id) on delete cascade,
    parent_id uuid,
    kind public.category_kind not null,
    name text not null,
    icon_key text not null default 'square.grid.2x2.fill',
    color_role public.color_role not null default 'neutral',
    sort_order integer not null default 0,
    archived_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint categories_owner_id_key unique (user_id, id),
    constraint categories_owner_id_kind_key unique (user_id, id, kind),
    constraint categories_owner_kind_name_key unique (user_id, kind, name),
    constraint categories_parent_owner_kind_fk
        foreign key (user_id, parent_id, kind)
        references public.categories (user_id, id, kind)
        on delete restrict,
    constraint categories_parent_not_self_check check (parent_id is null or parent_id <> id),
    constraint categories_name_check
        check (name = btrim(name) and char_length(name) between 1 and 80),
    constraint categories_icon_key_check
        check (icon_key = btrim(icon_key) and char_length(icon_key) between 1 and 80),
    constraint categories_sort_order_check check (sort_order >= 0)
);

revoke all on table public.categories from public, anon, authenticated;

commit;
