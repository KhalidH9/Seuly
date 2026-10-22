begin; -- 24: void_financial_transaction RPC

create function public.void_financial_transaction(p_transaction_id uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_user_id uuid := private.require_authenticated_user();
    v_transaction_id uuid;
begin
    if p_transaction_id is null then
        raise exception 'Choose a transaction.' using errcode = '22023';
    end if;
    update public.financial_transactions
    set status = 'void'
    where user_id = v_user_id and id = p_transaction_id
    returning id into v_transaction_id;
    if not found then
        raise exception 'That transaction is unavailable.' using errcode = '22023';
    end if;
    return v_transaction_id;
end;
$$;

revoke all on function public.void_financial_transaction(uuid)
from public, anon, authenticated;

commit;
