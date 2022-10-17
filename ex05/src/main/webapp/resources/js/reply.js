//모듈 패턴 :  관련있는 함수들을 하나에 모듈처럼 묶음으로 구성하는 것 . 즉시 실행함수 내부에 필요한 메서드를 구성해서 객체를 구성하는 방식
console.log("Reply Module...");

var replyService=(function (){

    function add(reply, callback, error){
        console.log("add reply...");

        $.ajax({
            type : 'post', //http 요청 방식 (default: GET)
            url : '/replies/new', //요청이 전송될 url주소
            data : JSON.stringify(reply), // 요청시 포함되어질 데이터
            contentType : "application/json; charset=utf-8", //요청 컨텐트 타입
            success : function (result, status, xhr){
                //정상적으로 응답 받았을 경우 success콜백이 호출되게 됨
                if(callback){
                    callback(result);
                }
            },
            error : function (xhr, status, er){
                //응답을 받지 못했거나 정상적인 응답이지만 데이터 형식을 확인할 수 없을 경우 error콜백 호출
                if(error){
                    error(er);
                }
            }
        })
    }

    //param이라는 객체를 통해 필요한 파라미터를 전달받아 json목록을 호출함
    function getList(param, callback, error){
        var bno = param.bno;
        var page = param.page || 1;

        $.getJSON("/replies/pages/"+bno+"/"+page+".json",
            function (data) {
                if (callback) {
                    // callback(data); //댓글 목록만 가져오는 경우
                    callback(data.replyCnt, data.list) //댓글 숫자와 목록을 가져오는 경우
                }
            }).fail(function(xhr, status, err){
                if(error){
                    error();
                }
        });
    }

    function remove(rno, callback, error){
        $.ajax({
            type : 'delete',
            url : '/replies/'+rno,
            success : function (deleteResult, status, xhr){
                if(callback){
                    callback(deleteResult);
                }
            },
            error : function (xhr, status, er){
                if(error){
                    error(er);
                }
            }
        });
    }

    function update(reply, callback, error){
        console.log("RNO: "+reply.rno);

        $.ajax({
            type : 'put',
            url : '/replies/'+reply.rno,
            data : JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success : function (result, status, xhr){
                if(callback){
                    callback(result);
                }
            },
            error : function (xhr, status, er){
                if(error){
                    error(er)
                }
            }
        });
    }

    function get(rno, callback, error){
        $.get("/replies/"+rno+".json", function (result){
            if(callback){
                callback(result);
            }
        }).fail(function(xhr, status, err){
            if(error){
                error();
            }
        });
    }

    function displayTime(timeValue){
        var today = new Date();

        var gap = today.getTime() - timeValue;

        var dateObj = new Date(timeValue);
        var str = "";

        if(gap < (1000 * 60 * 60 * 24)){
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();

            return[(hh>9 ? '':'0')+hh, ':', (mi > 9 ? '':'0')+mi, ':', (ss>9 ? '':'0')+ss].join('');
        } else {
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth() + 1; //getMonth() is zero-based
            var dd = dateObj.getDate();

            return[yy, '/', (mm>9 ? '':'0')+mm, '/', (dd>9 ? '':'0')+dd].join('');
        }
    };

    return {
        add : add,
        getList : getList,
        remove : remove,
        update : update,
        get : get,
        displayTime : displayTime
    };
})();