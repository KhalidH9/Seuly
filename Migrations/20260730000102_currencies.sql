begin; -- 02: currency reference data

create table public.currencies (
    code text primary key,
    name text not null,
    symbol text not null,
    minor_unit smallint not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint currencies_code_format_check check (code ~ '^[A-Z]{3}$'),
    constraint currencies_name_check
        check (name = btrim(name) and char_length(name) between 1 and 80),
    constraint currencies_symbol_check
        check (symbol = btrim(symbol) and char_length(symbol) between 1 and 12),
    constraint currencies_minor_unit_check check (minor_unit between 0 and 3)
);

insert into public.currencies (code, name, symbol, minor_unit)
values
    ('SAR', 'Saudi Riyal', 'ر.س', 2),
    ('AED', 'UAE Dirham', 'د.إ', 2),
    ('USD', 'US Dollar', '$', 2),
    ('EUR', 'Euro', '€', 2),
    ('GBP', 'Pound Sterling', '£', 2),
    ('KWD', 'Kuwaiti Dinar', 'د.ك', 3),
    ('BHD', 'Bahraini Dinar', 'د.ب', 3),
    ('OMR', 'Omani Rial', 'ر.ع.', 3),
    ('JPY', 'Japanese Yen', '¥', 0)
on conflict (code) do update
set name = excluded.name,
    symbol = excluded.symbol,
    minor_unit = excluded.minor_unit,
    is_active = true,
    updated_at = now();

revoke all on table public.currencies from public, anon, authenticated;

commit;
