package com.chaocharliehuang.dadjokes.controllers;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.security.Principal;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;
import javax.validation.Valid;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chaocharliehuang.dadjokes.models.*;
import com.chaocharliehuang.dadjokes.services.*;
import com.chaocharliehuang.dadjokes.validators.UserValidator;

@Controller
public class DadJokes {
	
	private UserService userService;
	private JokeService jokeService;
	private UserValidator userValidator;
	
	public DadJokes(UserService userService, JokeService jokeService, UserValidator userValidator) {
		this.userService = userService;
		this.jokeService = jokeService;
		this.userValidator = userValidator;
	}
	
	@GetMapping("/")
	public String index(
			@Valid @ModelAttribute("user") User user, Model model,
			@RequestParam(value="error", required=false) String error,
			@RequestParam(value="logout", required=false) String logout) {
		if (error != null) {
			model.addAttribute("errorMessage", "Invalid credentials; please try again.");
		}
		if (logout != null) {
			model.addAttribute("logoutMessage", "Logout successful!");
		}
		return "index.jsp";
	}
	
	@GetMapping("/getImgflipAccount")
	@ResponseBody
	public String getImgflipAccount() {
		return "&username=CharlieHuang&password=dadjokes";
	}
	
	@GetMapping("/registration")
	public String registrationRedirect() {
		return "redirect:/";
	}
	
	@PostMapping("/registration")
	public String registration(
			@Valid @ModelAttribute("user") User user, BindingResult result, Model model) {
		userValidator.validate(user, result);
		if (result.hasErrors()) {
			return "index.jsp";
		} else {
			userService.saveUser(user);
			return "redirect:/home";
		}
	}
	
	@GetMapping("/home")
	public String home(Principal principal, Model model) {
		User currentUser = userService.findByUsername(principal.getName());
		model.addAttribute("currentUser", currentUser);
		model.addAttribute("jokes", jokeService.findAllJokesPaginated(0).getContent());
		return "index.jsp";
	}
	
	@PostMapping("/saveToImgur")
	public String saveToImgur(
			@RequestParam(value="imgflip_url") String imgflip_url,
			Principal principal) throws Exception {
		
		// REQUEST URL
		String imgurPostURL = "https://api.imgur.com/3/image";
		URL obj = new URL(imgurPostURL);
		HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();
		
		// HEADERS
		con.setRequestMethod("POST");
		con.setRequestProperty("Authorization", "Bearer e2c5c76c427583f311d734efa828e3082c7694aa");
		String urlParameters = "image=" + imgflip_url;
		
		// SEND REQUEST
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(urlParameters);
		wr.flush();
		wr.close();
		
		// READ RESPONSE
		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
		
		// GET IMGUR ID FROM RESPONSE
		JSONObject jsonResponse = new JSONObject(response.toString());
		JSONObject jsonData = jsonResponse.getJSONObject("data");
		String newImgurl = jsonData.getString("link");
		String imgurlID = newImgurl.substring(newImgurl.indexOf("http") + 19, newImgurl.indexOf(".jpg"));
		
		User currentUser = userService.findByUsername(principal.getName());
		Joke joke = new Joke(imgurlID);
		joke.setCreator(currentUser);
		jokeService.saveJoke(joke);
		
		return "redirect:/home";
	}
	
	@GetMapping("/users/{id}")
	public String userFavorites(@PathVariable("id") Long id, Principal principal, Model model) {
		User user = userService.findUserById(id);
		if (userService.findAllUsers().contains(user)) {
			model.addAttribute("user", user);
			model.addAttribute("currentUser", userService.findByUsername(principal.getName()));
			model.addAttribute("jokes", jokeService.findAllJokesByUser(id, 0).getContent());
			return "userFavorites.jsp";
		} else {
			return "redirect:/home";
		}
	}
	
