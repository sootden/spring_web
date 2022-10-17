package org.zerock.domain;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class ToDoDTO {
    private String title;

    // @InitParam 사용할때
//    private Date dueDate;

    @DateTimeFormat(pattern = "yyyy/MM/dd")
    private Date dueDate;
}
