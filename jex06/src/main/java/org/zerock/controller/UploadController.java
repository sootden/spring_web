package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@Log4j
public class UploadController {

    // <form>태그를 이용한 파일 업로드
    @GetMapping("/uploadForm")
    public void uploadForm(){
        log.info("upload form");
    }

    //MultipartFile : Spring MVC는 MultipartFile타입을 제공하여 업로드되는 파일 데이터를 쉽게 처리하게함
    @PostMapping("/uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model){

        String uploadFolder = "/Users/sueun/upload";

        for(MultipartFile multipartFile : uploadFile){
            log.info("-----------------------------");
            log.info("Upload Parameter Name: "+multipartFile.getName()); // 파라미터 이름 <input> 태그이름
            log.info("Upload File Name: "+ multipartFile.getOriginalFilename()); // 업로드되는 파일의 이름
            log.info("Upload Empty true/false : "+multipartFile.isEmpty());  // 파일이 존재하지 않는 경우 true
            log.info("Upload File Size: "+multipartFile.getSize()); // 업로드되는 파일의 크기
//            multipartFile.getBytes();  byte[]파일 데이터 변환
//            multipartFile.getInputStream(); 파일데이터와 연결된 InputStream반환
//            multipartFile.transferTo(File file); 파일 저장

            File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

            try{
                multipartFile.transferTo(saveFile);
            }catch (Exception e){
                log.error(e.getMessage());
            }//end catch
        }//end for
    }
    // ajax를 이용한 파일 업로드
    @GetMapping("/uploadAjax")
    public void uploadAjax(){

        log.info("upload ajax");
    }
    @PreAuthorize("isAuthenticated()")
    @PostMapping(value="/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>>uploadAjaxPost(MultipartFile[] uploadFile){
        List<AttachFileDTO> list = new ArrayList<>();
        String uploadFolder = "/Users/sueun/upload";

        String uploadFolderPath = getFolder();

        // make folder----
        File uploadPath = new File(uploadFolder, uploadFolderPath);

        //해당 경로가 없으면 생성 -> 자동으로 폴더가 생겨 해당 폴더에 파일 저장됨
        if(uploadPath.exists() == false){
            uploadPath.mkdirs();
        }
        //make yyyy/MM/dd folder

        for(MultipartFile multipartFile : uploadFile){
            log.info("-----------------------------");
            log.info("Upload File Name: "+multipartFile.getOriginalFilename());
            log.info("Upload File Size: "+multipartFile.getSize());

            AttachFileDTO attachDTO = new AttachFileDTO();

            String uploadFileName = multipartFile.getOriginalFilename();
            //IE has file path
            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
            log.info("only file name : "+uploadFileName);
            attachDTO.setFileName(uploadFileName);


            //동일한 파일명으로 업로드시 기존파일이 지워지는 문제를 해결하기 위해 UUID를 이용함
            UUID uuid = UUID.randomUUID(); //임의의 값 생성

            uploadFileName = uuid.toString() + "_" +uploadFileName;

//            File saveFile = new File(uploadFolder, uploadFileName);

            /*
                Thumbnailator : InputStream과 java.io.File객체를 이용해 파일을 생성하고
                사이즈에 대해 파라미터로 width, height를 지정할 수 있음
             */
            try{
                File saveFile = new File(uploadPath, uploadFileName);
                multipartFile.transferTo(saveFile);

                attachDTO.setUuid(uuid.toString());
                attachDTO.setUploadPath(uploadFolderPath);

                //check image type file
                if(checkImageType(saveFile)){ //이미지 파일 이면, 섬네일 생성

                    attachDTO.setImage(true);

                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_"+uploadFileName));
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail, 100, 100);
                    thumbnail.close();
                }

                //add to List
                list.add(attachDTO);
            }catch (Exception e){
                e.printStackTrace();
            }//end catch
        }//end for
        return new ResponseEntity<>(list, HttpStatus.OK);
    }


    @GetMapping("/display")
    @ResponseBody
    public ResponseEntity<byte[]>getFile(String fileName){
        log.info("fileName: "+fileName);

        File file = new File("/Users/sueun/upload"+fileName);

        log.info("file: "+file);

        ResponseEntity<byte[]> result = null;

        try{
            HttpHeaders header = new HttpHeaders();
            // probeContentType() :
            // byte[]로 이미지 파일의 데이터를 전송할때는 파일의 종류에 따라 MIME타입이 달라진다
            // 따라서 probeContentType()메서드를 이용해서 적절한 MIME타입 데이터를 Http의 헤더 메시지에 포함할 수 있도록 처리
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            //FileCopyUtils.copyToByteArray(File file) : byte[] 해당 파일의 내용을 새로운 byte[]에 복사하여 리턴
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),
                    header, HttpStatus.OK);
        } catch (IOException e){
            e.printStackTrace();
        }
        return result;
    }

    @GetMapping(value="/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE) //MIME타입 다운로드 타입으로 지정
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent")String userAgent,String fileName){

        log.info("download file: "+fileName);

        Resource resource = new FileSystemResource("/Users/sueun/upload/"+fileName);

        if(resource.exists() == false){
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        log.info("resource: "+resource);

        String resourceName = resource.getFilename();
        //remove UUID
        String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);

        HttpHeaders headers = new HttpHeaders();
        //Content-Disposition : 다운로드시 저장되는 이름을 Content-Disposition을 이용해 지정
        // IE에서는 Content-Disposition값을 처리하는 방식이 다른 브라우저와 다른 인코딩 방식이여서 한글은 깨져 나타남.
        // HTTP헤더 중 User-Agent값(디바이스 정보)을 이용해서 구분
        try{
            String downloadName = null;
            if(userAgent.contains("Trident")){
                log.info("IE browser");
                downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+"," ");
            }else if(userAgent.contains("Edge")){
                log.info("Edge browser");

                downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
                log.info("Edge name: "+downloadName);
            }else {
                log.info("Chrome browser");
                downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
            }
            log.info("downloadName: "+downloadName);

            headers.add("Content-Disposition", "attachment; filename="+downloadName);
        }catch (UnsupportedEncodingException e){
            e.printStackTrace();
        }
        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    }

    @PreAuthorize("isAuthenticated()")
    @PostMapping("/deleteFile")
    @ResponseBody
    public ResponseEntity<String> deleteFile(String fileName, String type){
        log.info("deleteFile: "+fileName);

        File file;

        try{
            file = new File("/Users/sueun/upload/"+ URLDecoder.decode(fileName, "UTF-8"));
            log.info("여기->"+"/User/sueun/upload/"+ URLDecoder.decode(fileName, "UTF-8"));
            file.delete();

            //이미지파일인 경우, 원본까지 삭제
            if(type.equals("image")){
                String largeFileName = file.getAbsolutePath().replace("s_", "");

                log.info("largeFileName: "+ largeFileName);

                file = new File(largeFileName);

                file.delete();
            }
        }catch (UnsupportedEncodingException e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<String>("deleted", HttpStatus.OK);
    }

    // 오늘 날짜의 경로를 문자열로 생성하여 폴더 경로로 수정한뒤 반환
    private String getFolder(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Date date = new Date();

        String str = sdf.format(date);

        //"-"를 리눅스기준 "/"로 변환
        //File.separator : 운영체제에 맞는 구분자를 지정해줌
        return str.replace("-", File.separator);
    }
    //이미지 타입 검사
    private boolean checkImageType(File file){
        try{
            String contentType = Files.probeContentType(file.toPath());
            return contentType.startsWith("image");
        }catch (IOException e){
            e.printStackTrace();
        }
        return false;
    }

}
