package cls.pilottery.oms.issue.model;

import java.util.ArrayList;
import java.util.List;


public class AreaSaleXml {

        public String game;
        public String issue;
        
        public String s_amount_r;
        public String s_amount;
        public String s_ticket_cnt;
        public String s_bet_cnt;
        public String c_amount;
        public String c_ticket_cnt;
        public String c_bet_cnt;
        
        public List<AreaSale> area_all = new ArrayList<AreaSale>();
        
        public class AreaSale {
            public String code;
            
            public String s_amount_r;
            public String s_amount;
            public String s_ticket_cnt;
            public String s_bet_cnt;
            public String c_amount;
            public String c_ticket_cnt;
            public String c_bet_cnt;
            
            public String getCode() {
                return code;
            }
            public void setCode(String code) {
                this.code = code;
            }

            public String getS_amount_r() {
                return s_amount_r;
            }
            public void setS_amount_r(String sAmountR) {
                s_amount_r = sAmountR;
            }
            public String getS_amount() {
                return s_amount;
            }
            public void setS_amount(String sAmount) {
                s_amount = sAmount;
            }
            public String getS_ticket_cnt() {
                return s_ticket_cnt;
            }
            public void setS_ticket_cnt(String sTicketCnt) {
                s_ticket_cnt = sTicketCnt;
            }
            public String getS_bet_cnt() {
                return s_bet_cnt;
            }
            public void setS_bet_cnt(String sBetCnt) {
                s_bet_cnt = sBetCnt;
            }
            public String getC_amount() {
                return c_amount;
            }
            public void setC_amount(String cAmount) {
                c_amount = cAmount;
            }
            public String getC_ticket_cnt() {
                return c_ticket_cnt;
            }
            public void setC_ticket_cnt(String cTicketCnt) {
                c_ticket_cnt = cTicketCnt;
            }
            public String getC_bet_cnt() {
                return c_bet_cnt;
            }
            public void setC_bet_cnt(String cBetCnt) {
                c_bet_cnt = cBetCnt;
            }
            
            
            
        }

        
        public String getGame() {
            return game;
        }

        public void setGame(String game) {
            this.game = game;
        }

        public String getIssue() {
            return issue;
        }

        public void setIssue(String issue) {
            this.issue = issue;
        }

        public String getS_amount_r() {
            return s_amount_r;
        }

        public void setS_amount_r(String sAmountR) {
            s_amount_r = sAmountR;
        }

        public String getS_amount() {
            return s_amount;
        }

        public void setS_amount(String sAmount) {
            s_amount = sAmount;
        }

        public String getS_ticket_cnt() {
            return s_ticket_cnt;
        }

        public void setS_ticket_cnt(String sTicketCnt) {
            s_ticket_cnt = sTicketCnt;
        }

        public String getS_bet_cnt() {
            return s_bet_cnt;
        }

        public void setS_bet_cnt(String sBetCnt) {
            s_bet_cnt = sBetCnt;
        }

        public String getC_amount() {
            return c_amount;
        }

        public void setC_amount(String cAmount) {
            c_amount = cAmount;
        }

        public String getC_ticket_cnt() {
            return c_ticket_cnt;
        }

        public void setC_ticket_cnt(String cTicketCnt) {
            c_ticket_cnt = cTicketCnt;
        }

        public String getC_bet_cnt() {
            return c_bet_cnt;
        }

        public void setC_bet_cnt(String cBetCnt) {
            c_bet_cnt = cBetCnt;
        }

        public List<AreaSale> getArea_all() {
            return area_all;
        }

        public void setArea_all(List<AreaSale> areaAll) {
            area_all = areaAll;
        }

}
