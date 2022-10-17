package org.zerock.sample;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;
import org.springframework.stereotype.Component;

@Component
@ToString
@Getter
@AllArgsConstructor
public class SampleHotel {
    private Chef chef;
//    public SampleHotel(Chef chef){
//        this.chef = chef;
//    }
}
