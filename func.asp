<%
Function Expo(gelen)
	Expo=1/(1+Exp(-gelen))
End Function

Function oneriOlasilikHesapla(adet)
	Dim B(16)	' katsayýlar matrisi
	Dim Bg(16) 	' geçici katsayýlar matrisi
	Dim Bad(15) ' arkadaþlýk matrisi anket dizisi
	B(0)=1
	' katsayýlar matrisi 1 ile dolduruluyor
	for i=0 to adet
		B(i)=1
	next
	maxIterSayisi = 100
	stepSize = 0.01
	N=(cint(session("toplamogrencisayisi")/2)+cint(session("arkadassayisi")))
	'response.write("Döngü Sayýsý : "&N&"<hr>")
			
			' iterasyon döngüsü baþlangýç
				for j=1 to maxIterSayisi
					toplam=0

					' epsilon toplama iþlemi baþlangýç
						for k=1 to N
							anketToplam=0
								' ilgili kaydýn anket deðerleri ve label sonucu alýnýyor
								sorgum="Select top 1 * from arkadasmatris where id="&k&" order by id asc"
								rs.Open Sorgum, Baglantim, 1, 3 
								ks=rs.recordcount
									do while not rs.eof
										if rs.eof then exit do
										for x=1 to adet
											anketToplam=(B(x)*rs("a"&x&""))+anketToplam
										next
										label=rs("label")
									rs.movenext
									loop	
								Rs.close
								anketToplam=anketToplam+B(0)
							
							Expogelen=Expo(anketToplam)
						'	Response.write(""&anketToplam&" un labeli : "&label&" - Exposu : "&Expogelen&"<br>")
							toplam=toplam+(Expogelen-label)
						next
					' bitiþ
					Bg(0)=formatnumber((B(0)-stepSize*((1/N)*toplam)),6) ' virgülden sonra 4 basamak almak için
					'Response.write(Bg(0)&" | ")
					'----------------------------------------------------------------------------------
					toplam2=0
					for k=1 to N
							anketToplam=0
							' ilgili kaydýn anket deðerleri ve label sonucu alýnýyor
							sorgum="Select top 1 * from arkadasmatris where id="&k&" order by id asc"
							rs.Open Sorgum, Baglantim, 1, 3 
							ks=rs.recordcount
								do while not rs.eof
									if rs.eof then exit do
									for x=1 to adet
										anketToplam=(B(x)*rs("a"&x&""))+anketToplam
										Bad(x)=rs("a"&x&"")
									next
									label=rs("label")
								rs.movenext
								loop	
							Rs.close
							anketToplam=anketToplam+B(0)
							Expogelen=Expo(anketToplam)
							toplam2=toplam2+(Expogelen-label)
							for y=1 to adet
								Bg(y)=formatnumber((B(y)-(stepSize*((1/N)*(toplam2)*Bad(y)))),6)
							next
						next
					' bitiþ
					
					'----------------------------------------------------------------------------------
					' geçici katsayýlarýn asýl katsayýlara atanmasý
						for i=0 to adet
							B(i)=Bg(i)
						next				
					' bitiþ
					'----------------------------------------------------------------------------------
				next
			' itrasyon bitiþ	
			
	'	response.write("<hr>")

	'	for i=0 to 15
	'		Response.write("B("&i&") : "&B(i)&"<br>")
	'	next
	
	sorgum="Select * from onerimatris order by id asc"
	rs.Open Sorgum, Baglantim, 1, 3 
		do while not rs.eof
			if rs.eof then exit do
			toplam=0
			for i=1 to adet
				toplam=B(i)*rs("a"&i&"")+toplam
			next
			toplam=formatnumber((toplam+B(0)),4)
			'response.write(""&toplam&" <br> ")
			olasilik=formatnumber((Expo(toplam)),2)		' asýl kullanýlacak sigma hesaplama fonksiyonu burasý
			'response.write("% "&olasilik*100&" <br> ")
			rs("yuzde")=olasilik
			rs.update	
			rs.movenext
		loop	
	Rs.close
	
End Function

