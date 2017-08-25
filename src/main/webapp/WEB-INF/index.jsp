<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Dad Jokes</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.1/css/bulma.min.css">
	<style>
		#registration, #form_memegen, #form_save, #joke {
			display: none;
		}
		
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
		
		.joke_creation input[type=submit] {
			background-color: hsl(217, 71%, 53%);
			border-radius: 10px;
			padding: 10px;
			font-size: 100%;
			color: white;
		}
		
		#form_customjoke input[type=text] {
			width: 30%;
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
		
			<c:if test="${currentUser != null}">
				<div class="level-item">
					<h3>Howdy, ${currentUser.username}!</h3>
				</div>
			</c:if>
			
			<c:if test="${currentUser != null}">
				<div class="level-item">
					<a href="/users/${currentUser.id}">My Dad Jokes</a>
				</div>
				<div class="level-item">
					<form id="logoutForm" method="POST" action="/logout">
				        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				        <input type="submit" value="Logout" />
				    </form>
		    		</div>
			</c:if>
	
			<c:if test="${currentUser == null}">
			    
			    <c:if test="${errorMessage != null}">
				    <div class="level-item">
			        		<c:out value="${errorMessage}"></c:out>
			        </div>
			    </c:if>
			    		<div class="level-item">
					    <form method="POST" action="/">
				            <input type="text" id="username" name="username" placeholder="username">
				            <input type="password" id="password" name="password" placeholder="password">
					        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
					        <input type="submit" value="Login"/>
					    </form>
				    </div>
		    </c:if>
	    
	    </div> <!-- end level-right -->
   	
   	</nav>
    
	<c:if test="${currentUser == null}">
		<p><form:errors path="user.*"/></p>
	    <div id="registration">
		    <form:form method="POST" action="/registration" modelAttribute="user">
		            <form:input path="username" placeholder="username"/>
		            <form:password path="password" placeholder="password"/>
		            <form:password path="passwordConfirmation" placeholder="password confirmation"/>
		        <input type="submit" value="Register"/>
		    </form:form>
		</div>
		
		<p><a href="" id="register_dropdown">REGISTER to save your favorite Dad Jokes and share with others!</a></p>
		<br>
    </c:if>
	
	<div class="joke_creation">
	
		<form id="form_randomjoke">
			<input type="submit" value="Random Dad Joke">
		</form>
		
		<br>
		
		<form id="form_customjoke">
			<input class="input" type="text" name="toptext" placeholder="Top text">
			<input class="input" type="text" name="bottomtext" placeholder="Bottom text">
			<input type="submit" value="Generate Dad Joke">
		</form>
		
		<form id="form_memegen">
			<input type="hidden" id="memegen_template_id" name="template_id" value="">
			<input type="hidden" id="memegen_text0" name="text0" value="">
			<input type="hidden" id="memegen_text1" name="text1" value="">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			<input type="submit" value="">
		</form>
		
		<br>
		
		<div id="joke"></div>
	
		<c:if test="${currentUser != null}">
			<form id="form_save" action="/saveToImgur" method="POST">
				<input type="hidden" id="imgflip_url" name="imgflip_url" value="">
				<input type="submit" value="Save Dad Joke">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				<br><br>
			</form>
		</c:if>
	</div>
		
	<c:if test="${currentUser != null}">
		<div class="level-item is-size-4">
			<h1><b>Dad Jokes Feed</b></h1>
		</div>
		<c:forEach items="${allJokes}" var="joke">
			<p><a href="/users/${joke.creator.id}">${joke.creator.username}</a> created:</p>
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
</div> <!-- end container class -->
	
	<footer class="container has-text-centered">
		&copy; 2017 <a href="http://github.com/chaocharliehuang" target="_blank">
		Chao Charlie Huang</a> | 
		Built using Spring Boot, Bulma CSS, icanhazdadjoke API, Imgflip API, and Imgur API
	</footer>
	

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script>
		function getRandomTemplateID() {
			var template_ids = [
				"111962984", // rick and carl
				"111778475", // danny tanner
				"111962581", // homer simpson
				"111963291", // peter griffin
				"111963824", // walter white
				"111964491", // ned stark
				"111964907", // darth vader
				"111965293", // philip banks
				"111985361" // bluths
				];
			var randomIndex = Math.floor(Math.random()*template_ids.length);
			return template_ids[randomIndex];
		}
		
		$("#register_dropdown").click(function(e) {
			e.preventDefault();
			$("#registration").slideToggle();
		});
	
		$("#form_randomjoke").submit(function(e) {
			e.preventDefault();
			$.ajax({
				url: "https://icanhazdadjoke.com/",
				method: "GET",
				dataType: "text",
				success: function(res) {
					if (res.indexOf("?") !== -1) {
						var strArr = res.split("? ");
						strArr[0] += "?";
					} else {
						var strArr = res.split(". ");
						if (strArr.length > 1) {
							strArr[0] += ".";
						}
					}
					if (strArr.length > 2) {
						for (var i = 2; i < strArr.length; i++) {
							strArr[1] += " " + strArr[i];
						}
						strArr.length = 2;
					}
					
					if (strArr.length > 1) {
						$("#memegen_text0").val(strArr[0]);
						$("#memegen_text1").val(strArr[1]);
					} else {
						$("#memegen_text1").val(strArr[0]);
					}
					$("#memegen_template_id").val(getRandomTemplateID());
					
					$("#form_memegen").submit();
				}
			});
		});
		
		$("#form_customjoke").submit(function(e) {
			e.preventDefault();
			var form_customjoke = $(this).serializeArray();
			$("#memegen_text0").val(form_customjoke[0]["value"]);
			$("#memegen_text1").val(form_customjoke[1]["value"]);
			$("#memegen_template_id").val(getRandomTemplateID());
			$("#form_memegen").submit();
		});
		
		$("#form_memegen").submit(function(e) {
			e.preventDefault();
			$.ajax({
				url: "/getImgflipAccount",
				method: "GET",
				success: function(info) {
					$.ajax({
						url: "https://api.imgflip.com/caption_image",
						method: "POST",
						data: $("#form_memegen").serialize() + info,
						success: function(res) {
							$("#joke").hide();
							$("#joke").html("<img src=" + res.data.url +"><br>");
							$("#imgflip_url").val(res.data.url);
							$("#form_save").show();
							$("#joke").fadeIn("slow");
						}
					});
				}
			});
		});
		
	</script>
</body>
</html>