<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	</head>
	<body class="m-2">
		<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
		<div class="container-fluid border">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
				    <div class="col">
				        <p class="h6">Minifigure Image:</p>
				    </div>
				    <div class="col">
				     	<p class="h6">Minifigure Number:</p>
				    </div>
				    <div class="col">
				    	<p class="h6">Minifigure Name:</p>
				    </div>
				    <div class="col">
				    	<p class="h6">Quantity:</p>
				    </div>
				    <div class="col">
				    	<p class="h6">Quantity Found:</p>
				    </div>
				    <div class="col">
				    	<p class="h6">Pieces:</p>
				    </div>
				</div>
		    </div>
		
		<!-- This creates a container using bootstrap, for every set in the pieces list and display the piece image, number, name, colour, quantity and the quantity found -->
		<c:forEach items="${minifigures}" var="minifigure">
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
				<div class="row align-items-center my-3">
				    <div class="col">
				        <!-- The style width sets the percentage size the image will be on any screen -->
						<img src="${minifigure.img_url}" alt="Image of the Lego Minifigure: ${minifigure.name}" style="width: 80%" class="m-2">
				    </div>
				    <div class="col">
				    	${minifigure.num}
				    </div>
				    <div class="col">
				    	${minifigure.name}
				    </div>
				    <div class="col">
				      	${minifigure.quantity}
				    </div>
				    <div class="col">
				    
						<button type="button" class="btn btn-primary btn-sm"> <i class="fa fa-minus"></i></button>
						<!--  -->
					    	<input name="Minifigure_quantity_checked" type="number" value="${minifigure.quantity_checked}" min=0 max="${minifigure.quantity}" />
					    <button type="button" class="btn btn-primary btn-sm"> <i class="fa fa-plus"></i></button>
				    </div>
				    <div  class="col">
				    	<a href="/set/${set_number}/minifigures/${minifigure.num}/pieces">Pieces</a>
				    </div>
				</div>
		    </div>
		</c:forEach>
	</body>
</html>