Function ogrenciNetworkKaydet()
	dim csv_to_read,line,fso,objFile
	csv_to_read=session("ogrencinetwork")
	set fso = createobject("scripting.filesystemobject")
	set objFile = fso.opentextfile(server.mappath(csv_to_read))

	Do Until objFile.AtEndOfStream
		line = split(objFile.ReadLine,""",""")
		rs.open "select * from arkadaslar",baglantim,1,3
		sira=0
			for i=0 to ubound(line)
				rs.addnew
					veriParcala = Split(line(i),",")
					adet = Ubound(veriParcala)
					rs("ogr_no")=veriParcala(0)
					For j = 1 To adet
						if veriParcala(j)<>"" then
							sira=sira+1
							rs("arkadas"&sira&"")=veriParcala(j)
						end if
						
					Next
				rs.update	
			next
		rs.close
	Loop
	objFile.Close
End Function

Function ogrenciProfilKaydet()
	dim csv_to_read,line,fso,objFile
	csv_to_read=session("ogrenciprofil")
	set fso = createobject("scripting.filesystemobject")
	set objFile = fso.opentextfile(server.mappath(csv_to_read))

	Do Until objFile.AtEndOfStream
		line = split(objFile.ReadLine,""",""")
		rs.open "select * from profiller",baglantim,1,3
		sira=0
			for i=0 to ubound(line)
				rs.addnew
					veriParcala = Split(line(i),",")
					adet = Ubound(veriParcala)
					rs("ogr_no")=veriParcala(0)
					For j = 1 To adet
						if veriParcala(j)<>"" then
							sira=sira+1
							rs("a"&sira&"")=veriParcala(j)
						end if
						
					Next
				rs.update	
			next
		rs.close
	Loop
	objFile.Close
End Function

Function ogrenciListesiKaydet()
	dim csv_to_read,counter,line,fso,objFile
	csv_to_read=session("ogrencilistesi")
	counter=0
	set fso = createobject("scripting.filesystemobject")
	set objFile = fso.opentextfile(server.mappath(csv_to_read))
	Do Until objFile.AtEndOfStream
		line = split(objFile.ReadLine,""",""")
		counter=counter + 1
		rs.open "select * from isimler",baglantim,1,3
		sira=0
			for i=0 to ubound(line)
				rs.addnew
					veriParcala = Split(line(i),",")
					rs("ogr_no")=veriParcala(0)
					rs("ad_soyad")=veriParcala(1)
				rs.update	
			next
		rs.close
	Loop
	objFile.Close
	session("toplamogrencisayisi")=counter
End Function

Function sifirla()
	' arkadaþlar tablosunun içeriði siliniyor
	ra.open "delete * from arkadaslar",baglantim,1,3
	ra.open "delete * from isimler",baglantim,1,3
	ra.open "delete * from onerimatris",baglantim,1,3
	ra.open "delete * from profiller",baglantim,1,3
	ra.open "delete * from arkadasmatris",baglantim,1,3
	Baglantim.execute("ALTER TABLE onerimatris ALTER COLUMN id COUNTER(1, 1)")
	Baglantim.execute("ALTER TABLE arkadasmatris ALTER COLUMN id COUNTER(1, 1)")
	Baglantim.execute("ALTER TABLE arkadaslar ALTER COLUMN id COUNTER(1, 1)")
	Baglantim.execute("ALTER TABLE isimler ALTER COLUMN id COUNTER(1, 1)")
	Baglantim.execute("ALTER TABLE profiller ALTER COLUMN id COUNTER(1, 1)")
	Response.redirect "default.asp"
	' silme bitiþ
end Function

