package cls.taishan.cncp.cmi.entity;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;

/**
 * Created by Reno Main on 2016/9/19.
 */
@Setter
@Getter
public class Req1002Model implements Serializable {
    private static final long serialVersionUID = -7645559331778686595L;

    private long agencyCode;
    private String reqfn;
    private String bet_string;
}
