package me.ko.springbootdeveloper;

/*
    MemberRepositoryTest를 만들었지만, 데이터 조회를 위해서
    입력된 데이터가 필요하기 때문에 테스트용 테이터를 추가할 예정
    test -> resources 우클릭하고, insert-members.sql 파일 생성
    작성 후(혹은 확인 후에) 코드 의미 :
        src/main/resources 폴더 내에 있는 data.sql 파일을 자동 실행 못하게 하는 코드
    이제 MemberRepositoryTest.java 파일 코드 작성
 */

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.jdbc.Sql;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class MemberRepositoryTest {

    @Autowired
    MemberRepository memberRepository;

    @Sql("/insert-members.sql")
    @Test
    void getAllMembers(){
        // when
        List<Member> members = memberRepository.findAll();
        // membersRepository는 상속받은 메소드명을 그대로 가져가니까
        // 우리가 직접 정의하는 영어가 아니라도 익숙해져야 한다.

        // then
        assertThat(members.size()).isEqualTo(3);
    }
}