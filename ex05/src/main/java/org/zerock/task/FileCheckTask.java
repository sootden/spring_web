package org.zerock.task;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.spi.CalendarNameProvider;
import java.util.stream.Collectors;

@Log4j
@Component
public class FileCheckTask {
    @Setter(onMethod_ = {@Autowired})
    private BoardAttachMapper attachMapper;

    private String getFolderYesterDay() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Calendar cal = Calendar.getInstance();
        //Calendar.add( 더할 곳 , 더할 값) : 날짜를 더해주는 메소드
        cal.add(Calendar.DATE, -1); //현 날짜 - 1 = s어제 날짜

        String str = sdf.format(cal.getTime());
        return str.replace("-", File.separator);
    }

    /*
        cron설정
        0 * * * * * (*)
        s m h d mo we y
     */
    //매일 새벽 2시에 동작
    @Scheduled(cron = "0 0 2 * * *")
    public void checkFiles() throws Exception {
        log.warn("File Check Task run.....");
        log.warn(new Date());

        //DB에서 어제 날짜로 보관된 모든 첨부파일 리스트
        List<BoardAttachVO> fileList = attachMapper.getOldFiles();
        //BoardAttachVO타입 원소를 Path타입으로 변환하여 리스트 생성
        List<Path> fileListPaths =
                fileList.stream().map(vo -> Paths.get(
                        "/Users/sueun/upload",
                        vo.getUploadPath(),
                        vo.getUuid() + "_" + vo.getFileName())
                ).collect(Collectors.toList());
        //섬네일 파일도 추가
        fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get(
                "/Users/sueun/upload",
                vo.getUploadPath(),
                "s_" + vo.getUuid() + "_" + vo.getFileName())).forEach(p -> fileListPaths.add(p));

        log.warn("========================");

        fileListPaths.forEach(p -> log.warn(p));

        //데이터베이스의 파일과 비교하기위해 실제 폴더 파일 가져옴
        //Paths.get() : 특정 경로의 파일 정보를 가져옴
        File targetDir = Paths.get("/Users/sueun/upload", getFolderYesterDay()).toFile();

        //데이터베이스에 포함되지 않는(폴더에 아직 삭제되지 않은) 파일을 찾고 삭제함
        File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
        log.warn("---------------------------");
        for (File file : removeFiles) {
            log.warn(file.getAbsolutePath());
            file.delete();
        }
    }
}