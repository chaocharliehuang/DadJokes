package com.chaocharliehuang.dadjokes.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import com.chaocharliehuang.dadjokes.models.Joke;

@Repository
public interface JokeRepository extends CrudRepository<Joke, Long>, PagingAndSortingRepository<Joke, Long> {
	List<Joke> findTop20ByOrderByIdDesc();
	List<Joke> findByCreatorIdOrderByIdDesc(Long id);
}
