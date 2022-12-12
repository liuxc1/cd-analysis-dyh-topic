package ths.project.common.util;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

public class RSAUtils {
    /**
     * 加密算法RSA
     */
    public static final String KEY_ALGORITHM = "RSA";
    /**
     * 签名算法
     */
    public static final String SIGNATURE_ALGORITHM = "MD5withRSA";
    /**
     * 获取公钥的key
     */
    private static final String PUBLIC_KEY = "RSAPublicKey";
    /**
     * 获取私钥的key
     */
    private static final String PRIVATE_KEY = "RSAPrivateKey";
    /**
     * RSA最大加密明文大小
     */
    private static final int MAX_ENCRYPT_BLOCK = 117;
    /**
     * RSA最大解密密文大小
     */
    private static final int MAX_DECRYPT_BLOCK = 128;

    private static final Logger LOGGER = LoggerFactory.getLogger(RSAUtils.class);

    /**
     * <p>
     * 生成密钥对(公钥和私钥)
     * </p>
     *
     * @return 密钥对
     */
    public static Map<String, Object> genKeyPair() {
        try {
            KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance(KEY_ALGORITHM);
            keyPairGen.initialize(1024);
            KeyPair keyPair = keyPairGen.generateKeyPair();
            RSAPublicKey publicKey = (RSAPublicKey) keyPair.getPublic();
            RSAPrivateKey privateKey = (RSAPrivateKey) keyPair.getPrivate();
            Map<String, Object> keyMap = new HashMap<>(2);
            keyMap.put(PUBLIC_KEY, publicKey);
            keyMap.put(PRIVATE_KEY, privateKey);
            return keyMap;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * <p>
     * 用私钥对信息生成数字签名
     * </p>
     *
     * @param data       已加密数据
     * @param privateKey 私钥(BASE64编码)
     * @return 数字签名
     */
    public static String sign(byte[] data, String privateKey) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(privateKey);
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        PrivateKey privateK = keyFactory.generatePrivate(pkcs8KeySpec);
        Signature signature = Signature.getInstance(SIGNATURE_ALGORITHM);
        signature.initSign(privateK);
        signature.update(data);
        return Base64.getEncoder().encodeToString(signature.sign());
    }

    /**
     * <p>
     * 校验数字签名
     * </p>
     *
     * @param data      已加密数据
     * @param publicKey 公钥(BASE64编码)
     * @param sign      数字签名
     * @return 结果
     */
    public static boolean verify(byte[] data, String publicKey, String sign) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(publicKey);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        PublicKey publicK = keyFactory.generatePublic(keySpec);
        Signature signature = Signature.getInstance(SIGNATURE_ALGORITHM);
        signature.initVerify(publicK);
        signature.update(data);
        return signature.verify(Base64.getDecoder().decode(sign));
    }

    /**
     * <P>
     * 私钥解密
     * </p>
     *
     * @param encryptedData 已加密数据
     * @param privateKey    私钥(BASE64编码)
     * @return 解密字节
     */
    public static byte[] decryptByPrivateKey(byte[] encryptedData, String privateKey) throws NoSuchPaddingException, NoSuchAlgorithmException, IllegalBlockSizeException, IOException, BadPaddingException, InvalidKeyException, InvalidKeySpecException {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            byte[] keyBytes = Base64.getDecoder().decode(privateKey);
            PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);

            Key privateK = keyFactory.generatePrivate(pkcs8KeySpec);
            Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
            cipher.init(Cipher.DECRYPT_MODE, privateK);
            int inputLen = encryptedData.length;