	@GetMapping("/users/{id}/jokes/pages/{pageNumber}")
	@ResponseBody
	public String getUserJokesPerPage(
			@PathVariable("id") Long id,
			@PathVariable("pageNumber") int pageNumber,
			Principal principal) throws JSONException {
		User currentUser = userService.findByUsername(principal.getName());
		Page<Joke> jokes = (Page<Joke>) jokeService.findAllJokesByUser(id, pageNumber - 1);
		JSONObject jokesJSON = new JSONObject();
		for (Joke joke : jokes.getContent()) {
			JSONObject jokeJSON = new JSONObject();
			jokeJSON.put("jokeID", joke.getId());
			jokeJSON.put("imgurl", joke.getImgurl());
			jokeJSON.put("creatorID", joke.getCreator().getId());
			jokeJSON.put("creatorUsername", joke.getCreator().getUsername());
			jokeJSON.put("numberOfLikes", joke.getUsersLiked().size());
			
			if (joke.getCreator().getId() == currentUser.getId()) {
				jokeJSON.put("delete", true);
			}
			
			if (joke.getUsersLiked().contains(currentUser)) {
				jokeJSON.put("action", "Unlike");
			} else {
				jokeJSON.put("action", "Like");
			}
			jokesJSON.put(joke.getId().toString(), jokeJSON);
		}
		return jokesJSON.toString();
	}
	
	@GetMapping("/jokes/{id}/like")
	public String likeJoke(@PathVariable("id") Long id, Principal principal) {
		User currentUser = userService.findByUsername(principal.getName());
		Joke joke = jokeService.findJokeById(id);
		List<User> usersLiked = joke.getUsersLiked();
		if (!usersLiked.contains(currentUser)) {
			usersLiked.add(currentUser);
			joke.setUsersLiked(usersLiked);
			jokeService.saveJoke(joke);
		}
		return "redirect:/home";
	}
	
	@GetMapping("/jokes/{id}/unlike")
	public String unlikeJoke(@PathVariable("id") Long id, Principal principal) {
		User currentUser = userService.findByUsername(principal.getName());
		Joke joke = jokeService.findJokeById(id);
		List<User> usersLiked = joke.getUsersLiked();
		if (usersLiked.contains(currentUser)) {
			usersLiked.remove(currentUser);
			joke.setUsersLiked(usersLiked);
			jokeService.saveJoke(joke);
		}
		return "redirect:/home";
	}
	
	@GetMapping("/jokes/{id}/delete")
	public String deleteJoke(@PathVariable("id") Long id, Principal principal) {
		User currentUser = userService.findByUsername(principal.getName());
		Joke joke = jokeService.findJokeById(id);
		if (joke.getCreator() == currentUser) {
			jokeService.deleteJoke(id);
		}
		return "redirect:/home";
	}
	
	@GetMapping("/jokes/pages/{pageNumber}")
	@ResponseBody
	public String getJokesPerPage(
			@PathVariable("pageNumber") int pageNumber,
			Principal principal) throws JSONException {
		User currentUser = userService.findByUsername(principal.getName());
		Page<Joke> jokes = jokeService.findAllJokesPaginated(pageNumber - 1);
		JSONObject jokesJSON = new JSONObject();
		for (Joke joke : jokes.getContent()) {
			JSONObject jokeJSON = new JSONObject();
			jokeJSON.put("jokeID", joke.getId());
			jokeJSON.put("imgurl", joke.getImgurl());
			jokeJSON.put("creatorID", joke.getCreator().getId());
			jokeJSON.put("creatorUsername", joke.getCreator().getUsername());
			jokeJSON.put("numberOfLikes", joke.getUsersLiked().size());
			
			if (joke.getCreator().getId() == currentUser.getId()) {
				jokeJSON.put("delete", true);
			}
			
			if (joke.getUsersLiked().contains(currentUser)) {
				jokeJSON.put("action", "Unlike");
			} else {
				jokeJSON.put("action", "Like");
			}
			jokesJSON.put(joke.getId().toString(), jokeJSON);
		}
		return jokesJSON.toString();
	}

}
