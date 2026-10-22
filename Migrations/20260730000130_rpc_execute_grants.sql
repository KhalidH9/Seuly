begin; -- 30: authenticated RPC execution

grant execute on function public.save_account(
    text,text,bigint,text,text,uuid,text
) to authenticated;
grant execute on function public.save_budget_line(
    uuid,bigint,uuid,date
) to authenticated;
grant execute on function public.complete_onboarding(
    uuid,text,text,text,text,bigint,bigint,text,date
) to authenticated;
grant execute on function public.save_financial_transaction(
    text,date,text,text,bigint,uuid,uuid,uuid,uuid,date
) to authenticated;
grant execute on function public.void_financial_transaction(uuid)
to authenticated;
grant execute on function public.create_goal(
    uuid,text,text,bigint,text,text,date,date
) to authenticated;
grant execute on function public.record_goal_contribution(
    uuid,uuid,bigint,text,date
) to authenticated;
grant execute on function public.create_recurring_rule(
    uuid,text,bigint,uuid,text,text,text,date,uuid,uuid,date
) to authenticated;

commit;
