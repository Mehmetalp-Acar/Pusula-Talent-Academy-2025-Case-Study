CREATE TABLE Urun (
	UrunID INT PRIMARY KEY,
	UrunAdi NVARCHAR(100),
	Fiyat DECIMAL(10,2)
);

CREATE TABLE Satis (
	SatisID INT PRIMARY KEY,
	UrunID INT FOREIGN KEY REFERENCES Urun(UrunID),
	Adet INT,
	SatisTarihi DATETIME
);

INSERT INTO dbo.Urun (UrunID,UrunAdi,Fiyat) VALUES
(1, 'Laptop', 15000.00), (2, 'Mouse', 250.00), (3, 'Klavye', 450.00);

INSERT INTO dbo.Satis (SatisID,UrunID,Adet,SatisTarihi) VALUES
(1,1,2,'2024-01-10'),(2, 2, 5, '2024-01-15'), (3, 1, 1, '2024-02-20'), 
(4, 3, 3, '2024-03-05'), (5, 2, 7, '2024-03-25'), (6, 3, 2, '2024-04-12')

SELECT * FROM Urun
SELECT * FROM Satis


--TASK 1:
SELECT
    YEAR(s.SatisTarihi) AS SatisYili,
    u.UrunAdi,
    SUM(s.Adet) AS ToplamAdet,
    CAST(SUM(s.Adet * u.Fiyat) AS DECIMAL(18,2)) AS ToplamTutar
FROM dbo.Satis AS s
JOIN dbo.Urun  AS u
  ON u.UrunID = s.UrunID
GROUP BY
    YEAR(s.SatisTarihi),
    u.UrunAdi
ORDER BY
    SatisYili,
    u.UrunAdi


--TASK 2:
SELECT
    SatisYili,
    UrunAdi,
    ToplamAdet,
    ToplamTutar
FROM (
    SELECT
        YEAR(s.SatisTarihi) AS SatisYili,
        u.UrunAdi,
        SUM(s.Adet) AS ToplamAdet,
        CAST(SUM(s.Adet * u.Fiyat) AS DECIMAL(18,2)) AS ToplamTutar,
        RANK() OVER (
            PARTITION BY YEAR(s.SatisTarihi)
            ORDER BY SUM(s.Adet * u.Fiyat) DESC
        ) AS YilSira
    FROM dbo.Satis AS s
    JOIN dbo.Urun AS u
      ON u.UrunID = s.UrunID
    GROUP BY YEAR(s.SatisTarihi), u.UrunAdi
) YilUrunOzet
WHERE YilSira = 1
ORDER BY SatisYili, UrunAdi


--TASK 3:
SELECT u.UrunAdi, u.Fiyat
FROM dbo.Urun AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Satis AS s
    WHERE s.UrunID = u.UrunID
)
