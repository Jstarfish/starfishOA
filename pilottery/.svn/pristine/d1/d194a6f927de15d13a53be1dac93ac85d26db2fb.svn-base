package cls.taishan.common.encrypt;

public class EncryptMain {

    public static void main(String[] args) throws Exception {  
        String filepath="./";  
  
        RSAEncrypt.genKeyPair(filepath);  

        System.out.println("--------------- use private key to generate the signation ------------------");  
        String content = "{\"messengerId\":\"123456789\",\"timestamp\":\"20161220175824\",\"token\":\"1002\",\"transType\":1006}";

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
