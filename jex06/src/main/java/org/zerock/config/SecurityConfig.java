package org.zerock.config;


import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.zerock.security.CustomLoginSuccessHandler;
import org.zerock.security.CustomUserDetailsService;

import javax.sql.DataSource;

@Configuration
@EnableWebSecurity //스프링 mvc와 스프링 시큐리티를 결합하는 용도로 사용
@Log4j
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Setter(onMethod_={@Autowired})
    private DataSource dataSource;
    /*
        <security:http auto-config="true" use-expressions="true">
            <security:intercept-url pattern="/sample/all" access="permitAll"/>
            <security:intercept-url pattern="/sample/member" access="hasRole('ROLE_MEMBER')"/>
            <security:intercept-url pattern="/sample/admin" access="hasRole('ROLE_ADMIN')"/>

     */
    @Override
    public void configure(HttpSecurity http) throws Exception{
        http.authorizeRequests()
                .antMatchers("/sample/all").permitAll()
                .antMatchers("/sample/admin").access("hasRole('ROLE_ADMIN')")
                .antMatchers("/sample/member").access("hasRole('ROLE_MEMBER')");

        http.formLogin()
                .loginPage("/customLogin")
                .loginProcessingUrl("/login");
//                .successHandler(loginSuccessHandler());

        http.logout()
                .logoutUrl("/customLogout")
                .invalidateHttpSession(true)
                .deleteCookies("remember-me", "JSESSION_ID");
        //xml과 달리 DataSource를 직접 추가하는 방식이 아니라 PersistentTokenRepository를 이용함
        http.rememberMe()
                .key("zerock")
                .tokenRepository(persistentTokenRepository())
                .tokenValiditySeconds(604800);
    }
    //기본
//    @Override
//    protected void configure(AuthenticationManagerBuilder auth) throws Exception{
//        log.info("configure.........");
//        auth.inMemoryAuthentication().withUser("admin").password("{noop}admin").roles("ADMIN");
//        auth.inMemoryAuthentication()
//                .withUser("member")
//                .password("$2a$10$awa3dli7r7C0ebnxTTCLleQMgbAfPoT2fiP/4QAD8xDdT1YO/OUbu")
//                .roles("MEMBER");
//    }

    //jdbc 이용
//    @Override
//    protected void configure(AuthenticationManagerBuilder auth) throws Exception{
//        log.info("configure JDBC.........");
//
//        String queryUser = "select userid, userpw, enabled from tbl_member where userid = ?";
//        String queryDetails = "select userid, auth from tbl_member_auth where userid = ?";
//
//        auth.jdbcAuthentication()
//                .dataSource(dataSource)
//                .passwordEncoder(passwordEncoder())
//                .usersByUsernameQuery(queryUser)
//                .authoritiesByUsernameQuery(queryDetails);
//    }

    @Bean
    public AuthenticationSuccessHandler loginSuccessHandler(){
        return new CustomLoginSuccessHandler();
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService customUserService(){
        return new CustomUserDetailsService();
    }
    //MyBatis Mapper 사용
    //in custom userdetails
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception{
        auth.userDetailsService(customUserService()).passwordEncoder(passwordEncoder());
    }

    @Bean
    public PersistentTokenRepository persistentTokenRepository(){
        JdbcTokenRepositoryImpl repo = new JdbcTokenRepositoryImpl();
        repo.setDataSource(dataSource);
        return repo;
    }
}
