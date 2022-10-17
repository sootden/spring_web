package org.zerock.mapper;

import org.apache.ibatis.annotations.Select;

public interface TimeMapper {
    //annotation 사용
    @Select("SELECT sysdate FROM dual")
    public String getTime();
    //xml 사용
    public String getTime2();
}
