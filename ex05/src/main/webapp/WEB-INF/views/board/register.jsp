<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/09/20
  Time: 12:54 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>
<style>
  .uploadResult {
    width:100%;
    background-color: gray;
  }

  .uploadResult ul{
    display:flex;
    flex-flow: row;
    justify-content: center;
    align-items: center;
  }

  .uploadResult ul li {
    list-style: none;
    padding: 10px;
    align-content: center;
    text-align: center;
  }

  .uploadResult ul li img {
    width: 100px;
  }

  .uploadResult ul li span {
    color:white;
  }

  .bigPictureWrapper {
    position: absolute;
    display: none;
    justify-content: center;
    align-items: center;
    top: 0%;
    width: 100%;
    height: 100%;
    background-color: gray;
    z-index: 100;
    background: rgba(255, 255, 255, 0.5);
  }

  .bigPicture {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .bigPicture img {
    width: 600px;
  }
</style>

<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Board Register</h1>
  </div>
  <!-- /.col-lg-12-->
</div>
<!-- /.row-->

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading">Board Register</div>
      <!-- /.panel-heading-->
      <div class="panel-body">
        <form role="form" action="/board/register" method="post">
          <div class="form-group">
            <label>Title</label><input class="form-control" name="title">
          </div>
          <div class="form-group">
            <label>Text area</label>
            <textarea class="form-control" rows="3" name="content"></textarea>
          </div>
          
          <div class="form-group">
            <label>Writer</label><input class="form-control" name="writer">
          </div>
          <button type="submit" class="btn btn-default">Submit Button</button>
          <button type="reset" class="btn btn-default">Reset Button</button>
        </form>
      </div>
      <!-- end panel body-->
    </div>
    <!-- end panel body-->
  </div>
  <!--end panel-->
</div>
<!-- /.row -->
<!-- 새로 추가하는 부분 -->
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">File Attach</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="form-group uploadDiv">
          <input type="file" name='uploadFile' multiple>
        </div>

        <div class="uploadResult">
          <ul>

          </ul>
        </div>

      </div>
      <%--      end panel body--%>
    </div>
    <%--    end panel-body--%>
  </div>
  <%--  end panel--%>
</div>
<%--/.row--%>
<%@include file="../includes/footer.jsp"%>

<script>
  $(document).ready(function (e){
    var formObj = $("form[role='form']");

    $("button[type='submit']").on("click", function(e){
      e.preventDefault();
      console.log("submit clicked");

      var str ="";

      $(".uploadResult ul li").each(function (i, obj){
        var jobj = $(obj);

        console.dir(jobj);
        //name을 attachLisr[인덱스]로 설정하면, BoardVO의 List<BoardAttachVO>타입 attachList변수로 담김
        str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
        str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
        str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
        str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
      });
      //등록화면 form에 html을 추가하여 /board/register로 전송
      formObj.append(str).submit();
    });

    var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");

     var maxSize = 5242880;

    function checkExtension(fileName, fileSize){
      if(fileSize >= maxSize){
        alert("파일 사이즈 초과");
        return false;
      }

      if(regex.test(fileName)){
        alert("해당 종류의 파일은 업로드할 수 없습니다.");
        return false;
      }

      return true;
    }

    $("input[type='file']").change(function(e){
      var formData = new FormData();

      var inputFile = $("input[name='uploadFile']");

      var files = inputFile[0].files;

      for(var i = 0; i < files.length; i++){
        if(!checkExtension(files[i].name, files[i].size)){
          return false;
        }
        formData.append("uploadFile", files[i]);
      }

      $.ajax({
        url: '/uploadAjaxAction',
        processData: false,
        contentType: false,
        data: formData,
        type: 'POST',
        dataType: 'json',
        success: function (result){
          console.log(result);
          showUploadResult(result); //업로드 결과 처리 함수
        }
      }); // $.ajax
    });
  });

  function showUploadResult(uploadResultArr){
    if(!uploadResultArr || uploadResultArr.length == 0){ return; }

    var uploadUL = $(".uploadResult ul");

    var str="";

    $(uploadResultArr).each(function (i, obj){
      //image type
      if(obj.image){
        //섬네일 파일
        var fileCallPath = encodeURIComponent( obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);

        str += "<li data-path='"+obj.uploadPath+"'";
        str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
        str += "<div>";
        str += "<span> "+obj.fileName+"</span>";
        //data-file , data-type값은 파일 삭제를 위해 파일의 경로와 이름, 타입정보를 알아야함
        str += "<button type='button' data-file=\'" +fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
        str += "<img src='/display?fileName=/"+fileCallPath+"'>";
        str += "</div>";
        str += "</li>";
      }else{
        //일반 파일
        var fileCallPath = encodeURIComponent( obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
        // var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

        str += "<li ";
        str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'data-filename='"+
                obj.fileName+"' data-type='"+obj.image+"' >";
        str += "<div>";
        str += "<span> "+obj.fileName+"</span>";
        str += "<button type='button' data-file=\'" +fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
        str += "<img src='/resources/img/attach.png'>";
        str += "</div>";
        str += "</li>";
      }
    });
    //ul태그안에 추가
    uploadUL.append(str);
  }
  //x버튼 클릭시, 첨부파일 삭제 이벤트
  $(".uploadResult").on("click", "button", function (e){
    console.log("delete file");
    //this : jQuery의 $(this)는 클릭한 요소가 this가된다.
    var targetFile = $(this).data("file");
    var type = $(this).data("type");
    //closest(selectors) : 선택한 요소를 포함하면서 가장 가까운 상위 요소를 선택함
    var targetLi = $(this).closest("li");

    $.ajax({
      url: '/deleteFile',
      data: {fileName: targetFile, type:type},
      dataType: 'text',
      type: 'POST',
      success: function (result){
        alert(result);
        //실제로 파일이 삭제가 성공하면 화면상에서도 삭제
        targetLi.remove();
      }//$.ajax
    });
  });
</script>