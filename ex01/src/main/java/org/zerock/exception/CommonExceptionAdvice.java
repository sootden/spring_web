package org.zerock.exception;

import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

/*
    Controller의 Exception처리
    1) @ExceptionHandler와 @ControllerAdvice 를 이용한 처리
        @ControllerAdvice : 해당 객체가 스프링의 컨트롤러에서 발생하는 예외를 처리하는 존재임을 명시
        @ExceptionHandler : 해당 메서드가 ()들어가는 예외타입을 처리함
    2) @ResponseEntity를 이용하는 예외 메세지 구성
 */
@ControllerAdvice
@Log4j
public class CommonExceptionAdvice {
    @ExceptionHandler(Exception.class)
    public String except(Exception ex, Model model){
        log.error("Exception...."+ex.getMessage());
        model.addAttribute("exception", ex);
        log.error(model);
        return "error_page";
    }
    //404에러페이지 : 404 에러 처리
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex){
        return "custom404";
    }
}
