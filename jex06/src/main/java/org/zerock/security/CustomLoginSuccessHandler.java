package org.zerock.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
    @Override
    public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
        log.warn("Login Success");
        List<String> roleNames = new ArrayList<>();
        //로그인한 사용자의 모든 권한 roleNames리스트에 추가
        authentication.getAuthorities().forEach(authority -> {
            roleNames.add(authority.getAuthority());
        });
        //'ROLE_ADMIN'권한을 가졌다면 로그인 후 바로 '/sample/admin'으로 이동
        log.warn("ROLE NAMES : "+roleNames);
        if(roleNames.contains("ROLE_ADMIN")){
            httpServletResponse.sendRedirect("/sample/admin");
            return;
        }
        if(roleNames.contains("ROLE_MEMBER")){
            httpServletResponse.sendRedirect("/sample/member");
            return;
        }
        httpServletResponse.sendRedirect("/");
    }
}