            int offSet = 0;
            byte[] cache;
            int i = 0;
            // 对数据分段解密
            while (inputLen - offSet > 0) {
                if (inputLen - offSet > MAX_DECRYPT_BLOCK) {
                    cache = cipher.doFinal(encryptedData, offSet, MAX_DECRYPT_BLOCK);
                } else {
                    cache = cipher.doFinal(encryptedData, offSet, inputLen - offSet);
                }
                out.write(cache, 0, cache.length);
                i++;
                offSet = i * MAX_DECRYPT_BLOCK;
            }
            byte[] decryptedData = out.toByteArray();
            return decryptedData;
        } catch (Exception e) {
            throw e;

        }
    }

    /**
     * <p>
     * 公钥加密
     * </p>
     *
     * @param data      源数据
     * @param publicKey 公钥(BASE64编码)
     */
    public static byte[] encryptByPublicKey(byte[] data, String publicKey) throws NoSuchPaddingException, NoSuchAlgorithmException, IllegalBlockSizeException, IOException, BadPaddingException, InvalidKeyException, InvalidKeySpecException {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            byte[] keyBytes = Base64.getDecoder().decode(publicKey);
            X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(keyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
            Key publicK = keyFactory.generatePublic(x509KeySpec);
            // 对数据加密
            Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
            cipher.init(Cipher.ENCRYPT_MODE, publicK);
            int inputLen = data.length;
            int offSet = 0;
            byte[] cache;
            int i = 0;
            // 对数据分段加密
            while (inputLen - offSet > 0) {
                if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {
                    cache = cipher.doFinal(data, offSet, MAX_ENCRYPT_BLOCK);
                } else {
                    cache = cipher.doFinal(data, offSet, inputLen - offSet);
                }
                out.write(cache, 0, cache.length);
                i++;
                offSet = i * MAX_ENCRYPT_BLOCK;
            }
            byte[] encryptedData = out.toByteArray();
            return encryptedData;
        } catch (Exception e) {
            throw e;
        }
    }


    /**
     * <p>
     * 获取私钥
     * </p>
     *
     * @return 私钥
     */
    public static String getPrivateKey() {
        return "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOSf1g0rESgpnmo7mmTx4C+SZfVClMatqnSNuppEVU4TiO4RRNk2SXJDnldaXW5CmXX6iVbtuK1OPWSlFduYf4F0/B9QUwGAA1PEnuaXiTAem35GzqXIBelm83ExSc3V8ycfOWfKXWATVn4Lt1SCPfD9aMxBBXENX+YH/DsLdsPrAgMBAAECgYEAkf1C2UvL++J/pwSCdb1CU/5fHvsyN6BD/YNXShUih+XPhX3/gdi5k758CPnKOZNLnVurgZfxWrFgYLlOONiradFI8fuJmFmhG2Eqvvw1i0+Nw/PMjmE27Gehbs5Htuahjngd1Q1JP1MJ4X/O5OUioChv/dzQIxaFZmtn6PXBcxkCQQDzh7h6u+8rhjqvV1fOg7enVWxyo9mFSwSEXp3veCqJnfIUaZraP5fR3YVsCemyq4P5QWoZw/S1F3Pily1kREb/AkEA8FS5nBjLVpP1QLksEl6uW62skRnSTL36wDQYzj+9piruLqaWdQkraH/NBBItC4L0HWk1h4Kr6h7z/EjxQkwPFQJAI+ZE9qrPpg3ihsiMZCAcqak5FGk8/p5BazX7eDqxopnK/uFWd4faXJCYQ4Xukm0gRlUzS9sMLsnnRmbcxSQfhwJAJnfJRd0KHw+LwBJjpYUWL4J7DratXK9EBaPRHKJDPue8PCdaCd2v3wglzrMCFsedP1/pu4kE73KI5ybdxxjZiQJAefNyFE9ke+bDIsKQG3NCeuVJeh/EE8xR8wVKW/sHNEkEG32bXO6Wq2LDmYtnu+d+b+CgSbcyE/HJlRCbA0VEfw==";
    }

    /**
     * <p>
     * 获取公钥
     * </p>
     *
     * @return 公钥
     */
    public static String getPublicKey() {
        return "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDkn9YNKxEoKZ5qO5pk8eAvkmX1QpTGrap0jbqaRFVOE4juEUTZNklyQ55XWl1uQpl1+olW7bitTj1kpRXbmH+BdPwfUFMBgANTxJ7ml4kwHpt+Rs6lyAXpZvNxMUnN1fMnHzlnyl1gE1Z+C7dUgj3w/WjMQQVxDV/mB/w7C3bD6wIDAQAB";
    }

    /**
     * 私钥解密
     *
     * @param data 已加密数据
     * @return 解密结果
     */
    public static String decryptByPrivateKey(String data) {
        if (null != data && (data.endsWith("=") || (data.length() >= 30 && data.substring(data.length() - 20).matches("[a-zA-Z0-9_+=/]{20}")))) {
            try {

                byte[] bytes = decryptByPrivateKey(Base64.getDecoder().decode(data), getPrivateKey());
                if (bytes.length > 0) {
                    String decrypt = new String(bytes, StandardCharsets.UTF_8);
                    return decrypt;
                }
            } catch (Exception e) {
                LOGGER.error("解密失败：" + data, e);
            }
        }
        return data;
    }

    /**
     * 加密
     * 用公钥加密，加密字符串，返回用base64加密后的字符串
     *
     * @param data 源数据
     * @return 加密后的数据
     */
    public static String encryptByPublicKey(String data) {
        if (StringUtils.isNotBlank(data)) {
            try {
                byte[] res = RSAUtils.encryptByPublicKey(data.getBytes(StandardCharsets.UTF_8), getPublicKey());
                if (res.length > 0) {
                    return Base64.getEncoder().encodeToString(res);
                }
            } catch (Exception e) {
                LOGGER.error("加密失败：" + data, e);
            }
        }
        return data;
    }
}
