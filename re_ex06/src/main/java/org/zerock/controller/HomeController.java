package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Log4j
@Controller
public class HomeController {
    @RequestMapping("/")
    public String root(){
        return "redirect:/sample/all";
    }
}
