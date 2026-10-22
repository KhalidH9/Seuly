begin; -- 31: server-computed account balances

create view public.account_overview
with (security_invoker = true, security_barrier = true)
as
select
    account.id, account.user_id, account.name, account.kind,
    account.currency_code, account.opening_balance_minor,
    account.institution_name, account.icon_key, account.color_role,
    account.include_in_net_worth, account.sort_order, account.archived_at,
    greatest(
        -9000000000000000,
        least(
            9000000000000000,
            account.opening_balance_minor::numeric
                + coalesce(
                    sum(leg.amount_minor) filter (
                        where transaction.status = 'posted'
                    ),
                    0
                )
        )
    )::bigint as balance_minor
from public.accounts as account
left join public.transaction_legs as leg
  on leg.user_id = account.user_id and leg.account_id = account.id
left join public.financial_transactions as transaction
  on transaction.user_id = leg.user_id and transaction.id = leg.transaction_id
group by account.id;

revoke all on table public.account_overview
from public, anon, authenticated;
grant select on table public.account_overview to authenticated, service_role;

commit;
