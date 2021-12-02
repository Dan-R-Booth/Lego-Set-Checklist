<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
	</head>
	<body>
		<!-- This creates a textbox where users can enter a Lego set number and a button to search for the Lego set -->
		<form action="/set">
			<label>Set Number:</label>
			<input name="set_number" type="number"/>
			<label>-</label>
			<input name="set_variant" type="number" value="1"/>
		
			<input type="submit" value="Find"/>
		</form>
	</body>
</html>