Function ogrenciNetworkGoster()
	k=0
	renk=1
	rs.open "select * from arkadaslar",baglantim,1,3 
		if rs.eof or rs.bof then
			kayityok()
		else%>
			<div class="col-lg-12" style="padding-left: 0px; padding-right: 0px;">
				<div class="col-lg-2 baslik" style="margin-right:5px; width: 16.2%;"><b>Öðrenci Numarasý</b></div>
				<div class="col-lg-10" style="padding:10px; background:#f7f7f7; margin-bottom:8px; border-radius:7px"><b>Arkadaþ Olunan Numaralar</b></div>
			</div>
			<div class="col-lg-12" style="width:100%; max-height: 303px; overflow: auto; padding-left: 0px;padding-right: 0px;">
				<%do while not rs.eof 
				if rs.eof then exit do
				k=k+1%>
				<div class="col-lg-12 tablo<%=renk%>" style="padding:5px; margin-bottom:8px; margin-left:0px">
					<div class="col-lg-2" style="border-radius:7px; margin-right:5px; width: 16.2%;"><%=k%> -> <%=rs("ogr_no")%></div>
					<%for i=1 to 10
						if rs("arkadas"&i&"")<>"" then%>
							<div class="col-lg-1"><%=rs("arkadas"&i&"")%></div>
						<%end if
					next%>
					
				</div>
				<%
				if renk=1 then
					renk=0
				else
					renk=1
				end if
				rs.movenext
				loop%>
			</div>
		<%end if
	rs.close
	'Set rs = Nothing
End Function

Function ogrenciProfilGoster()
	k=0
	renk=1
	rs.open "select * from profiller",baglantim,1,3 
		if rs.eof or rs.bof then
			kayityok()
		else%>
			<div class="col-lg-12" style="padding-left: 0px; padding-right: 0px;">
				<div class="col-lg-4 baslik" style="margin-right:5px; width: 31%;"><b>Öðrenci Numarasý</b></div>
				<div class="col-lg-8" style="padding:10px; background:#f7f7f7; margin-bottom:8px; border-radius:7px"><b>Anket Oylama Deðerleri</b></div>
			</div>
			<div class="col-lg-12" style="width:100%; max-height: 342px; overflow: auto; padding-left: 0px;padding-right: 0px;">
				<%do while not rs.eof 
				if rs.eof then exit do
				k=k+1%>
					<div class="col-lg-4 tablo<%=renk%>" style="margin-bottom:8px; margin-left:0px; width: 32%;"><%=k%> -> <%=rs("ogr_no")%></div>
					<div class="col-lg-8 tablo<%=renk%>" style="margin-bottom:8px; margin-left:0px; margin-right:0px;" >
						<%for i=1 to 15
							if rs("a"&i&"")<>"" then%>
								<div style="float:left; margin-left:7px; width: 14px; text-align: center;"><%=rs("a"&i&"")%></div>
							<%end if
						next%>
					</div>
				<%
				if renk=1 then
					renk=0
				else
					renk=1
				end if
				rs.movenext
				loop%>
			</div>
		<%end if
	rs.close
	'Set rs = Nothing
End Function

Function ogrenciListesiGoster()
	k=0
	renk=1
	rs.open "select * from isimler",baglantim,1,3 
		if rs.eof or rs.bof then
			kayityok()
		else%>
			<div class="col-lg-12" style="padding-left: 0px; padding-right: 0px;">
				<div class="col-lg-6 baslik" style="margin-right:8px; width: 48%;"><b>Öðrenci Numarasý</b></div>
				<div class="col-lg-6 baslik" style="width: 49%;"><b>Adý Soyadý</b></div>
			</div>
			<div class="col-lg-12" style="width:100%; max-height: 342px; overflow: auto; padding-left: 0px;padding-right: 0px;">			
				<%do while not rs.eof 
				if rs.eof then exit do
				k=k+1%>
					<div class="col-lg-6 tablo<%=renk%>" style="margin-right:8px; margin-left:0px; width: 48%;"><%=k%> -> <%=rs("ogr_no")%></div>
					<div class="col-lg-6 tablo<%=renk%>" style="margin-bottom:8px; margin-left:0px; width: 49%;"><%=rs("ad_soyad")%></div>
				<%
				if renk=1 then
					renk=0
				else
					renk=1
				end if
				rs.movenext
				loop%>
			</div>
		<%end if
	rs.close
	'Set rs = Nothing
End Function

