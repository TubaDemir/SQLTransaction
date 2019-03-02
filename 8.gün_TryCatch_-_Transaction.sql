
--Transaction i�inde yer alan t�m i�lemler veritaban� server �zerinde yap�lmak zorunda, aksi halde transaction
-- i�indeki i�lemlerin tek bi ad�m� dahi ba�ar�s�z olsa, t�m yap�lan i�lemler yap�lmam�� gibi eski haline d�ner

--banka hesab� i�in tablo olu�tur.
CREATE TABLE BankaHesabi(
 HesapNo CHAR(20) NOT NULL PRIMARY KEY,
 Adi VARCHAR(55),
 Soyadi VARCHAR(55),
 Sube INTEGER,
 Bakiye FLOAT
)
  --hesaplar� gir
INSERT INTO BankaHesabi values('1','Kadriye','Do�uta�', 001, 10000) 
INSERT INTO BankaHesabi values('2','Mehmet','Akay', 003, 5000)
INSERT INTO BankaHesabi values('3','Adem','Erbilen', 002, 5440)	 
INSERT INTO BankaHesabi values('4','Sultan','Susmaz', 003, 18900) 
INSERT INTO BankaHesabi values('5','Zeynep','E�ilmez', 002, 3000)
INSERT INTO BankaHesabi values('6','Gamze ','Durmaz', 001, 6440)

--banka hesab�ndaki paran�n miktar�n� de�i�tirip i�lemleri kaydedicez. Sonras�nda hesab� siliyoruz. 
--Amac�m�z kay�t noktas�na geri d�nd���m�zde hesab� geri getirebiliyor muyuz?
--transactionu ba�lat
BEGIN TRANSACTION 
--1 numaral� hesaptaki bakiyeyi 50000 yap.
         UPDATE BankaHesabi
         SET bakiye = 50000 
         WHERE hesapNo='1';
                  --son durumu kaydet
				  SAVE TRANSACTION svp_kaydet
		SELECT * FROM BankaHesabi
			--Hesab� kapat- Sil yani. Buradaki amac�m�z kay�t noktas�na geri d�nd���m�zde hesap geri gelecekmi?
         DELETE FROM BankaHesabi 
         WHERE  HesapNo='1';
		 SELECT * FROM BankaHesabi
		-- kay�t noktas�na geri d�n ve listele
                  ROLLBACK TRAN svp_kaydet;
         SELECT * FROM BankaHesabi; 
		 --hesap ilk haline d�nd�
		 ROLLBACK TRAN 
		 COMMIT   --commit yap�ld�ktan sonra transaction i�lemi sona erdilir ve art�k geri d�n�� yapamay�z.
		 SELECT * FROM BankaHesabi; 
--2. �rnek
    	BEGIN TRANSACTION  
		--Varolan bakiyeden 2.000 liray� 2 numaral� hesaba aktar.
			UPDATE BankaHesabi 
               SET bakiye=bakiye - 2000
			WHERE hesapNo=1
			 SELECT * FROM BankaHesabi; 
		--hata ger�ekle�mediyse @@error'un de�eri 0'a e�ittir. Her hangi bir hata ger�ekle�tiyse yani 0'a e�it de�ilse paray� geri aktar.
		IF @@ERROR<>0
   			ROLLBACK
		UPDATE BankaHesabi
			SET bakiye=bakiye + 2000
		 	WHERE hesapNo=2
		IF @@ERROR<>0
			ROLLBACK
	-- her �ey tamamland���nda i�lemleri onayla       
	COMMIT