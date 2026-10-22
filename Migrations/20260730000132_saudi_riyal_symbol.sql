begin; -- 32: official Saudi riyal symbol

do $migration$
declare
    updated_rows integer;
begin
    update public.currencies
    set symbol = chr(8385),
        updated_at = now()
    where code = 'SAR';

    get diagnostics updated_rows = row_count;

    if updated_rows <> 1 then
        raise exception
            'Expected one SAR currency row, updated %', updated_rows;
    end if;

    if not exists (
        select 1
        from public.currencies
        where code = 'SAR'
          and symbol = chr(8385)
          and char_length(symbol) = 1
    ) then
        raise exception 'Saudi riyal symbol verification failed';
    end if;
end
$migration$;

commit;
