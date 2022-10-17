package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
    @RequestMapping("/")
    public String root(Model model){
        model.addAttribute("serverTime", new java.util.Date());
        return "home";
    }
}
