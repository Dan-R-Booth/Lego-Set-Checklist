<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
		<script type="text/javascript">
		
			function setup() {
				var text = "";
				const num_items = "${num_items}";
				
				var element = "piece_quantity_checked_";
				for (let id = 0; id < num_items; id++) {
					var quantity = document.getElementById("piece_quantity_checked_" + id).max;
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					if (quantityChecked == 0) {
						document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = true;
						document.getElementById("increaseQuantityCheckedButton_" + id).disabled = false;
					}
					else if (quantityChecked == quantity) {
						document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = false;
						document.getElementById("increaseQuantityCheckedButton_" + id).disabled = true;
					}
				}
				document.getElementById("test").value = text;
			}
			
			function decreaseQuantityChecked(id) {
				var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
				quantityChecked --;
					
				 if (quantityChecked == 0) {
					document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = true;
				 }
				 document.getElementById("increaseQuantityCheckedButton_" + id).disabled = false;
				 
				 document.getElementById("piece_quantity_checked_" + id).value = quantityChecked;
			}
		
			function increaseQuantityChecked(id) {
				var quantity = document.getElementById("piece_quantity_checked_" + id).max;
				var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
				quantityChecked ++;
				
				 document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = false;
				 if (quantityChecked == quantity) {
					document.getElementById("increaseQuantityCheckedButton_" + id).disabled = true;
				 }
				 
				 document.getElementById("piece_quantity_checked_" + id).value = quantityChecked;
			}
		
			function saveProgress() {
				var text = "";
				const num_items = "${num_items}";
				
				var element = "piece_quantity_checked_";
				for (let id = 0; id < num_items; id++) {
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					text = text.concat(quantityChecked);
				}
				document.getElementById("test").value = text;
			}
		</script>
		
	</head>
	<body class="m-2" onload="setup()">
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
		<c:forEach items="${piece_list.pieces}" var="piece" varStatus="loop">
				<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
				<div id="piece_${loop.index}" class="container-fluid border">
					<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
					<div class="row align-items-center my-3">
					    <div class="col">
					        <!-- The style width sets the percentage size the image will be on any screen -->
							<img src="${piece.img_url}" alt="Image of the Lego Piece: ${piece.name}" style="width: 50%" class="m-2">
					    </div>
					    <div class="col">
					    	${piece.num}
					    </div>
					    <div class="col">
					     	${piece.name}
					    </div>
					    <div class="col">
					    	${piece.colour_name}
					    </div>
					    <div id="piece_quantity_${loop.index}" class="col">
					       ${piece.quantity}
					    </div>
					    <div class="col">
					    	<button id="decreaseQuantityCheckedButton_${loop.index}" name="${loop.index}" type="button" class="btn btn-primary btn-sm" onclick="decreaseQuantityChecked(this.name)"> <i class="fa fa-minus"></i></button>
							<!-- Displays the quantity found and is disabled so the value can only be changed by the buttons -->
						    <input id="piece_quantity_checked_${loop.index}" type="number" value="${piece.quantity_checked}" min=0 max="${piece.quantity}" disabled />
						    <button id="increaseQuantityCheckedButton_${loop.index}" name="${loop.index}" type="button" class="btn btn-primary btn-sm" onclick="increaseQuantityChecked(this.name)"> <i class="fa fa-plus"></i></button>
					    </div>
					</div>
			    </div>
			<!-- This hides any pieces that are classed as spare pieces for the Lego set and are therefore not needed to build the set -->
			<c:if test="${piece.spare eq true}">
				<script type="text/javascript">
					document.getElementById("piece_${loop.index}").style.display = "none";
				</script>
			</c:if>
		</c:forEach>
		
		<div class="my-5">
			<button type="button" id="save" onclick="saveProgress()" class="btn btn-primary"> <i class="fa fa-save"></i> Save CheckList</button>
        </div>
        ${set.name}
        <textarea id="test" rows="5" cols="160"></textarea>
	</body>
</html>