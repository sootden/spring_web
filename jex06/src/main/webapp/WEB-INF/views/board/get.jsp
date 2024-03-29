<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/09/20
  Time: 2:04 PM
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

                    <div class="form-group">
                        <label>Bno</label><input class="form-control" name='bno' value='<c:out value="${board.bno}"/>'readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Title</label><input class="form-control" name='title' value='<c:out value="${board.title}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content' readonly="readonly"><c:out value="${board.content}"/></textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label><input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
                    </div>
                    <sec:authentication property="principal" var="pinfo"/>
                        <sec:authorize access="isAuthenticated()">
                            <c:if test="${pinfo.username eq board.writer}">
                                <button data-oper='modify' type="modify" class="btn btn-default">
                                    Modify
                                </button>
                            </c:if>
                        </sec:authorize>
                    <button data-oper='list' type="list" class="btn btn-info">List</button>

                <form id="operForm" action="/board/modify" method="get">
                    <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'>
                    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                    <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                </form>
            </div>
            <!-- end panel body-->
        </div>
        <!-- end panel body-->
    </div>
    <!--end panel-->
</div>
<!-- /.row -->
<%--원본이미지가 보일 영역--%>
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
<%--첨부파일이 보여질 영역--%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <!--/.panel-heading-->
            <div class="panel-body">

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


<div class = 'row'>
    <div class="col-lg-12">
        <!-- /. panel-->
        <div class="panel panel-default">
<%--            <div class="panel-heading">--%>
<%--                <i class="fa fa-comments fa-fw"></i> Reply--%>
<%--            </div>--%>
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <sec:authorize access="isAuthenticated()">
                    <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
                </sec:authorize>
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <ul class="chat">
                    <!-- start reply-->
                    <li class="left clearfix" data-rno='12'>
                        <div>
                            <div class="header">
                                <strong class="primary-font">user00</strong>
                                <small class="pull-right text-muted">2018-01-01 13:13</small>
                            </div>
                            <p>Good job!</p>
                        </div>
                    </li>
                    <!-- end reply-->
                </ul>
                <!-- ./ end ul-->
            </div>
            <!-- /. panel .chat-panel -->
            <div class="panel-footer">

            </div>
        </div>
    </div>
    <!-- ./ end row -->
</div>
<!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Reply</label>
                        <input class="form-control" name='reply' value="New Reply!!!">
                    </div>
                    <div class="form-group">
                        <label>Replyer</label>
                        <input class="form-control" name='replyer' value="replyer">
                    </div>
                    <div class="form-group">
                        <label>Reply Date</label>
                        <input class="form-control" name="replyDate" value="">
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                    <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                    <button id="modalRegisterBtn" type="button" class="btn btn-default" data-dismiss="modal">Register</button>
                    <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog-->
    </div>
    <!-- /.modal -->

