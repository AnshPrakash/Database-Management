listen election_updates;

begin;
create or replace function notifier()
  returns trigger
  language plpgsql
as $$
declare
 channel text := TG_ARGV[0];
begin
  PERFORM(
    with payload(cand,party,votes,state,pc_name,pc_code) as
    (
      select NEW.cand,NEW.party,NEW.votes,NEW.state,NEW.pc_name,NEW.pc_code
    )
    select pg_notify(channel,row_to_json(payload)::text)
         from payload
  );
  RETURN NULL;
end;
$$;


CREATE TRIGGER notify
  AFTER INSERT OR UPDATE OR DELETE ON ge_2019_cand_wise
  FOR EACH ROW
   EXECUTE PROCEDURE notifier('election_updates');

commit;