<%-- Provides JSP tag library for the form --%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
	</head>
	<body>
		<h2>Search:</h2>
		
		<form:form action="/showSet" method="POST">
			<form:label path="number">Set Number:</form:label>
			<form:input path="number"/>
			
			<input type="submit"/>
		</form:form>
	</body>
</html>