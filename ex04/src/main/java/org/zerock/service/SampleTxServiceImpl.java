package org.zerock.service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.mapper.Sample1Mapper;
import org.zerock.mapper.Sample2Mapper;

@Service
@Log4j
public class SampleTxServiceImpl implements SampleTxService{
   @Setter(onMethod_={@Autowired})
   private Sample1Mapper mapper1;

   @Setter(onMethod_={@Autowired})
   private Sample2Mapper mapper2;

   //@Transactional : 트랜잭션 처리
    /*
        @Transactional의 중요한 속성들 p478
        메서드뿐만아니라 클래스, 인터페이스에도 가능
        어노테이션 우선순위 : 메서드 > 클래스 > 인터페이스
     */
   @Transactional
    @Override
    public void addData(String value) {
        log.info("mapper1.....");
        mapper1.insertCol1(value);

        log.info("mapper2......");
        mapper2.insertCol2(value);

        log.info("end..........");
    }
}
