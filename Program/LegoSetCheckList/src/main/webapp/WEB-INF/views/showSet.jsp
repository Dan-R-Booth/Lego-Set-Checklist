<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	</head>
	<body class="m-2">
		<p>
			Set Number: ${set.num}
			<br>
			Set Name: ${set.name}
			<br>
			Set Image URL: ${set.img_url}
			<br>
			<!-- The style width sets the percentage size the image will be on any screen -->
			<img src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="width: 45%" class="m-2">
			<br>
			Year Released: ${set.year}
			<br>
			Theme: ${set.theme}
			<br>
			Number of pieces:   ${set.num_pieces}
		</p>
			
	</body>
</html>