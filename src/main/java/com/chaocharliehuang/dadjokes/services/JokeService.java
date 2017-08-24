package com.chaocharliehuang.dadjokes.services;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chaocharliehuang.dadjokes.models.Joke;
import com.chaocharliehuang.dadjokes.repositories.JokeRepository;

@Service
@Transactional
public class JokeService {

	private static final int PAGE_SIZE = 5;
	
	private JokeRepository jokeRepository;
	
	public JokeService(JokeRepository jokeRepository) {
		this.jokeRepository = jokeRepository;
	}
	
	public Joke findJokeById(Long id) {
		return jokeRepository.findOne(id);
	}
	
	public void saveJoke(Joke joke) {
		jokeRepository.save(joke);
	}
	
	public void deleteJoke(Long id) {
		jokeRepository.delete(id);
	}
	
	public List<Joke> findAllJokes() {
		return jokeRepository.findTop20ByOrderByIdDesc();
	}
	
	public List<Joke> findAllJokesByUser(Long id) {
		return jokeRepository.findByCreatorIdOrderByIdDesc(id);
	}
	
	public Page<Joke> findAllJokesPaginated(int pageNumber) {
		PageRequest pageRequest = new PageRequest(pageNumber, PAGE_SIZE, Sort.Direction.DESC, "id");
		return jokeRepository.findAll(pageRequest);
	}
}
