CREATE OR REPLACE PACKAGE eapply_status IS
   /****** 申请记录状态（1=已提交、2=已撤销、3=已审核、4=已拒绝、6-已提现、7=缴款成功） ******/
   /****** 适用于表 销售站（机构）现金充值（fund_charge_cash） 和 销售站（机构）提现（fund_withdraw） ******/
   applyed                  /* 1=已提交 */                  CONSTANT NUMBER := 1;
   canceled                 /* 2=已撤销 */                  CONSTANT NUMBER := 2;
   audited                  /* 3=已审核 */                  CONSTANT NUMBER := 3;
   resused                  /* 4=已拒绝 */                  CONSTANT NUMBER := 4;
   withdraw                 /* 6-已提现 */                  CONSTANT NUMBER := 6;
   charged                  /* 7=缴款成功 */                CONSTANT NUMBER := 7;
END;
/
