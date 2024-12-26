package me.ko.springbootdeveloper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TestController {

    @Autowired
    Testservice testservice;

    @GetMapping("/test")
    public List<Member> getAllMembers(){
        List<Member> members = testservice.getAllMembers();
        return  members;
    }
}
