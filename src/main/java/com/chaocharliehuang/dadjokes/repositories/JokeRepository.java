package com.chaocharliehuang.dadjokes.repositories;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import com.chaocharliehuang.dadjokes.models.Joke;

@Repository
public interface JokeRepository extends CrudRepository<Joke, Long>, PagingAndSortingRepository<Joke, Long> {
	Page<Joke> findByCreatorIdOrderByIdDesc(Long id, Pageable pageable);
}
