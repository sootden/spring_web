package org.zerock.sample;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/applicationContext.xml")
@Log4j
public class HotelTest {
    @Setter(onMethod_ ={@Autowired})
    private SampleHotel sampleHotel;

    @Test
    public void testExist(){
        assertNotNull(sampleHotel);

        log.info(sampleHotel);
        log.info("---------------");
        log.info(sampleHotel.getChef());
    }

}
