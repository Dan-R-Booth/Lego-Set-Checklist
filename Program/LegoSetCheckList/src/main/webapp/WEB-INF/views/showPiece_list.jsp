<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	</head>
	<body class="m-2">
		<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
		<div class="container-fluid border">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
				    <div class="col">
				        Piece Image:
				    </div>
				    <div class="col">
				      Piece Number:
				    </div>
				    <div class="col">
				      Piece Name:
				    </div>
				    <div class="col">
				      Piece Colour:
				    </div>
				    <div class="col">
				      Quantity:
				    </div>
				    <div class="col">
				      Quantity Found:
				    </div>
				</div>
		    </div>
		
		<!-- This creates a container using bootstrap, for every set in the pieces list and display the piece image, number, name, colour, quantity and the quantity found -->
		<c:forEach items="${piece_list.pieces}" var="Piece">
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border w">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
				<div class="row align-items-center my-3">
				    <div class="col">
				        <!-- The style width sets the percentage size the image will be on any screen -->
						<img src="${Piece.img_url}" alt="Image of the Lego Piece: ${Piece.name}" style="width: 50%" class="m-2">
				    </div>
				    <div class="col">
				      ${Piece.num}
				    </div>
				    <div class="col">
				      ${Piece.name}
				    </div>
				    <div class="col">
				      ${Piece.colour_name}
				    </div>
				    <div class="col">
				       ${Piece.quantity}
				    </div>
				    <div class="col">
				    
					<button type="button" class="btn btn-outline-primary btn-sm">-</button>
					<!--  -->
				     <input name="Piece_quantity_checked" type="number" value="${Piece.quantity_checked}" min=0 max="${Piece.quantity}" />
				    <button type="button" class="btn btn-outline-primary btn-sm">+</button>
				    </div>
				</div>
		    </div>
		</c:forEach>
	</body>
</html>