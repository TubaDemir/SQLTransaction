
--Transaction içinde yer alan tüm iþlemler veritabaný server üzerinde yapýlmak zorunda, aksi halde transaction
-- içindeki iþlemlerin tek bi adýmý dahi baþarýsýz olsa, tüm yapýlan iþlemler yapýlmamýþ gibi eski haline döner

--banka hesabý için tablo oluþtur.
CREATE TABLE BankaHesabi(
 HesapNo CHAR(20) NOT NULL PRIMARY KEY,
 Adi VARCHAR(55),
 Soyadi VARCHAR(55),
 Sube INTEGER,
 Bakiye FLOAT
)
  --hesaplarý gir
INSERT INTO BankaHesabi values('1','Kadriye','Doðutaþ', 001, 10000) 
INSERT INTO BankaHesabi values('2','Mehmet','Akay', 003, 5000)
INSERT INTO BankaHesabi values('3','Adem','Erbilen', 002, 5440)	 
INSERT INTO BankaHesabi values('4','Sultan','Susmaz', 003, 18900) 
INSERT INTO BankaHesabi values('5','Zeynep','Eðilmez', 002, 3000)
INSERT INTO BankaHesabi values('6','Gamze ','Durmaz', 001, 6440)

--banka hesabýndaki paranýn miktarýný deðiþtirip iþlemleri kaydedicez. Sonrasýnda hesabý siliyoruz. 
--Amacýmýz kayýt noktasýna geri döndüðümüzde hesabý geri getirebiliyor muyuz?
--transactionu baþlat
BEGIN TRANSACTION 
--1 numaralý hesaptaki bakiyeyi 50000 yap.
         UPDATE BankaHesabi
         SET bakiye = 50000 
         WHERE hesapNo='1';
                  --son durumu kaydet
				  SAVE TRANSACTION svp_kaydet
		SELECT * FROM BankaHesabi
			--Hesabý kapat- Sil yani. Buradaki amacýmýz kayýt noktasýna geri döndüðümüzde hesap geri gelecekmi?
         DELETE FROM BankaHesabi 
         WHERE  HesapNo='1';
		 SELECT * FROM BankaHesabi
		-- kayýt noktasýna geri dön ve listele
                  ROLLBACK TRAN svp_kaydet;
         SELECT * FROM BankaHesabi; 
		 --hesap ilk haline döndü
		 ROLLBACK TRAN 
		 COMMIT   --commit yapýldýktan sonra transaction iþlemi sona erdilir ve artýk geri dönüþ yapamayýz.
		 SELECT * FROM BankaHesabi; 
--2. örnek
    	BEGIN TRANSACTION  
		--Varolan bakiyeden 2.000 lirayý 2 numaralý hesaba aktar.
			UPDATE BankaHesabi 
               SET bakiye=bakiye - 2000
			WHERE hesapNo=1
			 SELECT * FROM BankaHesabi; 
		--hata gerçekleþmediyse @@error'un deðeri 0'a eþittir. Her hangi bir hata gerçekleþtiyse yani 0'a eþit deðilse parayý geri aktar.
		IF @@ERROR<>0
   			ROLLBACK
		UPDATE BankaHesabi
			SET bakiye=bakiye + 2000
		 	WHERE hesapNo=2
		IF @@ERROR<>0
			ROLLBACK
	-- her þey tamamlandýðýnda iþlemleri onayla       
	COMMIT