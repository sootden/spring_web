package org.zerock.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import java.util.List;

public interface BoardMapper {
//    @Select("select * from tbl_board where bno > 0")
    public List<BoardVO> getList();


    public List<BoardVO> getListWithPaging(Criteria cri);

    //Create(insert)
        //자동으로 PK값이 정해지는 경우, 2가지 방식으로 처리
        //1) insert만 처리되고 생성된 PK의 값을 알 필요가 없는 경우 -> @Insert 실행
    public void insert(BoardVO board);
        //2) insert를 실행하고 생성된 PK의 값을 알 필요가 있는 경우 -> @SelectKey 실행
    public void insertSelectKey(BoardVO board);

    //Read(select)
    public BoardVO read(Long bno);

    //Delete
    public int delete(Long bno);

    //Update
    public int update(BoardVO board);

    public int getTotalCount(Criteria cri);

    public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);

}
