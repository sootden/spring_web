package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

//Controller가 REST(Representational State Test)방식으로 처리하기 위함 명시
@RestController
@RequestMapping("/sample")
@Log4j
//@GetMapping의 produces속성은 해당 메서드가 생산하는 MIME타입을 의미함. 메서드 내의 MediaType클래스로도 이용가능
public class SampleController {
    @GetMapping(value="/getText", produces = "text/plain; charset=UTF-8")
    public String getText(){
        log.info("MIME TYPE: "+ MediaType.TEXT_PLAIN_VALUE);

        return "안녕하세요";
    }

    @GetMapping(value = "/getSample", produces = { MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE })
    public SampleVO getSample(){
        return new SampleVO(112,"스타","로드");
    }

    @GetMapping(value="/getList")
    public List<SampleVO> getList(){
        // 1부터 10미만까지 루프 처리하여 SampleVO객체를 생성하여 List<SampleVO> 생성
        return IntStream.range(1,10).mapToObj(i -> new SampleVO(i,i+"First",i+"Last")).collect(Collectors.toList());
    }

    @GetMapping(value = "/getMap")
    public Map<String, SampleVO> getMap(){
        Map<String, SampleVO> map = new HashMap<String, SampleVO>();
        map.put("First", new SampleVO(111,"그루트","주니어"));
        return map;
    }

    /*
        ResponseEntity : 데이터와 함께 HTTP헤더의 상태 메세지 등을 같이 전달하는 용도로 사용
                           -> 데이터를 요청한 쪽에서 정상적인 데이터인지 확인하기 위함
        check()는 반드시 height, weight를 파라미터로 전달받고
            만일 height가 150보다 작을 경우 502(bad gateway)상태코드와 데이터를 전송
            그렇지 않으면 200(ok)상태코드와 데이터를 전송함
     */
    @GetMapping(value="/check", params = {"height","weight"})
    public ResponseEntity<SampleVO> check(Double height, Double weight){
        SampleVO vo = new SampleVO(0, ""+height,""+weight);

        ResponseEntity<SampleVO> result = null;

        if(height < 150){
            result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);
        }else {
            result = ResponseEntity.status(HttpStatus.OK).body(vo);
        }
        return result;
    }

    //@PathVariable : URL경로 일부 {} 를 파라미터로 사용할때
    @GetMapping("/product/{cat}/{pid}")
    public String[] getPath(@PathVariable("cat") String cat, @PathVariable("pid") Integer pid){
        return new String[] {"category: "+cat, "productid: "+pid};
    }

    //@RequestBody : 전달된 request의 body를 이용해서 해당 파라미터의 타입으로 변환을 요구
    //body를 처리하기 때문에 GET방식이 아닌 POST방식으로 전달해야함
    @PostMapping("/ticket")
    public Ticket convert(@RequestBody Ticket ticket){
        log.info("convert.....ticket"+ticket);

        return ticket;
    }
}
