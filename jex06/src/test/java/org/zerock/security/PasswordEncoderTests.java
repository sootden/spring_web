package org.zerock.security;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {
        org.zerock.config.RootConfig.class,
        org.zerock.config.SecurityConfig.class
})
@Log4j
public class PasswordEncoderTests {
    @Setter(onMethod_=@Autowired)
    private PasswordEncoder pwEncoder;

    @Test
    public void testEncode(){
        String str = "member";

        String enStr = pwEncoder.encode(str);
        //$2a$10$awa3dli7r7C0ebnxTTCLleQMgbAfPoT2fiP/4QAD8xDdT1YO/OUbu
        log.info(enStr);
    }
}
