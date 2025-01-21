package me.ko.springbootdeveloper.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import me.ko.springbootdeveloper.domain.Article;
import me.ko.springbootdeveloper.dto.AddArticleRequest;
import me.ko.springbootdeveloper.dto.UpdateArticleRequest;
import me.ko.springbootdeveloper.repository.BlogRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class BlogService {

    private final BlogRepository blogRepository;

    public Article save(AddArticleRequest request, String username) {
        return blogRepository.save(request.toEntity(username));
    }

    public List<Article> findAll() {
        return blogRepository.findAll();
    }


    public Article findById(long id) {
        return blogRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("not found: "+ id));    // 람다식
    }

//    public void delete(long id) {
//        blogRepository.deleteById(id);
//    }
//
//    @Transactional
//    public Article update(long id, UpdateArticleRequest request) {
//        Article article = blogRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("not found : " + id));
//
//        article.update(request.getTitle(), request.getContent());
//
//        return article;
//    }

    public  void delete(long id) {
        Article article = blogRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("not found : " + id));

        authorizeArticleAuthor(article);
        blogRepository.delete(article);
    }

    @Transactional
    public Article update(long id, UpdateArticleRequest request) {
        Article article = blogRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("not found : " + id));

        authorizeArticleAuthor(article);
        article.update(request.getTitle(), request.getContent());

        return article;
    }

    private void authorizeArticleAuthor(Article article) {
        String userName = SecurityContextHolder.getContext().getAuthentication().getName();
        if(!article.getAuthor().equals(userName)) {
            throw new IllegalArgumentException("not authorized");
        }
    }

}
