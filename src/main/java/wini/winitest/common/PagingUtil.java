package wini.winitest.common;

import java.util.Map;


/**
 * 페이지네이션 계산 유틸리티
 */
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public class PagingUtil {

    public static PaginationInfo create(Map<String, Object> param, int recordPerPage, int pageSize) {
        PaginationInfo paginationInfo = new PaginationInfo();

        int currentPageNo = parsePageNo(param.get("currentPageNo")); // 현재 페이지 없으면 1 고정

        paginationInfo.setCurrentPageNo(currentPageNo);
        paginationInfo.setRecordCountPerPage(recordPerPage); // 한 페이지당 게시되는 게시물 건 수
        paginationInfo.setPageSize(pageSize); // 페이지 리스트에 게시되는 페이지 건수

        param.put("firstIndex", paginationInfo.getFirstRecordIndex());
        param.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());

        return paginationInfo;
    }
    
    public static PaginationInfo create(int currentPageNo, int recordPerPage, int pageSize) {
      PaginationInfo paginationInfo = new PaginationInfo();

      currentPageNo = currentPageNo < 1 ? 1 : currentPageNo;; // 현재 페이지 없으면 1 고정

      paginationInfo.setCurrentPageNo(currentPageNo);
      paginationInfo.setRecordCountPerPage(recordPerPage); // 한 페이지당 게시되는 게시물 건 수
      paginationInfo.setPageSize(pageSize); // 페이지 리스트에 게시되는 페이지 건수

      return paginationInfo;
  }

    private static int parsePageNo(Object value) {
    	int page = 1;

    	try {
    	    page = Integer.parseInt(String.valueOf(value)); // null방어, 어떤 타입이든 문자열 치환가능
    	} catch (Exception e) {
    	    return 1;
    	}

    	return page < 1 ? 1 : page;
    }
}