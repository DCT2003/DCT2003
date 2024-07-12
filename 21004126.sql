-- Tạo cơ sở dữ liệu QLSV
CREATE DATABASE QLSV
ON PRIMARY
( 
    NAME = QLSV_Data,
    FILENAME = 'D:\QLSV_Data.mdf',
    SIZE = 20MB,
    MAXSIZE = 30MB,
    FILEGROWTH = 5MB
)
LOG ON
( 
    NAME = QLSV_Log,
    FILENAME = 'D:\QLSV_Log.ldf',
    SIZE = 10MB,
    MAXSIZE = 20MB,
    FILEGROWTH = 2MB
);

-- Sử dụng cơ sở dữ liệu QLSV
USE QLSV;

-- Tạo bảng Lop
CREATE TABLE Lop (
    MaLop CHAR(4) PRIMARY KEY,
    TenLop NVARCHAR(100) UNIQUE
);

-- Tạo bảng SinhVien
CREATE TABLE SinhVien (
    MaSV CHAR(4) PRIMARY KEY,
    HoTen NVARCHAR(50),
    NgaySinh DATETIME,
    MaL CHAR(4),
    FOREIGN KEY (MaL) REFERENCES Lop(MaLop)
);

-- Tạo bảng Mon
CREATE TABLE Mon (
    MaMon CHAR(4) PRIMARY KEY,
    TenMon NVARCHAR(50),
    SoTC INT CHECK(SoTC > 0)
);

-- Tạo bảng KetQua
CREATE TABLE KetQua (
    MaSV CHAR(4),
    MaMon CHAR(4),
    Lanthi INT,
    Diem NUMERIC CHECK(Diem >= 0),
    PRIMARY KEY (MaSV, MaMon, Lanthi),
    FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
    FOREIGN KEY (MaMon) REFERENCES Mon(MaMon)
);
-- Nhập dữ liệu cho bảng Lop
INSERT INTO Lop (MaLop, TenLop) VALUES
    ('LP1', 'Lớp 1A'),
    ('LP2', 'Lớp 2B'),
    ('LP3', 'Lớp 3C'),
    ('LP4', 'Lớp 4D')
-- Nhập dữ liệu cho bảng SinhVien
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, MaL) VALUES

    ('SV01', N'Nguyễn Văn A', '2000-01-01', 'LP1'),
    ('SV02', N'Trần Thị B', '2001-02-02', 'LP1'),
    ('SV03', N'Lê Văn C', '1999-03-03', 'LP2'),
	('SV04', N'Nguyễn Văn D', '2000-01-01', 'LP4')

-- Nhập dữ liệu cho bảng Mon
INSERT INTO Mon (MaMon, TenMon, SoTC) VALUES
    ('MH01', N'Toán', 3),
    ('MH02', N'Văn', 2),
    ('MH03', N'Anh', 4)

-- Nhập dữ liệu cho bảng KetQua
INSERT INTO KetQua (MaSV, MaMon, Lanthi, Diem) VALUES
    ('SV01', 'MH01', 1, 8.5),
    ('SV01', 'MH02', 1, 7),
    ('SV01', 'MH03', 1, 9),
    ('SV02', 'MH01', 1, 7),
    ('SV02', 'MH02', 1, 8),
    ('SV02', 'MH03', 1, 6.5),
    ('SV03', 'MH01', 1, 6),
    ('SV03', 'MH02', 1, 8),
    ('SV03', 'MH03', 1, 7),
    ('SV01', 'MH01', 2, 9),
    ('SV01', 'MH02', 2, 8),
    ('SV01', 'MH03', 2, 7.5),
    ('SV02', 'MH01', 2, 8.5),
    ('SV02', 'MH02', 2, 7),
    ('SV02', 'MH03', 2, 9),
    ('SV03', 'MH01', 2, 7.5),
    ('SV03', 'MH02', 2, 8),
    ('SV03', 'MH03', 2, 8.5),
    ('SV01', 'MH01', 3, 7),
    ('SV01', 'MH02', 3, 9),
    ('SV01', 'MH03', 3, 8),
    ('SV02', 'MH01', 3, 8.5),
    ('SV02', 'MH02', 3, 7.5),
    ('SV02', 'MH03', 3, 8),
    ('SV03', 'MH01', 3, 8),
    ('SV03', 'MH02', 3, 7),
    ('SV03', 'MH03', 3, 9);



SELECT Lop.MaLop, Lop.TenLop, COUNT(SinhVien.MaSV) AS SoLuongSinhVien
FROM Lop
INNER JOIN SinhVien ON Lop.MaLop = SinhVien.MaL
GROUP BY Lop.MaLop, Lop.TenLop
HAVING COUNT(SinhVien.MaSV) > 1;--80

CREATE PROCEDURE CapNhatTC
    @MaMon CHAR(4),
    @SoTinChiMoi INT
AS
BEGIN
    UPDATE Mon
    SET SoTC = @SoTinChiMoi
    WHERE MaMon = @MaMon;
END;

EXECUTE CapNhatTC @MaMon = 'MH01', @SoTinChiMoi = 4;

CREATE FUNCTION TTSV
(
    @MaLop CHAR(4)
)
RETURNS TABLE
AS
RETURN
(
    SELECT SinhVien.MaSV, SinhVien.HoTen, SinhVien.NgaySinh
    FROM SinhVien
    WHERE SinhVien.MaL = @MaLop
);


SELECT * FROM TTSV('LP1');

drop trigger XoaLop

CREATE TRIGGER XoaLop
ON Lop
AFTER DELETE
AS BEGIN
DELETE FROM SinhVien WHERE EXISTS (SELECT * FROM DELETED d WHERE d.MaLop = SinhVien.MaL)
PRINT (N'XOA THANH CONG')
END
DELETE FROM Lop WHERE MaLop ='LP4'






