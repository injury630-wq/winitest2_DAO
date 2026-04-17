package wini.winitest.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import wini.winitest.common.PagingUtil;
import wini.winitest.service.UserService;

/**
 * 사용자 서비스 구현체
 * - EgovAbstractServiceImpl 상속
 * - UserDAO를 통한 DB 접근 (Map 기반)
 */
@Service("userService")
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

    @Resource(name = "userDAO")
    private UserDAO userDAO;
    
    /** 사용자 정보 목록 조회(페이징,검색조건) 예외처리 언제해야하는지 모르겠음.*/
    @Override
    public Map<String, Object> getUserList(Map<String, Object> params) throws Exception{// params => 검색조건, 현페이지번호
    	Map<String, Object> result = new HashMap<>();
    	result.put("message", "error");
    	try {
    		PaginationInfo paginationInfo = PagingUtil.create(params, 10, 10);
    		
    		int totalCount = selectUserTotalCount(params); // 검색 조건 전체 건수 계산
    		paginationInfo.setTotalRecordCount(totalCount);
    		
    		List<Map<String, Object>> userList = userDAO.selectUserList(params);
    		
    		
    		result.put("list", userList);
    		result.put("paginationInfo", paginationInfo);
    		result.put("search", params); // 검색조건 따로 보관
    		result.put("message", "success");
				
			} catch (Exception e) {
				e.printStackTrace();
			}
    	return result;
    }
    
  /** 사용자 정보 목록 전체 건수 (검색조건)*/
  @Override
	public int selectUserTotalCount(Map<String, Object> params) throws Exception {
		return userDAO.selectUserTotalCount(params);
	}
  
  /** 사용자 상세 조회*/
  @Override
	public Map<String, Object> selectUserDetail(int userNo) throws Exception {
    Map<String, Object> user = userDAO.selectUserDetail(userNo);

		return user;
	}

  /** 로그인 정보 단건 조회 */
  @Override
  public Map<String, Object> selectLoginInfo(Map<String, Object> param) throws Exception {
      return userDAO.selectLoginInfo(param);
  }

  /** 아이디 중복확인 (0: 사용가능, 1이상: 중복) */
  @Override
  public int idCheck(Map<String, Object> param) throws Exception {
      return userDAO.idCheck(param);
  }

  /** 회원가입 처리 - INSERT 후 reg_user 를 자기 자신(userNo)으로 UPDATE */
  @Override
  public int register(Map<String, Object> param) throws Exception {
      int result = userDAO.register(param);
      // useGeneratedKeys 로 param 에 userNo 가 채워진 후 자기 자신을 등록자로 세팅
      if (result > 0) {
          userDAO.updateRegUser(param);
      }
      return result;
  }


}
