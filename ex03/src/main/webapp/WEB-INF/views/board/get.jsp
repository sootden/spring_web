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
                    <button data-oper='modify' type="modify" class="btn btn-default">
                        Modify
                    </button>
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
<div class = 'row'>
    <div class="col-lg-12">
        <!-- /. panel-->
        <div class="panel panel-default">
<%--            <div class="panel-heading">--%>
<%--                <i class="fa fa-comments fa-fw"></i> Reply--%>
<%--            </div>--%>
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                    <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
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

       // 댓글 등록
       $("#addReplyBtn").on("click", function(e){
           //input value값 ""로 처리
          modal.find("input").val("");
          //등록날짜 숨김
          modalInputReplyDate.closest("div").hide();

          //close, register 제외한 버튼 모두 숨김
          modal.find("button[id != 'modalCloseBtn']").hide();
          modalRegisterBtn.show();

          $(".modal").modal("show");
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
        //특정 댓글 처리시, 이벤트 처리 -> 이벤트 위임(delegation): 동적으로 생성된 요소에 이벤트 위임 ( ul -> li 위임)
       $(".chat").on("click", "li", function(e){
           var rno = $(this).data("rno");
           console.log(rno);
       });
        //댓글 조회 클릭시 모달 show
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
           var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};

           replyService.update(reply, function(result){
               alert(result);
               modal.modal("hide");
               // showList(1);
               showList(pageNum);
           });
       });

       modalRemoveBtn.on("click", function(e){
           var rno = modal.data("rno");

           replyService.remove(rno, function (result){
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
