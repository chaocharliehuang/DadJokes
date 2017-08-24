<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>My Dad Jokes</title>
</head>
<body>
	<a href="/home">Home</a>
	<h1>Dad Jokes created by ${user.username}</h1>
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
			<!-- <br><br> -->
		</c:forEach>
	</c:if>
</body>
</html>