Function arkadaslariGoster()
	k=0
	renk=1
	rs.open "select * from arkadasmatris",baglantim,1,3 
		if rs.eof or rs.bof then
			kayityok()
		else%>
			<div class="col-lg-12" style="padding-left: 0px; padding-right: 0px;">
				<div class="col-lg-3 baslik" style="margin-right:5px; width: 21%;"><b>Öðrenci No</b></div>
				<div class="col-lg-8 baslik" style="margin-right: 5px; width: 65%;"><b>Anket Oylama Deðerleri</b></div>
				<div class="col-lg-1 baslik" style="padding-left: 7px;"><b>Label</b></div>
			</div>
			<div class="col-lg-12" style="width:100%; max-height: 342px; overflow: auto; padding-left: 0px;padding-right: 0px;">
				<%do while not rs.eof 
				if rs.eof then exit do
				k=k+1%>
					<div class="col-lg-3 tablo<%=renk%>" style="margin-bottom:8px; margin-left:0px; width: 21.5%;"><%=k%> -> <%=rs("ogr_no")%></div>
					<div class="col-lg-8 tablo<%=renk%>" style="margin-bottom:8px; margin-left:0px; width: 66%;" >
						<%for i=1 to 15
							if rs("a"&i&"")<>"" then%>
								<div style="float:left; margin-left:7px; width: 14px; text-align: center;"><%=rs("a"&i&"")%></div>
							<%end if
						next%>
					</div>
					<div class="col-lg-1 tablo<%=renk%>" style="margin-bottom:8px; margin-left: 1px;"><b><%=rs("label")%></b></div>
				<%
				if renk=1 then
					renk=0
				else
					renk=1
				end if
				rs.movenext
				loop%>
			</div>
		<%end if
	rs.close
	'Set rs = Nothing	
End Function

Function onerileriGoster()
	k=0
	renk=1
	rs.open "select * from onerimatris",baglantim,1,3 
		if rs.eof or rs.bof then
			kayityok()
		else%>
			<div class="col-lg-12" style="padding-left: 0px; padding-right: 0px;">
				<div class="col-lg-3 baslik" style="margin-right:5px; width: 21%;"><b>Öðrenci No</b></div>
				<div class="col-lg-8 baslik" style="margin-right: 5px; width: 65%;"><b>Anket Oylama Deðerleri</b></div>
				<div class="col-lg-1 baslik" style="padding-left: 7px;"><b>P</b></div>
			</div>
			<div class="col-lg-12" style="width:100%; max-height: 342px; overflow: auto; padding-left: 0px;padding-right: 0px;">
				<%do while not rs.eof 
				if rs.eof then exit do
				k=k+1%>
					<div class="col-lg-3 tablo<%=renk%>" style="margin-bottom:8px; margin-left:0px; width: 21.5%;"><%=k%> -> <%=rs("ogr_no")%></div>
					<div class="col-lg-8 tablo<%=renk%>" style=" margin-bottom:8px; margin-left:0px; width: 66%;" >
						<%for i=1 to 15
							if rs("a"&i&"")<>"" then%>
								<div style="float:left; margin-left:7px; width: 14px; text-align: center;"><%=rs("a"&i&"")%></div>
							<%end if
						next%>
					</div>
					<div class="col-lg-1 tablo<%=renk%>" style="margin-bottom:8px; margin-left:1px;"><b><%=rs("yuzde")%></b></div>
				<%
				if renk=1 then
					renk=0
				else
					renk=1
				end if
				rs.movenext
				loop%>
			</div>
		<%end if
	rs.close
	'Set rs = Nothing	
End Function

Function sononerileriGoster()
	renk=1
	rs.open "select top 10 * from onerimatris order by yuzde desc",baglantim,1,3 
		if rs.eof or rs.bof then
			kayityok()
		else%>
			<%for i=1 to 10
				if rs.eof then exit for%>
					<div class="tablo<%=renk%>" style="width: 9%; float: left;">
						<center>
							<img src="img/resimyok.png" style="border-radius:50%; width:85px; margin-bottom:5px"><br>
							<div style="min-height: 26px;"><%=isimbul(rs("ogr_no"))%></div><hr>
							<%=rs("ogr_no")%><hr>
							<%yuzde=formatnumber(rs("yuzde"),2)*100%>
							<div class="progress" title="Arkadaþ Olma Oraný : %<%=yuzde%>" alt="Arkadaþ Olma Oraný : %<%=yuzde%>">
							 	<div class="progress-bar" role="progressbar" style="width: <%=yuzde%>%;" aria-valuenow="<%=yuzde%>" aria-valuemin="0" aria-valuemax="100" title="Arkadaþ Olma Oraný : %<%=yuzde%>">%<%=yuzde%></div>
							</div>
						</center>	
					</div>
				<%
				if renk=1 then
					renk=0
				else
					renk=1
				end if
				rs.movenext
			next%>
		<%end if
	rs.close
	'Set rs = Nothing	
