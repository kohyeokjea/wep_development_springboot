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

    /*
        이상의 코드는 멤버 전체를 찾고, 그 리스트의 사이즈가 3인지를 확인하는 테스트

        이하의 코드는 id 2인 멤버를 찾아보도록 한다.
        ex)
        SELECT * FROM member WHERE id = 2;
        member라는 테이블의 모든 컬럼을 조회하는데, id가 2인 객체의 값들을 보여달라.
        FROM members,           *(aterisk :all), WHERE id = 2,      SELECT
     */
    @Sql("/insert-members.sql")
    @Test
    void getMemberById(){
        // when
        Member member = memberRepository.findById(2L).get();        // 2L에서 L의 의미 : Long

        // then
        assertThat(member.getName()).isEqualTo("B");
    }

    /*
        이제는 id가 아니라 name으로 찾기로 해보겠다.
        id = 기본키
        name의 경우에는 컬럼이 있을 수도 없을 수도 있기 때문에 JPA에서 기본으로 name을 찾아주는 메서드가 없음

        필수 컬럼이 아닌 것을 조건으로 검색을 하기 위해서는 MemberRepository.java에서
        메서드를 추가할 필요가 있다.

        MemberRepository.java로 이동

        MemberRepository에 findByName 정의 후에 이하에 작성
     */
    @Sql("/insert-members.sql")
    @Test
    void getMemberByName() {    // MemberRepository.java에는 findByName()이었다는 점에 주목
        // when
        Member member = memberRepository.findByName("C").get();

        // then
        assertThat(member.getId()).isEqualTo(3);
    }
    /*
        이상과 같이 MemberRepository.java에 method를 정의하는 것을 '쿼리 메서드'
        일반적인 경우 JPA가 정해준 메서드 이름 규칙을 따르면 쿼리문을 특별히 구현하지 않아도
        메서드처럼 사용할 수 있음(즉 자바만으로 컨트롤이 가능하다는 의미)

        이상의 메서드를 SQL로 작성할 경우
        SELECT * FROM member WHERE name = 'C';

        지금까지 조회 관련 메서드
        전체 조회 -> findAll()
        아이디로 조회 -> findById()
        특정 컬럼으로 조회(name) -> 쿼리 메서드 명명 규칙에 맞게 정의 후에 사용(find / get 차이)

        추가 / 삭제 메서드

        INSERT INTO member (id, name) VALUES (1, 'A'); 라는 쿼리가 있다고 가정했을 때
        JPA에서는 save()라는 메서드를 사용
     */

    @Test       // @Sql애너테이션을 달지 않음. 이 메서드에서 1, 'A'에 해당하는 객체를 저장할거라서
    void saveMember(){
        //given
        Member member = new Member(1L, "A");

        // when
        memberRepository.save(member);      // save가 자동완성됐다는 점에도 주목해야 한다.

        // then
        assertThat(memberRepository.findById(1L).get().getName()).isEqualTo("A");
    }

    /*
        이상의 코드는 하나의 멤버 객체를 추가하는 메서드

        만약 여러 엔티티를 한꺼번에 저장하고 싶다면 saveAll() 메서드를 사용 가능
     */

    @Test
    void saveMembers(){
        // given - 다수의 객체를 저장할 예정이므로 collections를 사용할 거다. -> List
        List<Member> members = List.of(new Member(2L, "홍길동"),
                new Member(3L, "고길동"));

        // when
        memberRepository.saveAll(members);      // members라는 list를 전체 저장

        // then
        assertThat(memberRepository.findAll().size()).isEqualTo(2);
    }

    /*
        삭제 관련
        예를 들어서 id = 2인 멤버를 삭제 할 때의 SQL
        DELETE FROM member WHERE id = 2;

        JPA에서는 deleteById()를 통해 레토드를 삭제 가능.
        아까 전에 추가와는 달리 @Sql 사용할 예정
     */
    @Sql("/insert-members.sql")
    @Test
    void deleteMemberById() {
        // when
        memberRepository.deleteById(2L);        // 여기서 이미 삭제 됨

        // then                                 -> 2L에 해당하는 객체를 찾았을 때 empty인지 확인
        assertThat(memberRepository.findById(2L).isEmpty()).isTrue();
    }
}

