begin; -- 27: recurring request replay helper

create function private.recurring_payload_matches(
    p_user_id uuid,
    p_rule_id uuid,
    p_kind public.transaction_kind,
    p_amount_minor bigint,
    p_source_account_id uuid,
    p_destination_account_id uuid,
    p_category_id uuid,
    p_merchant text,
    p_memo text,
    p_cadence public.recurring_cadence,
    p_next_run_on date
)
returns boolean
language sql
stable
set search_path = ''
as $$
    select exists (
        select 1
        from public.recurring_rules as rule
        where rule.user_id = p_user_id and rule.id = p_rule_id
          and rule.transaction_kind = p_kind
          and rule.merchant is not distinct from p_merchant
          and rule.memo is not distinct from p_memo
          and rule.cadence = p_cadence
          and rule.next_run_on = p_next_run_on
          and ((p_kind = 'transfer' and p_category_id is null
                  and p_destination_account_id is not null)
              or (p_kind <> 'transfer' and p_category_id is not null
                  and p_destination_account_id is null))
          and (
              select count(*) = case when p_kind = 'transfer' then 2 else 1 end
                and count(*) filter (
                    where leg.account_id = p_source_account_id
                      and leg.category_id is not distinct from p_category_id
                      and leg.amount_minor = case when p_kind = 'income'
                          then p_amount_minor else -p_amount_minor end
                ) = 1
                and (
                    p_kind <> 'transfer'
                    or count(*) filter (
                        where leg.account_id = p_destination_account_id
                          and leg.category_id is null
                          and leg.amount_minor = p_amount_minor
                    ) = 1
                )
              from public.recurring_rule_legs as leg
              where leg.user_id = p_user_id
                and leg.recurring_rule_id = p_rule_id
          )
    );
$$;

commit;
