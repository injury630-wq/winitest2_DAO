package wini.winitest.common;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

/**
 * [파일 업로드 공통 유틸리티]
 * 이미지 파일의 서버 저장(물리 저장) 및 DB 기록을 위한 데이터 추출
 */
public class FileUploadUtil {

    // 허용 확장자 정의
    private static final Set<String> IMAGE_EXTS = new HashSet<>(
        Arrays.asList("jpg", "jpeg", "png", "gif", "webp", "bmp")
    );

    /**
     * 이미지 파일들을 서버 디렉토리에 저장하고, 그 정보를 리스트로 반환함.
     *  files     사용자가 업로드한 파일 객체 리스트
     *  uploadDir 파일이 저장될 서버의 물리적 경로
     * DB의 File 테이블에 Insert하기 위해 가공된 데이터 리스트 return
     */
    public static List<Map<String, Object>> saveImages(
            List<MultipartFile> files, String uploadDir) throws Exception {

        // 저장 폴더 존재 여부 확인 및 자동 생성
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        List<Map<String, Object>> result = new ArrayList<>();
        int sortOrd = 0; // 파일의 정렬 순서

        for (MultipartFile file : files) {
            //  파일이 비어있는지 확인
            if (file.isEmpty()) continue;

            // 원본 파일명 및 확장자 추출
            String orgName = file.getOriginalFilename();
            int dotIdx = orgName != null ? orgName.lastIndexOf('.') : -1;
            String ext  = dotIdx >= 0 ? orgName.substring(dotIdx + 1).toLowerCase() : "";

            // 이미지 필터링: 허용되지 않은 확장자는 저장하지 않고 건너뜀 (보안 위협 방지)
            if (!IMAGE_EXTS.contains(ext)) continue;

            // 파일명 암호화(UUID): 중복 방지 및 보안
            // 동일한 이름의 파일이 업로드되어 기존 파일이 덮어씌워지는 것을 방지함
            String fileName = UUID.randomUUID().toString() + "." + ext;
            
            // 물리적 저장 실행: 메모리에 있는 데이터를 서버 디스크로 이동
            file.transferTo(new File(dir, fileName));

            // DB 삽입용 데이터 맵핑
            // 호출한 서비스 계층에서 바로 Mapper(MyBatis 등)로 전달할 수 있게 가공함
            Map<String, Object> m = new HashMap<>();
            m.put("filePath", uploadDir);   // 저장 경로
            m.put("fileName", fileName);    // 서버에 저장된 실제 파일명(UUID)
            m.put("orgName",  orgName);     // 사용자가 올린 원본 파일명
            m.put("fileExt",  ext);         // 파일 확장자
            m.put("fileSize", file.getSize()); // 파일 용량(byte 단위)
            m.put("sortOrd",  sortOrd++);   // 정렬 순서
            
            result.add(m);
        }
        return result;
    }

    /**
     * 물리적 파일 삭제 (현재 논리삭제만 진행)
     * filePath 저장된 폴더 경로
     * fileName 저장된 파일명(UUID)
     */
    public static void deletePhysical(String filePath, String fileName) {
        File f = new File(filePath, fileName);
        if (f.exists()) {
            f.delete(); // 파일이 존재할 때만 삭제 실행
        }
    }
}