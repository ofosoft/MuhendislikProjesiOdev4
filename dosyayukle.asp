<% 	ysayi=0
	Set Upload = Server.CreateObject("Persits.Upload.1" ) ' Burada persitsi oluþturuyoruz 
	Upload.OverwriteFiles = True ' Dosya Üzerine Yazmasýn Demek, Eðer yazmasýný istiyosanýz False bölümünü True yapýn 
	Upload.SetMaxSize 10485761 ' Maksimum dosya büyüklüðü Byte cinsinden 
	Upload.SaveVirtual "/yukleme/" ' Uploadklasoru isimli klasöre dosyanýz kaydediliyor, klasor ismini deðiþtirebiliriniz. 
	for each File in Upload.Files ' For Döngüsüyle Kontrol Yapacaðýz 
		if FILE.ext = ".csv" OR FILE.ext = ".CSV" or FILE.ext = ".cSV" or FILE.ext = ".Csv" Then
			dosyaadi = FILE.filename ' Dosya ismini almak için bu kodu kullanabilirsiniz
			Response.write ""&dosyaadi&" Baþarýyla Yuklendi.<br>"
			ysayi=ysayi+1
			if ysayi=1 then
				session("ogrencinetwork")="/yukleme/"&dosyaadi
			elseif ysayi=2 then
				session("ogrenciprofil")="/yukleme/"&dosyaadi
			else
				session("ogrencilistesi")="/yukleme/"&dosyaadi
			end if	
		else
			File.Delete
			Response.write "Ýstenmeyen Dosya Türü.<br>"
		end if 
	next 
	if ysayi>0 then
		session("dosyayukleme")="evet"
		Response.redirect "default.asp?dosyayukleme=evet"
	else
		session("dosyayukleme")="hayýr"
		Response.redirect "default.asp?dosyayukleme=hayir"
	end if
%> 