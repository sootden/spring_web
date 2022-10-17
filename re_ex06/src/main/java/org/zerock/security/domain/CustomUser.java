package org.zerock.security.domain;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.GetMapping;
import org.zerock.domain.MemberVO;

import java.util.Collection;
import java.util.stream.Collectors;
/*
    User extends UserDetails
    CustomUser extends User

    부모클래스의 생성자 호출
    MemberVO를 파라미터로 전달 받아서 생성자 호출
        -> AuthVO의 경우 GrantedAuthority객체로 변환
            GrantedAuthority :
            stream() :
            map() :
 */
@Getter
public class CustomUser extends User {
    private static final long serialVersionUID = 1L;
    private MemberVO member;

    public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }

    public CustomUser(MemberVO vo){
        super(vo.getUserid(), vo.getUserpw(), vo.getAuthList().stream().map(auth ->
                new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));

        this.member = vo;
    }
}
