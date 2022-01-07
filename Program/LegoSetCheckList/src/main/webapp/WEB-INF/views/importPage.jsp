<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
	</head>
	<body class="m-2">
		<form method="POST" action="/openImport" enctype="multipart/form-data">
			<label>Choose a file containing a saved checklist to import</label>
			<br>
			<input type="file" name="importFile" accept=".csv">
			<br>
			<input type="submit" value="Import"/>
		</form>
         
         <c:if test="${error eq true}">
			<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ${message}</div>
		</c:if>
	</body>
</html>