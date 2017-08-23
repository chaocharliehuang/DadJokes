package com.chaocharliehuang.dadjokes.services;

import org.springframework.stereotype.Service;

import com.chaocharliehuang.dadjokes.models.Joke;
import com.chaocharliehuang.dadjokes.repositories.JokeRepository;

@Service
public class JokeService {

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
}
