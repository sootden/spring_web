package org.zerock.controller;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
    //@AllArgsConstructor로 BoardService 의존 오브젝트 자동 주입
    private BoardService service;

    //전체 목록
//    @GetMapping("/list")
//    public void list(Model model){
//        log.info("list");
//        model.addAttribute("list", service.getList());
//    }
    @GetMapping("/list")
    public void list(Criteria cri, Model model){
        log.info("list: " + cri);
        model.addAttribute("list", service.getList(cri));
//        model.addAttribute("pageMaker",new PageDTO(cri, 123));
        int total = service.getTotal(cri);
        log.info("total: "+ total);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }

    //등록 처리
    @PostMapping("/register")
    public String register(BoardVO board, RedirectAttributes rttr){
        log.info("register : "+board);
        service.register(board);
        //RedirectAttributes : 추가적으로 새롭게 등록된 게시물의 번호를 전달하기 위해 사용
        //addFlashAttribute() : 로 보관된 데이터는 일회성으로 사용가능, 단 한번만 데이터를 전달할때 유용 (내부적으로 HttpSession 이용하여 처리)
        rttr.addFlashAttribute("result", board.getBno());
        return "redirect:/board/list";
    }
    //입력페이지를 보여주는 역할(GET방식)
    @GetMapping("/register")
    public void register(){

    }
    //조회
    //@ModelAttribute: 자동으로 Model에 데이터를 지정한 이름을 담아줌 . 좀더 명시적으로 Criteria객체가 화면에 전달되는 이름을 지정하기 위함
    @GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno,@ModelAttribute("cri") Criteria cri, Model model){
        log.info("get or modify");
        model.addAttribute("board", service.get(bno));
    }
    //수정 처리
    @PostMapping("/modify")
    public String modify(BoardVO board, @ModelAttribute("cri")Criteria cri, RedirectAttributes rttr){
        log.info("modify: "+board);
        if(service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
//        rttr.addAttribute("pageNum",cri.getPageNum());
//        rttr.addAttribute("amount",cri.getAmount());
//        rttr.addAttribute("type",cri.getType());
//        rttr.addAttribute("keyword",cri.getKeyword());

        return "redirect:/board/list"+cri.getListLink();
    }
    //삭제 처리
    @PostMapping("/remove")
    public String delete(@RequestParam("bno")Long bno, @ModelAttribute("cri")Criteria cri, RedirectAttributes rttr){
        log.info("remove: "+bno);
        if(service.remove(bno)){
            rttr.addFlashAttribute("result","success");
        }
//        rttr.addAttribute("pageNum",cri.getPageNum());
//        rttr.addAttribute("amount",cri.getAmount());
//        rttr.addAttribute("type",cri.getType());
//        rttr.addAttribute("keyword",cri.getKeyword());

        return "redirect:/board/list"+cri.getListLink();
    }
}
