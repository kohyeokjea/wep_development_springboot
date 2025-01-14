package me.ko.springbootdeveloper.dto;

import lombok.Getter;
import me.ko.springbootdeveloper.domain.Article;

@Getter
public class ArticleListViewResponse {
    private final  Long id;
    private final String title;
    private final String content;

    public ArticleListViewResponse(Article article) {
        this.id = article.getId();
        this.title = article.getTitle();
        this.content = article.getContent();
    }
    /*
        controller 패키지에
        BlogViewController 파일 만든다.
     */
}
