package cls.taishan.common.encrypt;

public class EncryptMain {

    public static void main(String[] args) throws Exception {  
        String filepath="./";  
  
        RSAEncrypt.genKeyPair(filepath);  

        System.out.println("--------------- use private key to generate the signation ------------------");  
        String content = " token=123456&transType=1006&digest=JLZ9wlmPZT8bJgXUJEvyoYtwWX+U3BcvS7l12AEJEzacuevYXZYXjXKXzEPfzZE+h7u7q98xNGrGJldx4N+J2bmC945MOJfiRLt4NJlT8qHJvSVSCQxDwqAkV/WOuNG9teDgxFdDedcYtJNnooxwXKRATogAjXAQxo6oFc50p9c=&transMessage={\"messengerId\":\"12+/=34\",\"timestamp\":1473817588774,\"token\":\"123456\",\"transType\":1006}";

        String signstr=RSASignature.sign(content,RSAEncrypt.loadPrivateKeyByFile(filepath));  

        System.out.println("Source Content : "+content);  
        System.out.println("Sign Result : "+signstr);  
        System.out.println();  
        
        System.out.println("--------------- use public key to check the signation ------------------");  
        System.out.println("Source Content : " + content);  
        System.out.println("Signation : " + signstr);  
        System.out.println("Check result : " + RSASignature.doCheck(content, signstr, RSAEncrypt.loadPublicKeyByFile(filepath)));  
    }  
}
