begin; -- 03: identity, preferences, and onboarding

create table public.profiles (
    id uuid primary key references auth.users (id) on delete cascade,
    display_name text not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint profiles_display_name_check
        check (
            display_name = btrim(display_name)
            and char_length(display_name) between 1 and 100
        )
);

create table public.user_preferences (
    user_id uuid primary key references public.profiles (id) on delete cascade,
    currency_code text not null default 'SAR'
        references public.currencies (code) on update cascade,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.onboarding_state (
    user_id uuid primary key references public.profiles (id) on delete cascade,
    completed_at timestamptz,
    completion_request_id uuid,
    completion_payload jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint onboarding_state_completed_at_check
        check (completed_at is null or completed_at >= created_at),
    constraint onboarding_state_completion_binding_check check (
        (completed_at is null and completion_request_id is null
            and completion_payload is null)
        or (completed_at is not null and completion_request_id is not null
            and completion_payload is not null)
    )
);

revoke all on table public.profiles, public.user_preferences,
    public.onboarding_state
from public, anon, authenticated;

commit;
