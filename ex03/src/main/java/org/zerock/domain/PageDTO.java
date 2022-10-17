package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    //화면에 보여지는 시작 페이지 번호
    private int startPage;
    //화면에 보여지는 끝 패이지 번호
    private int endPage;
    //이전, 다음으로 이동가능한 링크(페이지들) 유무
    private boolean prev, next;

    //전체 데이터 수
    private int total;
    //현재 페이지 번호, 한 페이지 당 데이터 수
    private Criteria cri;

    public PageDTO(Criteria cri, int total){
        this.cri = cri;
        this.total = total;

        //페이지번호가 10개씩 보인다고 가정
        this.endPage = (int)(Math.ceil(cri.getPageNum()/10.0)) * 10;
        this.startPage = this.endPage - 9;

        int realEnd = (int)(Math.ceil((total * 1.0)/cri.getAmount()));

        if(realEnd < this.endPage){
            this.endPage = realEnd;
        }

        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;

    }
}
