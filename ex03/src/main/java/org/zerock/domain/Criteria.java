package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.util.UriComponentsBuilder;

@Getter
@Setter
@ToString
public class Criteria {
    private int pageNum;
    private int amount;

    private String type;
    private String keyword;

    //default
    public Criteria(){
        this(1,10);
    }

    public Criteria(int pageNum, int amount){
        this.pageNum = pageNum;
        this.amount = amount;
    }

    public String[] getTypeArr(){
        //type="TCW" 이면 ""을 기준으로 분리되어 배열로 만들어짐
        //{"T","C","W"}
        //만약 null이면 빈 배열 생성
        return type == null? new String[] {}: type.split("");
    }

    //자동으로 GET방식의 URL인코딩된 결과를 만들어 줌 (한글처리에 신경쓰지 않아도 됨)
    public String getListLink(){
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
                .queryParam("pageNum",this.pageNum)
                .queryParam("amount", this.getAmount())
                .queryParam("type",this.getType())
                .queryParam("keyword",this.getKeyword());

        return builder.toUriString();
    }
}