<%@include file="../includes/footer.jsp"%>

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
    $(document).ready(function (){
       var bnoValue = '<c:out value="${board.bno}"/>';
       var replyUL = $(".chat");

       showList(1);

       function showList(page){
           console.log("show list"+page);

           replyService.getList({bno:bnoValue,page:page||1}, function (replyCnt, list){
              console.log("replyCnt: "+ replyCnt);
              console.log("list: "+list);
              console.log(list);

              // page가 -1로 전달되면 마지막 페이지를 찾아서 다시 호출하게 됨
              if(page == -1){
                  pageNum = Math.ceil(replyCnt/10.0);
                  showList(pageNum);
                  return;
              }

               var str = "";

               if(list == null || list.length == 0){
                   // replyUL.html("");
                   return;
               }

               for(var i = 0, len = list.length||0; i < len; i++){
                   str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                   str +="  <div><div class='header'><strong class='primary-font'>["+list[i].rno+"] "+list[i].replyer+"</strong>";
                   str +="      <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
                   str +="          <p>"+list[i].reply+"</p></div></li>";
               }
               replyUL.html(str);

               showReplyPage(replyCnt);

           }); //end function
       } // end showList

        var modal = $(".modal");
       var modalInputReply = modal.find("input[name='reply']");
       var modalInputReplyer = modal.find("input[name='replyer']");
       var modalInputReplyDate = modal.find("input[name='replyDate']");

       var modalModBtn = $("#modalModBtn");
       var modalRemoveBtn = $("#modalRemoveBtn");
       var modalRegisterBtn = $("#modalRegisterBtn");

       var replyer = null;

       <sec:authorize access="isAuthenticated()">
        replyer = '<sec:authentication property="principal.username"/>';
        </sec:authorize>
        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";

       $("#addReplyBtn").on("click", function(e){
          modal.find("input").val("");
          modal.find("input[name='replyer']").val(replyer);
          modalInputReplyDate.closest("div").hide();
          modal.find("button[id != 'modalCloseBtn']").hide();

          modalRegisterBtn.show();

          $(".modal").modal("show");
       });
       //Ajax spring security header
       $(document).ajaxSend(function(e,xhr,potions){
          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
       });

       modalRegisterBtn.on("click", function (e){
           var reply = {
               reply : modalInputReply.val(),
               replyer : modalInputReplyer.val(),
               bno : bnoValue
           };
           replyService.add(reply, function(result){
               //댯글이 정상적으로 등록되면 경고창을 이용해 성공 표시
               alert(result);

               // 입력항목 비우고 모달창 닫기
               modal.find("input").val("");
               modal.modal("hide");

               // 주의 : 댓글 추가 후 갱신 필수
               // showList(1);
               showList(-1); //댓글 페이징의 경우, 등록시 새 댓글이 생성되는 마지막 페이지로 이동하기 위해
           });
       });

       $(".chat").on("click", "li", function(e){
           var rno = $(this).data("rno");
           console.log(rno);
       });

       $(".chat").on("click", "li", function(e){
           var rno = $(this).data("rno");
           replyService.get(rno, function (reply){
              modalInputReply.val(reply.reply);
              modalInputReplyer.val(reply.replyer);
              modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
              modal.data("rno", reply.rno);

              modal.find("button[id != 'modalCloseBtn']").hide();
              modalModBtn.show();
              modalRemoveBtn.show();

              $(".modal").modal("show");
           });
       });

       modalModBtn.on("click", function(e){
           var originalReplyer = modalInputReplyer.val();
           var reply = {rno:modal.data("rno"), reply: modalInputReply.val(), replyer: originalReplyer};

           if(!replyer){
               alert("로그인후 수정이 가능합니다.");
               modal.modal("hide");
               return;
           }
           console.log("Original Replyer: "+originalReplyer);
            if(replyer != originalReplyer){
                alert("자신이 작성한 댓글만 수정이 가능합니다.");
                modal.modal("hide");
                return;
            }
           replyService.update(reply, function(result){
               alert(result);
               modal.modal("hide");
               // showList(1);
               showList(pageNum);
           });
       });

       modalRemoveBtn.on("click", function(e){
           var rno = modal.data("rno");

           console.log("RNO: "+rno);
           console.log("REPLYER: "+replyer);

           if(!replyer){
               alert("로그인후 삭제가 가능합니다.");
               modal.modal("hide");
               return;
           }
           var originalReplyer = modalInputReplyer.val();
           console.log("Original Replyer: "+originalReplyer);

           if(replyer != originalReplyer){
               alert("자신이 작성한 댓글만 삭제가 가능합니다.");
               modal.modal("hide");
               return;
           }

           replyService.remove(rno,originalReplyer, function (result){
               alert(result);
               modal.modal("hide");
               // showList(1);
               showList(pageNum);
           });
       });

       var pageNum = 1;
       var replyPageFooter = $(".panel-footer");

       // 기존 java로 작성한 PageMaker의 JS버전
       function showReplyPage(replyCnt){
           var endNum = Math.ceil(pageNum/10.0)*10;
           var startNum = endNum - 9;

           var prev = startNum != 1;
           var next = false;

           if(endNum * 10 >= replyCnt){
               endNum = Math.ceil(replyCnt/10.0);
           }

           if(endNum * 10 < replyCnt){
               next = true;
           }

           var str = "<ul class='pagination pull-right'>";

           if(prev){
               str += "<li class='page-item'><a class='page-link' href='"
                   + (startNum -1)+"'>Previous</a></li>";
           }

           for(var i = startNum; i <= endNum; i++){
               var active = pageNum == i ? "active":"";
               str+="<li class='page-item "+ active+" '><a class='page-link' href='"
                   + i+"'>"+i+"</a></li>";
           }

           if(next){
               str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
           }

           str += "</ul></div>";

           console.log(str);

           console.log(str);

           replyPageFooter.html(str);
       }

       replyPageFooter.on("click", "li a", function(e){
          e.preventDefault();
          console.log("page click");

          var targetPageNum = $(this).attr("href");

          console.log("targetPageNum: "+targetPageNum);

          pageNum = targetPageNum;

          showList(pageNum);
       });

    });
