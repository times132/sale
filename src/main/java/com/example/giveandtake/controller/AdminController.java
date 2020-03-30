package com.example.giveandtake.controller;

import com.example.giveandtake.common.Pagination;
import com.example.giveandtake.common.SearchCriteria;
import com.example.giveandtake.model.entity.Board;
import com.example.giveandtake.model.entity.ChatRoom;
import com.example.giveandtake.model.entity.User;
import com.example.giveandtake.model.entity.UserRoles;
import com.example.giveandtake.service.AdminService;
import com.example.giveandtake.service.BoardService;
import com.example.giveandtake.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private AdminService adminService;

    @Autowired
    private UserService userService;

    // 어드민 페이지
    @GetMapping
    public String userlist() {
        return "/admin/admin";
    }

    //회원정보보기 및 삭제
    @GetMapping("/userinfo")
    public String userinfo(SearchCriteria searchCri, Model model) {
        searchCri.setPageSize(10); // 한 화면에 유저 10개씩 표시
        Page<User> userPage = adminService.getList(searchCri);

        model.addAttribute("userList", userPage.getContent());
        model.addAttribute("pageMaker", Pagination.builder()
                .cri(searchCri)
                .total(userPage.getTotalElements())
                .realEndPage(userPage.getTotalPages())
                .listSize(5) // 페이징 5로 설정
                .build());
        return "/admin/userinfo";
    }
    //회원 탈퇴
    @GetMapping("/userinfo/delete")
    public String delete(@RequestParam("username") String username, @ModelAttribute("cri") SearchCriteria cri) {
        System.out.println("**delete**" + username);
        userService.delete(username);
        return "redirect:/admin";
    }

    @GetMapping("/userrole")
    public String role() {
        return "/admin/role";
    }
    @GetMapping(value = "/roleList", produces = "application/json")
    public ResponseEntity<List<UserRoles>> userRole() {
        List<UserRoles> userRoles = adminService.getRole("admin");
        return new ResponseEntity<>(userRoles, HttpStatus.OK);
    }

}