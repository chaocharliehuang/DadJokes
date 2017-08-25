package com.chaocharliehuang.dadjokes.services;

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
	
	public Page<Joke> findAllJokesByUser(Long id, int pageNumber) {
		PageRequest pageRequest = new PageRequest(pageNumber, PAGE_SIZE, Sort.Direction.DESC, "id");
		return jokeRepository.findByCreatorIdOrderByIdDesc(id, pageRequest);
	}
	
	public Page<Joke> findAllJokesPaginated(int pageNumber) {
		PageRequest pageRequest = new PageRequest(pageNumber, PAGE_SIZE, Sort.Direction.DESC, "id");
		return jokeRepository.findAll(pageRequest);
	}
}
