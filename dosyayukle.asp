<% 	ysayi=0
	Set Upload = Server.CreateObject("Persits.Upload.1" ) ' Burada persitsi olu�turuyoruz 
	Upload.OverwriteFiles = True ' Dosya �zerine Yazmas�n Demek, E�er yazmas�n� istiyosan�z False b�l�m�n� True yap�n 
	Upload.SetMaxSize 10485761 ' Maksimum dosya b�y�kl��� Byte cinsinden 
	Upload.SaveVirtual "/yukleme/" ' Uploadklasoru isimli klas�re dosyan�z kaydediliyor, klasor ismini de�i�tirebiliriniz. 
	for each File in Upload.Files ' For D�ng�s�yle Kontrol Yapaca��z 
		if FILE.ext = ".csv" OR FILE.ext = ".CSV" or FILE.ext = ".cSV" or FILE.ext = ".Csv" Then
			dosyaadi = FILE.filename ' Dosya ismini almak i�in bu kodu kullanabilirsiniz
			Response.write ""&dosyaadi&" Ba�ar�yla Yuklendi.<br>"
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
			Response.write "�stenmeyen Dosya T�r�.<br>"
		end if 
	next 
	if ysayi>0 then
		session("dosyayukleme")="evet"
		Response.redirect "default.asp?dosyayukleme=evet"
	else
		session("dosyayukleme")="hay�r"
		Response.redirect "default.asp?dosyayukleme=hayir"
	end if
%> 