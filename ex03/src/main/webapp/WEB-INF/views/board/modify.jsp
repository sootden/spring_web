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

                    <button data-oper='modify' type="submit" class="btn btn-default">Modify</button>
                    <button data-oper='remove' type="submit" class="btn btn-danger">Remove</button>
                    <button data-oper='list' type="submit" class="btn btn-info">List</button>
                </form>
            </div>
            <!-- end panel body-->
        </div>
        <!-- end panel body-->
    </div>
    <!--end panel-->
</div>
<!-- /.row -->
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
            }
            formObj.submit();
        });
    });
</script>