End Function

Function arkadaslariEkle(ogrno)
	sorgum="Select top 1 * from arkadaslar where ogr_no like '%"&ogrno&"%'"&" order by id asc"
	Ru.Open Sorgum, Baglantim, 1, 3 
		if ru.eof or ru.bof then
			arkadaslariEkle="0"
		else
			esayi=0
			for i=1 to 10
				if ru("arkadas"&i&"")<>"" then
					esayi=esayi+1
					numara=ru("arkadas"&i&"")
					sorgum="Select top 1 * from profiller where ogr_no like '%"&numara&"%'"&" order by id asc"
					Rs.Open Sorgum, Baglantim, 1, 3 
					
							'arkadaþ olanlar önerimatrisine ekleniyor.
							ra.open "select * from arkadasmatris",baglantim,1,3
							ra.addnew
							ra("ogr_no")=rs("ogr_no")
							ra("label")=1
							For j = 1 To 15
								ra("a"&j&"")=rs("a"&j&"")
							Next
							ra.update	
							ra.close
							'ekleme bitiþ
					rs("alindi")=1
					rs.update
					Rs.close
				end if
			next
			arkadaslariEkle=esayi
		end if
	Ru.close
End Function

Function digerArkadaslariEkle(kalan)
	ogrno=session("ogrno")
	sorgum="Select top "&kalan&" * from profiller where alindi=0 and ogr_no not like '%"&ogrno&"%'"&" order by id asc"
	Rs.Open Sorgum, Baglantim, 1, 3 
		do while not rs.eof
			if rs.eof then exit do
				'arkadaþ olmayanlar önerimatrisine ekleniyor.
				ra.open "select * from arkadasmatris",baglantim,1,3
				ra.addnew
				ra("ogr_no")=rs("ogr_no")
				ra("label")=0
				For j = 1 To 15
					ra("a"&j&"")=rs("a"&j&"")
				Next
				ra.update	
				ra.close
				'ekleme bitiþ
			rs("alindi")=1
			rs.update
			rs.movenext
		loop	
	Rs.close
End Function

Function onerileriEkle(ogrno)
	sorgum="Select * from profiller where alindi=0 and ogr_no not like '%"&ogrno&"%'"&" order by id asc"
	Rs.Open Sorgum, Baglantim, 1, 3 
		do while not rs.eof
			if rs.eof then exit do
				'arkadaþ olmayanlar önerimatrisine ekleniyor.
				ra.open "select * from onerimatris",baglantim,1,3
				ra.addnew
				ra("ogr_no")=rs("ogr_no")
				For j = 1 To 15
					ra("a"&j&"")=rs("a"&j&"")
				Next
				ra.update	
				ra.close
				'ekleme bitiþ
			rs.movenext
		loop	
	Rs.close
End Function

Function kayityok()%>
	<div class="col-lg-12"><hr>
		<center><b><img src="img/uyari.png" style="width:130px"><br>Kayýt Bulunamadý.</b></center>
	</div>
<%End Function

Function isimbul(numara)
	sorgum="Select top 1 * from isimler where ogr_no like '%"&numara&"%'"&" order by id asc"
	Ru.Open Sorgum, Baglantim, 1, 3 
	if ru.eof or ru.bof then
		isimbul="Kayýt Yok"
	else
		isimbul=ru("ad_soyad")
	end if
	Ru.close
End Function

Function numarabul(isim)
	sorgum="Select top 1 * from isimler where ad_soyad like '%"&isim&"%'"&" order by id asc"
	Ru.Open Sorgum, Baglantim, 1, 3 
	if ru.eof or ru.bof then
		numarabul="Kayýt Yok"
	else
		numarabul=ru("ogr_no")
	end if
	Ru.close
End Function
%>