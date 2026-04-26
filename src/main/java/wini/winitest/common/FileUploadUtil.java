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

public class FileUploadUtil {

    private static final Set<String> IMAGE_EXTS = new HashSet<>(
        Arrays.asList("jpg", "jpeg", "png", "gif", "webp", "bmp")
    );

    /**
     * 이미지 파일만 물리 저장. 반환 리스트의 각 맵은 DB 삽입용 파라미터
     * (boardNo, fileNo 는 없음 - 호출 쪽에서 넣어야 함)
     */
    public static List<Map<String, Object>> saveImages(
            List<MultipartFile> files, String uploadDir, Object regUser) throws Exception {

        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        List<Map<String, Object>> result = new ArrayList<>();
        int sortOrd = 0;

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;
            String orgName = file.getOriginalFilename();
            int dotIdx = orgName != null ? orgName.lastIndexOf('.') : -1;
            String ext  = dotIdx >= 0 ? orgName.substring(dotIdx + 1).toLowerCase() : "";
            if (!IMAGE_EXTS.contains(ext)) continue;

            String fileName = UUID.randomUUID().toString() + "." + ext;
            file.transferTo(new File(dir, fileName));

            Map<String, Object> m = new HashMap<>();
            m.put("filePath", uploadDir);
            m.put("fileName", fileName);
            m.put("orgName",  orgName);
            m.put("fileExt",  ext);
            m.put("fileSize", file.getSize());
            m.put("sortOrd",  sortOrd++);
            m.put("regUser",  regUser);
            result.add(m);
        }
        return result;
    }

    public static void deletePhysical(String filePath, String fileName) {
        File f = new File(filePath, fileName);
        if (f.exists()) f.delete();
    }
}