</script>
<script type="text/javascript">
    console.log("==========");
    console.log("JS TEST");

    var bnoValue = '<c:out value="${board.bno}"/>';
    //for replyService add test
    // replyService.add(
    //     {reply:"JS Test", replyer:"tester", bno:bnoValue}
    //     ,
    //     function (result){
    //         alert("RESULT: "+result);
    //     }
    // )

    //for replyService getList test
    // replyService.getList({bno:bnoValue, page:1}, function (list){
    //     for(var i = 0, len = list.length|| 0; i < len; i++){
    //         console.log(list[i]);
    //     }
    // });

   //for replyService remove test
   // replyService.remove(3, function (count) {
   //     console.log(count);
   //     if (count === "success") {
   //         alert("REMOVED");
   //     }
   // },function (err) {
   //     alert('ERROR...');
   // });

    //for replyService update test
    // replyService.update({
    //     rno : 8,
    //     bno : bnoValue,
    //     reply : "Modified Reply..."
    // }, function (result){
    //     alert("수정 완료...")
    // });

    //for replyService get test
    // replyService.get(8, function (data){
    //     console.log(data);
    // });

    $(document).ready(function(){
       console.log(replyService);
    });
</script>
<script type="text/javascript">
    $(document).ready(function (){
        var operForm = $("#operForm");

        $("button[data-oper='modify']").on("click", function (e){
            operForm.attr("action", "/board/modify").submit();
        });

        $("button[data-oper='list']").on("click", function (e){
            //목록으로 돌아가는 경우 bno값을 전달할 필요가 없기때문에 <form>태그내의 bno태그 삭제
            operForm.find("#bno").remove();
            operForm.attr("action","/board/list")
            operForm.submit();
        });
    });
</script>
<script>
    //게시물 조회시, 첨부파일 가져오기
    $(document).ready(function (){
        (function(){
            var bno = '<c:out value="${board.bno}"/>';
            //JSON형태의 데이터 가져오기
           $.getJSON("/board/getAttachList", {bno:bno}, function(arr){
               //arr : 해당 게시물의 첨부파일 (BoardAttachVO) 리스트
              console.log(arr);

              var str="";

              $(arr).each(function(i, attach){
                 //image type
                 if(attach.fileType){
                     //섬네일 파일 경로
                     var fileCallPath = encodeURIComponent( attach.uploadPath + "/s_"+attach.uuid+"_"+attach.fileName);
                     console.log("업로드경로 : "+attach.uploadPath)
                     str += "<li data-path='"+attach.uploadPath+"'";
                     str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
                     str += "<div>";
                     str += "<img src='/display?fileName=/"+fileCallPath+"'>";
                     str += "</div>";
                     str += "</li>";
                 }else{
                     str += "<li data-path='"+attach.uploadPath+"'";
                     str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
                     str += "<div>";
                     str += "<span> "+attach.fileName+"</span><br/>";
                     str += "<img src='/resources/img/attach.png'>";
                     str += "</div>";
                     str += "</li>";
                 }
              });
              $(".uploadResult ul").html(str);
           });//end getjson
        })();
    });

    //첨부파일 선택시, 이미지는 원본파일 보여주기 / 일반파일은 다운로드
    $(".uploadResult").on("click","li", function (e){
       console.log("view image");

       var liObj = $(this);

       var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));

       console.log("path: "+liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
       if(liObj.data("type")){
           showImage(path);
       }else{
           //download
           self.loaction = "/download?fileName=/"+path;
       }
    });
    //원본파일 보여주기
    function showImage(fileCallPath){
        $(".bigPictureWrapper").css("display", "flex").show(); //정중앙에 오기
        $(".bigPicture").html("<img src='/display?fileName=/"+fileCallPath+"'>").animate({width:'100%', height: '100%'}, 1000);
    }
    //원본파일 닫기
    $(".bigPictureWrapper").on("click", function (e){
       $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
       setTimeout(function (){
           $('.bigPictureWrapper').hide();
       }, 1000);
    });

</script>
