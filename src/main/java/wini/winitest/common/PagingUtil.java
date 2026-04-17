package wini.winitest.common;

import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public class PagingUtil {

//    public static PaginationInfo create(Map<String, Object> param) {
//        PaginationInfo paginationInfo = new PaginationInfo();
//
//        String cpnStr = (String) param.get("currentPageNo");
//        int currentPageNo = (cpnStr != null && !cpnStr.isEmpty()) ? Integer.parseInt(cpnStr) : 1;
//
//        paginationInfo.setCurrentPageNo(currentPageNo);
//        paginationInfo.setRecordCountPerPage(10);
//        paginationInfo.setPageSize(10);
//
//        param.put("firstIndex", paginationInfo.getFirstRecordIndex());
//        param.put("recordCountPerPage", paginationInfo.getRecordCountPerPage());
//
//        return paginationInfo;
//    }
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

    public static int parsePageNo(Object value) {
    	int page = 1;

    	try {
    	    page = Integer.parseInt(String.valueOf(value)); // null방어, 어떤 타입이든 문자열 치환가능
    	} catch (Exception e) {
    	    return 1;
    	}

    	return page < 1 ? 1 : page;
    }
}