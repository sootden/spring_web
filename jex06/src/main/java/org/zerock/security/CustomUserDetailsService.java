package org.zerock.security;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;
import org.zerock.security.domain.CustomUser;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
    @Setter(onMethod_=@Autowired)
    private MemberMapper memberMapper;
/*
    예제는 UserDetails의 하위 클래스인 User클래스를 상속해서 CustomUser클래스를 생성하여 사용
    mapper를 이용하여 userid에 해당하는 MemberVO 정보를 가져와 MemberVO의 정보를 가진 CustomUser객체 반환
 */
    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
        log.warn("Load User By UserName : " + userName);

        //userName means userid
        MemberVO vo = memberMapper.read(userName);

        log.warn("queried by member mapper: "+vo);

        return vo == null ? null : new CustomUser(vo);
    }
}
