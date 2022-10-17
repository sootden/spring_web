package org.zerock.service;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import java.util.List;

public interface BoardService {
    public void register(BoardVO board);
    public BoardVO get(Long bno);
    public boolean modify(BoardVO board);
    public boolean remove(Long bno);

//    public List<BoardVO> getList();
    public List<BoardVO> getList(Criteria cri);
    public int getTotal(Criteria cri);

    //게시물 조회시 가져오는 첨부파일들
    public List<BoardAttachVO> getAttachList(Long bno);
}
