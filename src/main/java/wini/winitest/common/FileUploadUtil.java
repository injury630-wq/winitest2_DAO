package wini.winitest.common;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {

    public static List<Map<String, Object>> saveImages(
            List<MultipartFile> files, String uploadDir, String allowedExtensions) throws Exception {

        Set<String> imageExts = new HashSet<>();
        for (String ext : allowedExtensions.split(",")) {
            imageExts.add(ext.trim());
        }

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        List<Map<String, Object>> result = new ArrayList<>();
        int sortOrd = 0;

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            String orgName = file.getOriginalFilename();
            int dotIdx = orgName != null ? orgName.lastIndexOf('.') : -1;
            String ext  = dotIdx >= 0 ? orgName.substring(dotIdx + 1).toLowerCase() : "";

            if (!imageExts.contains(ext)) continue;

            String fileName = UUID.randomUUID().toString() + "." + ext;
            file.transferTo(new File(dir, fileName));

            Map<String, Object> m = new HashMap<>();
            m.put("filePath", uploadDir);
            m.put("fileName", fileName);
            m.put("orgName",  orgName);
            m.put("fileExt",  ext);
            m.put("fileSize", file.getSize());
            m.put("sortOrd",  sortOrd++);

            result.add(m);
        }
        return result;
    }

    public static void streamImage(File f, HttpServletResponse response) throws Exception {
        String ext = f.getName().substring(f.getName().lastIndexOf('.') + 1).toLowerCase();
        response.setContentType("image/" + ("jpg".equals(ext) ? "jpeg" : ext));
        response.setContentLengthLong(f.length());
        Files.copy(f.toPath(), response.getOutputStream());
        response.flushBuffer();
    }

    public static void deletePhysical(String filePath, String fileName) {
        File f = new File(filePath, fileName);
        if (f.exists()) {
            f.delete();
        }
    }
}
