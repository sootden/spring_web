package org.zerock.controller;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyServiceImpl;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
    private ReplyServiceImpl service;

    // 댓글 등록 : POST방식으로만 동작하도록 설계, consumes와 produces속성을 이용해 JSON방식의 데이터만 처리하도록, 문자열 반환
    @PostMapping(value="/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> create(@RequestBody ReplyVO vo){
        log.info("ReplyVO: "+vo);

        int insertCount = service.register(vo);

        log.info("Reply INSERT COUNT: "+insertCount);

        return insertCount == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    // 특정 게시물의 댓글 목록 가져오기
    @GetMapping(value = "/pages/{bno}/{page}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno){
        log.info("getList...");
        Criteria cri = new Criteria(page, 10);
        log.info(cri);

        return new ResponseEntity<>(service.getListPage(cri,bno), HttpStatus.OK);
    }
    // 댓글 조회
    @GetMapping (value = "/{rno}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
        log.info("get: "+rno);
        return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
    }
    // 댓글 삭제
    @DeleteMapping(value = "/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
        log.info("remove: "+rno);

        return service.remove(rno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK): new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    // 댓글 수정
    @RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH}, value = "/{rno}", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
        vo.setRno(rno);
        log.info("rno: "+rno);
        log.info("modify: "+vo);
        return service.modify(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
