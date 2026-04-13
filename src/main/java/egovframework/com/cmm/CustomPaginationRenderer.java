package egovframework.com.cmm;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;
/**
 * ImagePaginationRenderer.java 클래스
 *
 * @author 서준식
 * @since 2011. 9. 16.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2011. 9. 16.   서준식       이미지 경로에 ContextPath추가
 *   2016. 6. 17.   장동한       표준프레임워크 v3.6 리뉴얼
 * </pre>
 */
public class CustomPaginationRenderer extends AbstractPaginationRenderer {

    /**
     * 페이지네이션 렌더링  오버라이드
     *
     * AbstractPaginationRenderer 기본 구현은 첫 페이지에서 << < 를 숨기고 마지막 페이지에서 > >> 를 숨긴다.
     * 항상 모든 버튼을 표시하도록 구현
     *
     * 버튼 구성: <<(첫 페이지) <(이전 페이지) [페이지번호...] >(다음 페이지) >>(마지막 페이지)
     *
     * href="javascript:;" 를 사용하는 이유:
     *   header.jsp 에 <base href="{contextPath}/"> 가 선언되어 있어서
     *   href="" 를 쓰면 클릭 시 컨텍스트 루트로 이동해버린다.
     *   javascript:; 는 아무것도 하지 않는 안전한 더미 href 다.
     */
    @Override
    public String renderPagination(PaginationInfo paginationInfo, String jsFunction) {

        int currentPageNo = paginationInfo.getCurrentPageNo();			//현재 페이지 번호
        int totalPageCount = paginationInfo.getTotalPageCount();		//페이지 개수 (전체 마지막 페이지 realEnd)
        int firstPageNo = paginationInfo.getFirstPageNoOnPageList(); 	//페이지 리스트의 첫 페이지 번호
        int lastPageNo = paginationInfo.getLastPageNoOnPageList(); 		//페이지 리스트의 마지막 페이지 번호

        // 게시글이 0건일 때 최소 1페이지로 처리
        if (totalPageCount < 1) totalPageCount = 1;

        // 이전/다음 페이지 번호 (최소  1, 최대 마지막 페이지)
        int prevPageNo = Math.max(1, currentPageNo - 1);
        int nextPageNo = Math.min(totalPageCount, currentPageNo + 1);

        StringBuilder sb = new StringBuilder();

        // << 첫 페이지: 1페이지에서도 항상 표시 (비활성 처리)
        String firstClass = (currentPageNo <= 1) ? "page-item disabled" : "page-item";
        sb.append("<li class=\"").append(firstClass).append("\">")
          .append("<a class=\"page-link\" href=\"javascript:;\" onclick=\"")
          .append(jsFunction).append("(1);return false;\"> [<<] </a></li>");

        // < 이전 페이지: 1페이지에서도 항상 표시 (비활성 처리)
        String prevClass = (currentPageNo <= 1) ? "page-item disabled" : "page-item";
        sb.append("<li class=\"").append(prevClass).append("\">")
          .append("<a class=\"page-link\" href=\"javascript:;\" onclick=\"")
          .append(jsFunction).append("(").append(prevPageNo).append(");return false;\"> [<] </a></li>");

        // 페이지 번호 목록
        for (int i = firstPageNo; i <= lastPageNo; i++) {
            if (i == currentPageNo) {
                // 현재 페이지: active 표시, 클릭 불필요
                sb.append("<li class=\"page-item active\">")
                  .append("<a class=\"page-link\" href=\"javascript:;\">").append(i).append("</a></li>");
            } else {
                sb.append("<li class=\"page-item\">")
                  .append("<a class=\"page-link\" href=\"javascript:;\" onclick=\"")
                  .append(jsFunction).append("(").append(i).append(");return false;\">")
                  .append(i).append("</a></li>");
            }
        }

        // > 다음 페이지: 마지막 페이지에서도 항상 표시 (비활성 처리)
        String nextClass = (currentPageNo >= totalPageCount) ? "page-item disabled" : "page-item";
        sb.append("<li class=\"").append(nextClass).append("\">")
          .append("<a class=\"page-link\" href=\"javascript:;\" onclick=\"")
          .append(jsFunction).append("(").append(nextPageNo).append(");return false;\"> [>] </a></li>");

        // >> 마지막 페이지: 항상 표시 (비활성 처리)
        String lastClass = (currentPageNo >= totalPageCount) ? "page-item disabled" : "page-item";
        sb.append("<li class=\"").append(lastClass).append("\">")
          .append("<a class=\"page-link\" href=\"javascript:;\" onclick=\"")
          .append(jsFunction).append("(").append(totalPageCount).append(");return false;\"> [>>] </a></li>");

        return sb.toString();
    }

    // 라벨 필드는 renderPagination 을 직접 구현하므로 사용되지 않음
    // (AbstractPaginationRenderer 는 생성자에서 라벨을 세팅하고 super.renderPagination 에서 사용하는데,
    //  이 클래스는 super 를 호출하지 않으므로 생성자 세팅 불필요)
    public CustomPaginationRenderer() {}

}
