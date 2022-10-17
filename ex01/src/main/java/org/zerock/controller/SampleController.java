package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.SampleDTO;
import org.zerock.domain.SampleDTOList;
import org.zerock.domain.ToDoDTO;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;

@Controller
@RequestMapping("/sample/*")  // 다음 url의 모든 요청은 SampleController에 매핑
@Log4j
public class SampleController {
  @RequestMapping(value="/basic", method={RequestMethod.GET, RequestMethod.POST})
  public void basicGer(){
    log.info("basic get...........");
  }
  @GetMapping("/basicOnlyGet")
  public void basicGet2(){
    log.info("basic get only get............");
  }
//  바인딩 : 파라미더 자동 수집
  @GetMapping("/ex01")
  public String ex01(SampleDTO dto){
    log.info(""+dto);
    return "ex01";
  }
//  @RequestParam() : 파라미터로 사용되는 변수명과 전달되는 파라미터명이 다를 경우 주로 사용
  @GetMapping("/ex02")
  public String ex02(@RequestParam("name") String name, @RequestParam("age") int age){
    log.info("name: "+name);
    log.info("age: "+age);
    return "ex02";
  }
//  리스트 처리 : 동일한 명의 파라미터를 여러개 전달 되는 경우
  @GetMapping("/ex02List")
  public String ex02List(@RequestParam("ids") ArrayList<String> ids){
    log.info("ids: "+ids);
    return "ex02List";
  }
//  배열 처리
  @GetMapping("/ex02Array")
  public String ex02Array(@RequestParam("ids") String[] ids){
    log.info("array ids: "+ Arrays.toString(ids));
    return "ex02Array";
  }
//  참조형객체 리스트 전달 : 해당 객체 리스트를 포함하는 클래스 사용
  @GetMapping("/ex02Bean")
  public String ex02Bean(SampleDTOList list){
    log.info("list dto: "+ list);
    return "ex02Bean";
  }

//  Date객체와 같이 자동 변환이 어려운 경우
  // 1) @InitBinder 어노테이션 사용 : 바인딩할때 자동으로 호출됨
//  @InitBinder
//  public void initBinder(WebDataBinder binder){
//    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//    binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, false));
//  }
  @GetMapping("/ex03")
  public String ex03(ToDoDTO todo){
    log.info("todo: " + todo);
    return "ex03";
  }
  //2) @DateTimeFormat : @InitBinder 없이 사용 가능 -> ToDoDTO의 Date타입 변수에 적용


  //@ModelAttribute : 파라미터로 수집한 (바인딩한) 참조형 객체의 경우 View까지 전달이 되어 jsp에서 사용가능한 반면,
  // 기본타입은 불가능. 해당 어노테이션 사용시, 기본타입도 jsp로 전달되어 사용가능해짐
  @GetMapping("/ex04")
  public String ex04(SampleDTO dto, @ModelAttribute("page") int page){
    log.info("dto: " + dto);
    log.info("page: " + page);
    return "sample/ex04";
  }

  //리턴값이 없는 void타입 메서드일 경우 요청url의 경로대로 jsp파일명이 정해짐
  @GetMapping("/ex05")
  public void ex05(){
    log.info("/ex05....");
  }

  //@ResponseBody 란...? : pom.xml에 jackson-databind라이브러리 추가한 후,
  // 다음 메서드 실행시, dto,vo타입을 JSON타입으로 변환해서 전달해줌
  @GetMapping("/ex06")
  public @ResponseBody SampleDTO ex06(){
    log.info("/ex06.......");
    SampleDTO dto = new SampleDTO();
    dto.setAge(10);
    dto.setName("홍길동");
    return dto;
  }

  //@ResponseEntity : HttpHeader객체 전달과 헤더메세지 가공 가능
  @GetMapping("/ex07")
  public ResponseEntity<String> ex07(){
    log.info("/ex07...");

    //{"name" : "홍길동"}
    String msg = "{\"name\": \"홍길동\"}";

    HttpHeaders header = new HttpHeaders();
    header.add("Content-Type", "application/json;charset=UTF-8");

    return new ResponseEntity<>(msg, header, HttpStatus.OK);
  }

  @GetMapping("/exUpload")
  public void exUpload(){
    log.info("/exUpload...");
  }

  @PostMapping("/exUploadPost")
  public void exUploadPost(ArrayList<MultipartFile> files){
    files.forEach(file -> {
      log.info("------------");
      log.info("name:"+file.getOriginalFilename());
      log.info("size:"+file.getSize());
    });
  }
}
