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
		#form_memegen {
			display: none;
		}
		
		#form_save {
			display: none;
		}
	</style>
</head>
<body>
	<c:if test="${currentUser != null}">
		<h1>Hello ${currentUser.username}</h1>
		<form id="logoutForm" method="POST" action="/logout">
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	        <input type="submit" value="Logout!" />
	    </form>
	    <br>
	</c:if>

	<c:if test="${currentUser == null}">
		<c:if test="${logoutMessage != null}">
	        <c:out value="${logoutMessage}"></c:out>
	        <br><br>
	    </c:if>
		<h1>Register</h1>
	    <p><form:errors path="user.*"/></p>
	    <form:form method="POST" action="/registration" modelAttribute="user">
	        <p>
	            <form:label path="username">Username:</form:label>
	            <form:input path="username"/>
	        </p>
	        <p>
	            <form:label path="password">Password:</form:label>
	            <form:password path="password"/>
	        </p>
	        <p>
	            <form:label path="passwordConfirmation">Password Confirmation:</form:label>
	            <form:password path="passwordConfirmation"/>
	        </p>
	        <input type="submit" value="Register"/>
	    </form:form>
		
		<br>
		
		<h1>Login</h1>
	    <c:if test="${errorMessage != null}">
	        <c:out value="${errorMessage}"></c:out>
	    </c:if>
	    <form method="POST" action="/">
	        <p>
	            <label for="username">Username:</label>
	            <input type="text" id="username" name="username"/>
	        </p>
	        <p>
	            <label for="password">Password</label>
	            <input type="password" id="password" name="password"/>
	        </p>
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	        <input type="submit" value="Login"/>
	    </form>
	    
	    <br>
    </c:if>
	
	<form id="form_randomjoke">
		<input type="submit" value="Random Dad Joke">
	</form>
	
	<br>
	
	<form id="form_customjoke">
		<input type="text" name="toptext" placeholder="Top text">
		<input type="text" name="bottomtext" placeholder="Bottom text">
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
			<input type="submit" value="Save to Favorites">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		</form>
	</c:if>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script>
		function getRandomTemplateID() {
			var template_ids = [
				"11557802", // rick and carl
				"111778475", // danny tanner
				"111781774", // homer simpson
				"111782030" // peter griffin
				];
			var randomIndex = Math.floor(Math.random()*template_ids.length);
			return template_ids[randomIndex];
		}
	
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
							$("#joke").html("<img src=" + res.data.url +"><br><br>");
							$("#imgflip_url").val(res.data.url);
							$("#form_save").show();
						}
					});
				}
			});
		});
		
	</script>
</body>
</html>