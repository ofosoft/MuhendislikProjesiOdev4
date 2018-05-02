<!DOCTYPE HTML>
<html>
<head>
	<!--#include file="head.asp"-->
</head>
<body>
	<%
	dosyayukleme=request("dosyayukleme")
	islem=request("islem")
	if islem="sifirla" then
		sifirla()
	elseif islem="aramayap" then
		aranan=request("ogr_no")
		isimmi = InStr(1,aranan, " ")
		if isimmi<>0 then
			ogrno=numarabul(aranan)
		else
			ogrno=aranan
		end if
		varmi=isimbul(ogrno)	
	end if
	%>
	<div class="container">
		<div class="row">	
			<div class="col-lg-2 sol alt" style="height: 140px; margin-top: 20px; width:150px;">	
				<a href="default.asp"><img src="img/culogo.png" style="height: 120px"></a>
			</div>
			<div class="col-lg-7 sag" style="height: 140px; margin-top: 20px;">
				<h4 style="text-align: center; margin-top: 10px; letter-spacing: 7px;">
					T.C<br>CUMHUR�YET �N�VERS�TES�<BR>
					M�HEND�SL�K FAK�LTES�<BR>
					Bilgisayar M�hendisli�i
					<hr style="margin: 10px">M�hendislik Projesi �devi - 4
				</h4>
			</div>
			<div class="col-lg-3 sag" style="height: 140px; margin-top: 20px; margin-left: 10px;background: #f11110; color:#f8f8f8">	
				<h4 style="text-align: center; margin-top: 20px;font-weight: bold;">
					�mer Faruk �ZT�RK<hr style="margin: 10px">2015141065<hr style="margin: 10px">3. S�n�f �kinci ��retim
				</h4>
			</div>   
			<div class="col-lg-12 btn btn-primary" style="text-align: center; width: 98%; margin-top: 15px;">
				<a href="default.asp">
					<h3 style="text-align: center; letter-spacing: 5px; color:#f8f8f8">
						ARKADA� �NER� SCR�PT� 1.0
					</h3>
				</a>
			</div>
			<div class="col-lg-12 govde">
			<%if dosyayukleme<>"evet" then%>
					<div class="col-lg-8" style="padding-left: 0px;">
						<form method="POST" enctype="multipart/form-data" action="dosyayukle.asp">
							<div class="col-lg-6 cerceve" style="width:48%; margin-bottom:8px"><label>�grenci Network : </label><hr><input type="file" name="ogrenci" required="required"></div>
							<div class="col-lg-6 cerceve" style="width:48%; margin-bottom:8px"><label>�grenci Profil : </label><hr><input type="file" name="profil" required="required"></div>
							<div class="col-lg-6 cerceve" style="width:48%"><label>�grenci �simleri : </label><hr><input type="file" name="isimler" required="required"></div>
							<div class="col-lg-6 cerceve" style="padding-top: 24px; padding-left: 20px;width:48%">
								<div class="col-lg-5">
									<center><input type="submit" class="btn btn-success" value="Dosyalar� Y�kle" style="padding:8px; font-weight:bold;"></center>
								</div>
								<div class="col-lg-7">
									<button type="button" class="btn btn-danger" data-toggle="modal" data-target="#exampleModal" style="padding:8px; font-weight:bold;">
									  Veritaban�n� S�f�rla
									</button>

									<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
									  <div class="modal-dialog" role="document">
									    <div class="modal-content">
									      <div class="modal-header">
									        <h5 class="modal-title" id="exampleModalLabel">�nemli Uyar�</h5>
									        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="margin-top: -25px;">
									          <span aria-hidden="true">&times;</span>
									        </button>
									      </div>
									      <div class="modal-body">
									        Veritaban�ndaki T�m Bilgiler Silinecektir. Onayl�yor Musunuz?
									      </div>
									      <div class="modal-footer">
									        <button type="button" class="btn btn-success" data-dismiss="modal">Hay�r</button>
									        <a type="button" class="btn btn-danger" href="?islem=sifirla">Evet</a>
									      </div>
									    </div>
									  </div>
									</div>	
								</div>
							</div>
						</form>
					</div>	
					<div class="col-lg-4 cerceve" style="width:31.5%; padding-top: 20px;">
						<form method="POST" action="default.asp?islem=aramayap">
							<h4 style="text-align: center; letter-spacing: 2px; margin-bottom:10px; font-weight:bold">
								�NER� L�STES� ARAMA
							</h4><hr>
							<input type="text" name="ogr_no" value="<%=aranan%>" required="required" placeholder="Aranacak ��renci Numaras� veya Ad� Soyad�" style="width:98%; padding:7px; border-radius:7px; margin:7px; text-align: center;"><br>
							<b style="margin-left:7px">�rn :</b> 2014141065 veya �mer Faruk �ZT�RK
							<center><input type="submit" value="Arama Yap" class="btn btn-primary" style="padding:8px; font-weight:bold; margin-top: 6px;"></center>
						</form>
					</div>
				
			<%else%>
				<%ogrenciNetworkKaydet()%>
				<%ogrenciProfilKaydet()%>
				<%ogrenciListesiKaydet()%>
				<%Response.redirect "default.asp"%>
			<%end if%>	
			</div>
			
			<%
			if islem="aramayap" then
				ra.open "delete * from onerimatris",baglantim,1,3
				ra.open "delete * from arkadasmatris",baglantim,1,3
				Baglantim.execute("ALTER TABLE onerimatris ALTER COLUMN id COUNTER(1, 1)")
				Baglantim.execute("ALTER TABLE arkadasmatris ALTER COLUMN id COUNTER(1, 1)")
				' profiller alan�nda al�nd� k�sm� 0 lan�yor. �nceki aramadaki kay�tlarla kar��mamas� i�in
				Baglantim.execute("UPDATE profiller set alindi=0 where alindi=1")
				if varmi="Kay�t Yok" then%>
					<div class="col-lg-12 btn btn-danger" style="text-align: center; width: 98%; margin-top: 10px;">
							<h3 class="btn btn-default btn-lg" style="text-align: center; letter-spacing: 8px">
								<b>ARADI�INIZ K���YE A�T E�LE�EN KAYIT BULUNMAMAKTADIR...</b>
							</h3>
					</div>
				<%else%>
					<div class="col-lg-12 govde" style="text-align: center">
						<div class="col-lg-6" style="padding-left:0px">
							<div class="col-lg-9">
								<h4 style="text-align: center; letter-spacing: 2px; margin-bottom:10px">
									Arkada�lar Matrisi
								</h4>
							</div>
							<div class="col-lg-3" style="padding-right: 0px;">
								<i class="fa fa-angle-double-up arkadaslar kapat" title="Tabloyu Gizle"></i> 
								<i class="fa fa-angle-double-down arkadaslar ac" title="Tabloyu G�ster"></i>
							</div>
							<div class="col-lg-12 arkadaslar" style="padding-left:0px; padding-right: 0;">
								<%if ogrno<>"" then%>
									<%adet=arkadaslariEkle(ogrno)
									kalan=50-adet
									session("ogrno")=ogrno
									sorgum="Select * from isimler order by id asc"
									rf.Open Sorgum, Baglantim, 1, 3 
									togrencisayisi=rf.recordcount
									rf.close
									session("arkadassayisi")=adet
									session("toplamogrencisayisi")=togrencisayisi-adet-1 ' 1 ki�inin kendisi
									digerArkadaslariEkle(kalan)%>
								<%end if%>						
								<%arkadaslariGoster()%>
								
							</div>	
						</div>
						<div class="col-lg-6" style="padding-left:0px;padding-right: 0;">
							<div class="col-lg-9">
								<h4 style="text-align: center; letter-spacing: 2px; margin-bottom:10px">
									�neri Matrisi
								</h4>
							</div>
							<div class="col-lg-3" style="padding-right: 0px;">
								<i class="fa fa-angle-double-up oneri kapat" title="Tabloyu Gizle"></i> 
								<i class="fa fa-angle-double-down oneri ac" title="Tabloyu G�ster"></i>
							</div>
							<div class="col-lg-12 oneri" style="padding-left:0px; padding-right: 0;">
								<%if ogrno<>"" then%>
									<%onerileriEkle(ogrno)%>
								<%end if%>
								<%oneriOlasilikHesapla(15)%>
								<%onerileriGoster()	%>
							</div>	
						</div>
					</div> 	
					<div class="col-lg-12 govde" style="text-align: center; padding-right:0px">
						<div class="col-lg-10">
							<h3 style="text-align: center; letter-spacing: 3px; margin-bottom:10px">
								SAYIN <em style="color:blue"><%=isimbul(ogrno)%></em> S�ZE �NER�LEN EN �Y� 10 ARKADA�
							</h3>
						</div>
						<div class="col-lg-2" style="padding-right: 19px;">
							<i class="fa fa-angle-double-up sononeri kapat" title="Tabloyu Gizle" style="margin-top: 3px; padding: 6px 10px;"></i> 
							<i class="fa fa-angle-double-down sononeri ac" title="Tabloyu G�ster" style="margin-top: 3px; padding: 6px 10px;"></i>
						</div>
						<div class="col-lg-12 sononeri" style="padding-left:0px; padding-right: 0;">
							<%sononerileriGoster()%>

						</div>	

					</div> 
				<%end if
			end if%>
			
			<%if 3>2 then%>
				<div class="col-lg-12 govde" style="text-align: center">
					<div class="col-lg-10">
						<h3 style="text-align: center; letter-spacing: 5px; margin-bottom:10px">
							Arkada� Ba�lant� Matrisi (ogrenciNetwork)
						</h3>
					</div>
					<div class="col-lg-2" style="padding-right: 0px;">
						<i class="fa fa-angle-double-up arkadas kapat" title="Tabloyu Gizle" style="margin-top: 3px; padding: 6px 10px;"></i> 
						<i class="fa fa-angle-double-down arkadas ac" title="Tabloyu G�ster" style="margin-top: 3px; padding: 6px 10px;"></i>
					</div>
					<div class="col-lg-12 arkadas" style="padding-left:0px; padding-right: 0px;">
						<%ogrenciNetworkGoster()%>
					</div>	
				</div> 
				
				<div class="col-lg-12 govde" style="text-align: center">
					<div class="col-lg-6">
						<div class="col-lg-9">
							<h4 style="text-align: center; letter-spacing: 2px; margin-bottom:10px">
								��renci Profil Matrisi (ogrenciProfil)
							</h4>
						</div>
						<div class="col-lg-3">
							<i class="fa fa-angle-double-up profil kapat" title="Tabloyu Gizle"></i> 
							<i class="fa fa-angle-double-down profil ac" title="Tabloyu G�ster"></i>
						</div>
						<div class="col-lg-12 profil" style="padding-left:0px; padding-right: 0;">
							<%ogrenciProfilGoster()%>
						</div>	
					</div>
					<div class="col-lg-6" style="padding-left:0px;padding-right: 0;">
						<div class="col-lg-9">
							<h4 style="text-align: center; letter-spacing: 2px; margin-bottom:10px">
								��renci �sim Listesi (ogrenciListesi)
							</h4>
						</div>
						<div class="col-lg-3" style="padding-right: 0px;">
							<i class="fa fa-angle-double-up liste kapat" title="Tabloyu Gizle"></i> 
							<i class="fa fa-angle-double-down liste ac" title="Tabloyu G�ster"></i>
						</div>
						<div class="col-lg-12 liste" style="padding-left:0px; padding-right: 0;">
							<%ogrenciListesiGoster()%>
						</div>	
					</div>
				</div> 
			<%end if%>	
			
			
			
			<div class="col-lg-12 govde alt" style="margin-top: 20px;;background: #f11110; color:#f8f8f8">
				<div class="col-lg-1">
					<a href="http://www.sivasspor.org.tr" target="_blank" title="Sivasl�y�z Sivassporluyuz"><img src="img/sivassporlogo.png" style="height:40px"></a>
				</div>
				<div class="col-lg-10"><h4 style="text-align: center; font-weight: bold;padding-top: 12px;">
						�mer Faruk �ZT�RK | 2015141065 | 3. S�n�f �kinci ��retim
					</h4></div>
				<div class="col-lg-1">
					<a href="http://www.ofosoft.com" target="_blank" title="OfoSoft Bili�im"><img src="img/ofo.png" style="height:40px"></a>
				</div>
			</div>
			
		</div>
	</div>
	

	<br>
	
</body>

</html>
