<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
		<script type="text/javascript">
			
			// This saves all the changes to Piece quantity found to the class
			function textSearch() {
				var text = document.getElementById("text_search").value;
				
				if (text == "") {
					document.getElementById("text_search").setAttribute("class", "form-control col-md-3 is-invalid")
					document.getElementById("text_searchEmptyHelp").setAttribute("class", "alert alert-danger")
				}
				else {					
					window.location = "/sets?text=" + text;
				}
			}
		</script>
	</head>
	<body class="m-2">
		<p>Find a Lego Set by entering a Set Number</p>
	
		<!-- This creates number boxes where users can enter a Lego set number and variant number (at least 1) and a button to find the Lego set -->
		<form action="/set">
			<label>Set Number: </label>
			<input id="set_number" name="set_number" type="number"/>
			<label>-</label>
			<input id="set_variant" name="set_variant" type="number" value="1" min="1"/>
		
			<input type="submit" value="Find"/>
		</form>
		
		<p>Or by searching for a set from a list of sets</p>
		
		<!-- This creates number boxes where users can enter a Lego set number and variant number (at least 1) and a button to find the Lego set -->
		<form action="/sets">

				<input id="text_search" class="form-control col-md-3" name="text_search" type="text" placeholder="Search for Lego Set"/>

			<div class="row m-1">
				<div id="text_searchEmptyHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Search Box cannot be empty</div>
			</div>
		
			<input type="button" value="Search" onclick="textSearch()"/>
		</form>
	</body>
</html>