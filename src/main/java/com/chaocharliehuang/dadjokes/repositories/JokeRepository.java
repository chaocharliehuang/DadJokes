package com.chaocharliehuang.dadjokes.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.chaocharliehuang.dadjokes.models.Joke;

@Repository
public interface JokeRepository extends CrudRepository<Joke, Long> {

}
