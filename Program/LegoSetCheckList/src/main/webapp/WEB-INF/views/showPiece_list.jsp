<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	</head>
	<body class="m-2">
		<c:forEach items="${piece_list.pieces}" var="Piece">
			<p>
				Piece Number: ${Piece.num}
				<br>
				Piece Name: ${Piece.name}
				<br>
				<!-- The style width sets the percentage size the image will be on any screen -->
				<img src="${Piece.img_url}" alt="Image of the Lego Piece: ${Piece.name}" style="width: 5%" class="m-2">
				<br>
				Piece Colour: ${Piece.colour_name}
				<br>
				Quantity: ${Piece.quantity}
				<br>
				Quantity Found: ${Piece.quantity_checked}
			</p>
		</c:forEach>
	</body>
</html>