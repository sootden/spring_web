package org.zerock.aop;

import lombok.extern.log4j.Log4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Aspect
@Log4j
@Component
public class LogAdvice {
    //@Before : BeforeAdvice 구현 메서드 명시 -> BeforeAdvice : Target이 JoinPoint를 호출하기 전에 실행되는 코드
    //그외의 어노테이션 : @After, @AfterReturning, @AfterThrowing, @Around
    // execution 문자열은 AspectJ의 표현식(expression)으로 Access Modifier와 특정 클래스의 메서드 지정 가능
    //  @Before("execution(* org.zerock.service.SampleService*.*(..))")은 Pointcut이다.
    //  맨앞의 * 는 Access Modifier를 의미 , 맨뒤 *는 클래스의 이름과 메서드의 이름을 뜻함

    @Before("execution(* org.zerock.service.SampleService*.*(..))")
    public void logBefore(){
        log.info("======================");
    }

    //&& args(str1, str2) : 변수명 지정. 이 정보로 logBeforeWithParam()메서드의 파라미터 설정함
    @Before("execution(* org.zerock.service.SampleService*.doAdd(String,String)) && args(str1, str2)")
    public void logBeforeWithParam(String str1, String str2){
        log.info("str1: "+str1);
        log.info("str1: "+str2);
    }

    //@AfterThrowing : 예외가 발생한 뒤에 실행. pointcut, throwing속성 지정
    @AfterThrowing(pointcut="execution(* org.zerock.service.SampleService*.*(..))", throwing="exception")
    public void logException(Exception exception){
        log.info("Exception...!!");
        log.info("exception: "+exception);
    }
    //@Around : Around Advice는 메서드 실행자체를 제어할 수 있고 직접 대상메서드(joinpoint)를 호출하고 결과나 예외를 처리할 수 있음
    //ProceedingJoinPoint : Target이나 파라미터 등을 파악 할 뿐만아니라, 직접 실행을 결정할 수 있음
    //리턴타입이 반드시 있어야하고 메서드 실행결과를 직접 반환해야함
    @Around("execution(* org.zerock.service.SampleService*.*(..))")
    public Object logTime(ProceedingJoinPoint pjp){
        long start = System.currentTimeMillis();

        log.info("Target: "+pjp.getTarget());
        log.info("Param: "+ Arrays.toString(pjp.getArgs()));

        //invoke method
        Object result = null;

        try{
            result = pjp.proceed();
        }catch(Throwable e){
            //TODO Auto-generated catch block
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();

        log.info("TIME: " + (end - start));
        return result;
    }
}
