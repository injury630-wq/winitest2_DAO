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
    public static PaginationInfo create(Map<String, Object> param) {
        PaginationInfo paginationInfo = new PaginationInfo();

        int currentPageNo = parsePageNo(param.get("currentPageNo"));

        paginationInfo.setCurrentPageNo(currentPageNo);
        paginationInfo.setRecordCountPerPage(10);
        paginationInfo.setPageSize(10);

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