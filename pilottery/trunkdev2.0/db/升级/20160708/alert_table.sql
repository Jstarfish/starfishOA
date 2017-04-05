alter table HIS_SELLTICKET add TRANS_SEQ NUMBER(18) default 0 not null;
alter table HIS_CANCELTICKET add TRANS_SEQ NUMBER(18) default 0 not null;
alter table HIS_PAYTICKET add TRANS_SEQ NUMBER(18) default 0 not null;

comment on column HIS_SELLTICKET.TRANS_SEQ is '交易序号';
comment on column HIS_CANCELTICKET.TRANS_SEQ is '交易序号';
comment on column HIS_PAYTICKET.TRANS_SEQ is '交易序号';

