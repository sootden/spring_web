<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/09/20
  Time: 2:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%@include file="../includes/header.jsp"%>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
    <!-- /.col-lg-12-->
</div>
<!-- /.row-->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Read Page</div>
            <!-- /.panel-heading-->
            <div class="panel-body">
                <form role="form" action="/board/modify" method="post">
                    <!-- 추가 -->
                    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                    <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>

                    <div class="form-group">
                        <label>Bno</label><input class="form-control" name='bno' value='<c:out value="${board.bno}"/>'readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Title</label><input class="form-control" name='title' value='<c:out value="${board.title}"/>'>
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content' ><c:out value="${board.content}"/></textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label><input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>RegDate</label><input class="form-control" name='regDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Update Date</label><input class="form-control" name='updateDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly="readonly">
                    </div>

                    <sec:authentication property="principal" var="pinfo"/>
                    <sec:authorize access="isAuthenticated()">
                        <c:if test="${pinfo.username eq board.writer}">
                            <button data-oper='modify' type="submit" class="btn btn-default">Modify</button>
                            <button data-oper='remove' type="submit" class="btn btn-danger">Remove</button>
                        </c:if>
                    </sec:authorize>
                    <button data-oper='list' type="submit" class="btn btn-info">List</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </form>
            </div>
            <!-- end panel body-->
        </div>
        <!-- end panel body-->
    </div>
    <!--end panel-->
</div>
<!-- /.row -->
<div class="bigPictureWrapper">
    <div class="bigPicture">
    </div>
</div>
<style>
    .uploadResult {
        background-color: gray;
    }
    .uploadResult ul{
        display: flex;
        flex-flow: row;
        justity-content: center;
        align-items: center;
    }
    .uploadResult ul li{
        list-style: none;
        padding: 10px;
        align-content: center;
        text-align: center;
    }
    .uploadResult ul li img{
        width: 100px;
    }
    .uploadResult ul li span{
        color: white;
    }
    .bigPictureWrapper{
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top: 0%
        width: 100%;
        height: 100%;
        background-color: gray;
        z-index: 100;
        background:rgba(255,255,255,0.5);
    }
    .bigPicture{
        width: 600px;
    }
</style>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">File</div>
            <!--/.panel-heading-->
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name='uploadFile' multiple = "multiple">
                </div>
                <div class="uploadResult">
                    <ul>
                    </ul>
                </div>
            </div>
            <%--            end panel-body--%>
        </div>
        <%--        end panel-body--%>
    </div>
    <%--    end panel--%>
</div>
<%--/.row--%>
<%@include file="../includes/footer.jsp"%>
<script typ="text/javascript">
    $(document).ready(function (){
        var formObj = $("form");

        $('button').on("click", function (e){
            // 기본동작 막고 직접 submit()하기위함
            e.preventDefault();

            //<button>태그의 data-oper속성을 이용하여 기능 처리
            var operation = $(this).data("oper");

            console.log(operation);

            if(operation === 'remove'){
                formObj.attr("action", "/board/remove");
            }else if(operation === 'list'){
                //move to list
                formObj.attr("action", "/board/list").attr("method","get");

                //pageNum, amount값만 전달하면 되기때문에 <form>태그의 모든 내용 삭제한 상태에서 두 값(pageNum,amount)을 추가하고 submit()
                //clone() : 값 보관
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTag = $("input[name='type']").clone();

                formObj.empty();
                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTag);
            }else if(operation === 'modify'){
                var str ="";

                $(".uploadResult ul li").each(function (i, obj){
                    var jobj = $(obj);

                    console.dir(jobj);

                    str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
                });
                formObj.append(str).submit();
            } //
            formObj.submit();
        });
    });
</script>
<script>
    //수정화면 시작시, 첨부파일 가져오기
    $(document).ready(function (){
        (function(){
            var bno = '<c:out value="${board.bno}"/>';
            $.getJSON("/board/getAttachList", {bno:bno}, function(arr){
                console.log(arr);

                var str="";

                $(arr).each(function(i, attach){
                    //image type
                    if(attach.fileType){
                        var fileCallPath = encodeURIComponent( attach.uploadPath + "/s_"+attach.uuid+"_"+attach.fileName);
                        console.log("업로드경로 : "+attach.uploadPath)
                        str += "<li data-path='"+attach.uploadPath+"'";
                        str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
                        str += "<div>";
                        str += "<span> "+attach.fileName+"</span><br/>";
                        str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "; //삭제버튼
                        str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src='/display?fileName=/"+fileCallPath+"'>";
                        str += "</div>";
                        str += "</li>";
                    }else{
                        str += "<li data-path='"+attach.uploadPath+"'";
                        str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
                        str += "<div>";
                        str += "<span> "+attach.fileName+"</span><br/>";
                        str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "; //삭제버튼
                        str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src='/resources/img/attach.png'>";
                        str += "</div>";
                        str += "</li>";
                    }
                });
                $(".uploadResult ul").html(str);
            });//end getjson
        })();

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
        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";

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
                beforeSend: function(xhr){
                  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                },
                dataType: 'json',
                success: function (result){
                    console.log(result);
                    showUploadResult(result); //업로드 결과 처리 함수
                }
            }); // $.ajax
        });
    });
    //화면상 첨부파일 삭제
    $(".uploadResult").on("click", "button", function (e){
       console.log("delete file");
       if(confirm("Remove this file? ")){
           var targetLi =  $(this).closest("li");
           targetLi.remove();
       }
    });

    function showUploadResult(uploadResultArr){
        if(!uploadResultArr || uploadResultArr.length == 0){ return; }

        var uploadUL = $(".uploadResult ul");

        var str="";

        $(uploadResultArr).each(function (i, obj){
            //image type
            if(obj.image){
                var fileCallPath = encodeURIComponent( obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);

                console.log("여기->"+fileCallPath);

                str += "<li data-path='"+obj.uploadPath+"'";
                str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
                str += "<div>";
                str += "<span> "+obj.fileName+"</span>";
                str += "<button type='button' data-file=\'" +fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                str += "<img src='/display?fileName=/"+fileCallPath+"'>";
                str += "</div>";
                str += "</li>";
            }else{
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

        uploadUL.append(str);
    }
</script>
