<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>My Dad Jokes</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.1/css/bulma.min.css">
	<style>
		nav, footer {
			background-color: hsl(217, 71%, 53%);
			color: white;
			padding: 10px 20px;
		}
		
		a {
			color: hsl(217, 71%, 53%);
		}
		
		nav a, footer a {
			color: white;
			text-decoration: underline;
		}
		
		body {
		    display: flex;
		    min-height: 100vh;
		    flex-direction: column;
	    }
		
		main {
		  flex: 1 0 auto;
		}
	</style>
</head>
<body>

<main>

<div class="container has-text-centered">

	<nav class="level">

		<div class="level-left">
				
			<div class="level-item is-size-2">
				<h1><b>Dad Jokes</b></h1>
			</div>
	
		</div> <!-- end level-left -->
		
		<div class="level-right">
			<div class="level-item">
				<a href="/home">Home</a>
			</div>
		</div> <!-- end level-right -->
	
	</nav>

	<div class="level-item is-size-4">
		<h1><b>Dad Jokes created by ${user.username}:</b></h1>
		<br><br>
	</div>
	
	<c:if test="${!empty allJokes}">
		<c:forEach items="${allJokes}" var="joke">
			<p><img src="http://i.imgur.com/${joke.imgurl}.jpg"></p>
			<c:choose>
				<c:when test="${!joke.usersLiked.contains(currentUser)}">
					<a href="/jokes/${joke.id}/like">Like</a> | 
				</c:when>
				<c:otherwise>
					<a href="/jokes/${joke.id}/unlike">Unlike</a> | 
				</c:otherwise>
			</c:choose>
			
			${joke.usersLiked.size()} 
			<c:choose>
				<c:when test="${joke.usersLiked.size() == 1}">
					person likes 
				</c:when>
				<c:otherwise>
					people like 
				</c:otherwise>
			</c:choose>
			this
			
			<c:if test="${joke.creator == currentUser}">
				 | <a href="/jokes/${joke.id}/delete">Delete</a>
			</c:if>
			<br><br>
		</c:forEach>
	</c:if>
</main>
</div>

	<footer class="container has-text-centered">
		&copy; 2017 <a href="http://github.com/chaocharliehuang" target="_blank">
		Chao Charlie Huang</a> | 
		Built using Spring Boot, Bulma CSS, icanhazdadjoke API, Imgflip API, and Imgur API
	</footer>

</body>
</html>