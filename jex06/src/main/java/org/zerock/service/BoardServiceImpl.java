package org.zerock.service;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import java.util.List;

/*
    @Service : 계층 구조상 주로 비즈니스 영역을 담당하는 객체임을 표시
    @AllArgsConstructor : 모든 파라미터를 이용하는 생성자를 만드는 어노테이션 (스프링 4.3 이상)
 */
@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
   //게시물 관련 Mapper
    @Setter(onMethod_ = @Autowired)
    private BoardMapper mapper;

    //첨부파일 관련 Mapper
    @Setter(onMethod_ = @Autowired)
    private BoardAttachMapper attachMapper;

    //게시물 등록시, tbl_board테이블과 tbl_attach테이블에 insert작업이 실행되어야함 -> 하나의 트랜잭션으로 설계
    @Transactional
    @Override
    public void register(BoardVO board) {
        log.info("register..."+board);
        mapper.insertSelectKey(board);

        if(board.getAttachList() == null || board.getAttachList().size() <= 0){
            return;
        }

        //첨부파일 등록 : bno설정 후 테이블에 insert
        board.getAttachList().forEach(attach ->{
            attach.setBno(board.getBno());
            attachMapper.insert(attach);
        });
    }

    @Override
    public BoardVO get(Long bno) {
        log.info("get..." + bno);
        return mapper.read(bno);
    }

    @Transactional
    @Override
    public boolean modify(BoardVO board) {
        log.info("modify..." + board);
        //첨부파일 수정방법 : 해당 게시물의 첨부파일들을 전부 삭제 후 등록
        attachMapper.deleteAll(board.getBno());

        boolean modifyResult = mapper.update(board) == 1;

        if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0){
            //첨부파일 등록
            board.getAttachList().forEach(attach -> {
                attach.setBno(board.getBno());
                attachMapper.insert(attach);
            });
        }
        return mapper.update(board) == 1;
    }

    @Override
    public boolean remove(Long bno) {
        log.info("remove..." + bno);
        attachMapper.deleteAll(bno);
        return mapper.delete(bno) == 1;
    }

//    @Override
//    public List<BoardVO> getList() {
//        log.info("getList.......");
//        return mapper.getList();
//    }

    @Override
    public List<BoardVO> getList(Criteria cri){
        log.info("get List with criteria: "+cri);
        return mapper.getListWithPaging(cri);
    }

    @Override
    public int getTotal(Criteria cri){
        log.info("get total count");
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<BoardAttachVO> getAttachList(Long bno){
        log.info("get Attach list by bno"+ bno);
        return attachMapper.findByBno(bno);
    }
}
