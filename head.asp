	<meta http-equiv="Content-Language" content="tr" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-9" />
	<link rel="stylesheet" href="bootstrap/css/bootstrap.css">
	<link rel="shortcut icon" href="img/favicon.png" type="image/x-icon" />
	<link type="text/css" href="style.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<title>Mühendislik Projesi Ödev 4</title>
	<!--#include file="bag.asp"-->
	<!--#include file="func.asp"-->
	<script src="js/jquery.min.js"></script>
	<script src="bootstrap/js/bootstrap.js"></script>
	<script>
	$(document).ready(function(){
		$("i.arkadas").click(function(){
			$("div.arkadas").toggle("slow");
		});
		$("i.profil").click(function(){
			$("div.profil").toggle("slow");
		});
		$("i.liste").click(function(){
			$("div.liste").toggle("slow");
		});	
		$("i.arkadaslar").click(function(){
			$("div.arkadaslar").toggle("slow");
		});	
		$("i.oneri").click(function(){
			$("div.oneri").toggle("slow");
		});
		$("i.sononeri").click(function(){
			$("div.sononeri").toggle("slow");
		});
		$('#myModal').on('shown.bs.modal', function () {
			$('#myInput').trigger('focus')
		})
	});
</script>