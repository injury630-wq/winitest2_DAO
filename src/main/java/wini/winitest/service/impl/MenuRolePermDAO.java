package wini.winitest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * MenuRolePermDAO - EgovComAbstractDAO 상속
 * SQL ID: menuRolePermDAO.{queryId} (MenuRolePermMapper.xml namespace="menuRolePermDAO")
 */
@Repository("menuRolePermDAO")
public class MenuRolePermDAO extends EgovComAbstractDAO {

		/** 신규 롤 등록 시 전체 메뉴에 대한 기본 권한(전부 N) 등록 트랜잭션테스트 */
		public int insertDefaultMenuRolePermTest(Map<String, Object> param) throws Exception {
			return insert("menuRolePermDAO.insertDefaultMenuRolePerm", param);
		}
    /** 신규 롤 등록 시 전체 메뉴에 대한 기본 권한(전부 N) 등록 */
    public void insertDefaultMenuRolePerm(Map<String, Object> param) throws Exception {
        insert("menuRolePermDAO.insertDefaultMenuRolePerm", param);
    }

    /** 롤별 메뉴 권한 목록 조회 */
    public List<Map<String, Object>> selectMenuPermList(Map<String, Object> param) throws Exception {
        return selectList("menuRolePermDAO.selectMenuPermList", param);
    }

    /** 메뉴별 권한 수정 */
    public void updateMenuPerm(Map<String, Object> param) throws Exception {
        update("menuRolePermDAO.updateMenuPerm", param);
    }

    /** 세션 저장용 - 롤별 메뉴 권한 목록 (proPath 기준) */
    public List<Map<String, Object>> selectMenuPermByRole(Map<String, Object> param) throws Exception {
        return selectList("menuRolePermDAO.selectMenuPermByRole", param);
    }

}
