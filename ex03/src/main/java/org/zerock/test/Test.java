package org.zerock.test;

public class Test {

    public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
        Class.forName("org.zerock.test.ClassforNameTest").newInstance();
    }
}
