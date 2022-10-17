package org.zerock.test;

public class ClassforNameTest {
    private static ClassforNameTest driver = null;

    static{
        if(driver ==  null){
            driver = new org.zerock.test.ClassforNameTest();
            System.out.println("로드됨");
        }
    }
    {
        System.out.println("인스턴스 생성됨");
    }

}
