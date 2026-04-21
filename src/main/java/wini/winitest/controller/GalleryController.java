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
	@RequestMapping(name = "/gallery/list.do", method = RequestMethod.POST)
	public String list(@RequestParam Map<String, Object> param, Model model) throws Exception{
		return "gallery/list";
	}
	
	// 이미지 게시글 작성폼 이동
	@RequestMapping(name = "/gallery/write.do", method = RequestMethod.POST)
	public String wirteP() throws Exception{
		return "gallery/write";
	}
}
