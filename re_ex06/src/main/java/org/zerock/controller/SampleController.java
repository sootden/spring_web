package org.zerock.controller;

import lombok.Getter;
import lombok.extern.log4j.Log4j;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Log4j
@RequestMapping("/sample/*")
@Controller
public class SampleController {

    //로그인을 하지 않은 사용자도 접근 가능한 url
    @GetMapping("/all")
    public void doAll(){
        log.info("do all can access everybody");
    }
    //로그인 한 사용자들만 접근할 수 있는 url
    @GetMapping("/member")
    public void doMamber(){
        log.info("logined member");
    }
    //로그인 한 사용자들 중에서 관리자 둰한을 가진 사용자만이 접근할 수 있는 url
    @GetMapping("/admin")
    public void doAdmin(){
        log.info("admin only");
    }

    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
    @GetMapping("/annoMember")
    public void doMember2(){
        log.info("logined annotation memeber");
    }

    @Secured("{ROLE_ADMIN}")
    @GetMapping("/annoAdmin")
    public void doAdmin2(){
        log.info("admin annotation only");
    }
}
