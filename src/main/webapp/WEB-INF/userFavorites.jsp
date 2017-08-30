<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Dad Jokes created by ${user.username}</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.1/css/bulma.min.css">
	<style>
		nav, footer {
			background-color: hsl(217, 71%, 53%);
			color: white;
			padding: 10px 20px;
		}
		
		#logo {
			height: 50px;
		}
		
		#bubbles {
			height: 35px;
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

<main class="has-text-centered">
	
	<nav>
	
		<div class="container level">

			<div class="level-left">
			
				<div class="level-item">
					<a href="/home">
						<img src="http://i.imgur.com/XQE3hpU.png" alt="logo" id="logo">
					</a>
				</div>
					
				<div class="level-item is-size-2">
					<h1><b>Dad Jokes</b></h1>
				</div>
		
			</div> <!-- end level-left -->
			
			<div class="level-right">
				<div class="level-item">
					<a href="/home">Home</a>
				</div>
			</div> <!-- end level-right -->
		
		</div>
	
	</nav>

	<div class="level-item is-size-4">
		<h1><b>Dad Jokes created by ${user.username}:</b></h1>
		<br><br>
	</div>
	
	<c:if test="${!empty jokes}">
		<div id="jokes_feed"></div>
	</c:if>

</main>

	<footer class="has-text-centered">
		&copy; 2017 <a href="http://github.com/chaocharliehuang" target="_blank">
		Chao Charlie Huang</a> | 
		Built using Spring Boot, MySQL, icanhazdadjoke API, Imgflip API, Imgur API, and Bulma CSS
	</footer>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script>
		$(document).ready(function () {
			$.ajax({
				url: "/users/" + ${user.id} + "/jokes/pages/1",
				method: "GET",
				success: function(res) {
					var jokesFeedHTML = '';
					var resObject = JSON.parse(res);
					for (var i = 0; i < resObject.length; i++) {
						jokesFeedHTML += '<p><img src="http://i.imgur.com/';
						jokesFeedHTML += resObject[i].imgurl + '.jpg"></p><p>';
						
						if (resObject[i].action === "Like") {
							jokesFeedHTML += '<a href="/jokes/' + resObject[i].jokeID;
							jokesFeedHTML += '/like">Like</a>';
						} else {
							jokesFeedHTML += '<a href="/jokes/' + resObject[i].jokeID;
							jokesFeedHTML += '/unlike">Unlike</a>';
						}
						jokesFeedHTML += ' | ' + resObject[i].numberOfLikes + ' total likes';
						
						if (resObject[i].delete) {
							jokesFeedHTML += ' | <a href="/jokes/' + resObject[i].jokeID;
							jokesFeedHTML += '/delete">Delete</a>';
						}
						
						jokesFeedHTML += '</p><br>';
					}
					$("#jokes_feed").append(jokesFeedHTML);
				}
			});
		});
		
		var page = 1;
		$(window).scroll(function() {
	        if($(window).scrollTop() + $(window).height() == $(document).height()) {
	            page++;
	            $.ajax({
	    				url: "/users/" + ${user.id} + "/jokes/pages/" + page,
	    				method: "GET",
	    				success: function(res) {
	    					var jokesFeedHTML = '';
	    					var resObject = JSON.parse(res);
	    					for (var i = 0; i < resObject.length; i++) {
	    						jokesFeedHTML += '<p><img src="http://i.imgur.com/';
	    						jokesFeedHTML += resObject[i].imgurl + '.jpg"></p><p>';
	    						
	    						if (resObject[i].action === "Like") {
	    							jokesFeedHTML += '<a href="/jokes/' + resObject[i].jokeID;
	    							jokesFeedHTML += '/like">Like</a>';
	    						} else {
	    							jokesFeedHTML += '<a href="/jokes/' + resObject[i].jokeID;
	    							jokesFeedHTML += '/unlike">Unlike</a>';
	    						}
	    						jokesFeedHTML += ' | ' + resObject[i].numberOfLikes + ' total likes';
	    						
	    						if (resObject[i].delete) {
	    							jokesFeedHTML += ' | <a href="/jokes/' + resObject[i].jokeID;
	    							jokesFeedHTML += '/delete">Delete</a>';
	    						}
	    						
	    						jokesFeedHTML += '</p><br>';
	    					}
	    					$("#jokes_feed").append(jokesFeedHTML);
	    				}
	    			});
	        }
	    });
	</script>

</body>
</html>