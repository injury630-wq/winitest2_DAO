package wini.winitest.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class GalleryController {
	//다오 빈 주입
	
	// 이미지 게시글 목록 이동
	@RequestMapping(value = "/gallery/list.do", method = RequestMethod.POST)
	public String list(@RequestParam Map<String, Object> param, Model model) throws Exception{
		return "gallery/list";
	}
	
	// 이미지 게시글 작성/수정폼 이동
	@RequestMapping(value = "/gallery/form.do", method = RequestMethod.POST)
	public String form(@RequestParam Map<String, Object> param, Model model) throws Exception{
		return "gallery/form";
	}
	
	//이미지 게시글 작성/수정 처리
	@RequestMapping(value = "/gallery/save.do", method = RequestMethod.POST)
	public String save(@RequestParam Map<String, Object> param, Model model) throws Exception{
		
		return "gallery/list";
	}
}
