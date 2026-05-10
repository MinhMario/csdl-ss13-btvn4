CREATE DATABASE phong_kham;
USE phong_kham;

-- Bảng lịch khám
CREATE TABLE Appointments (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id    INT,
    patient_name VARCHAR(100),
    appt_date    DATE,
    start_time   TIME,
    end_time     TIME,
    status       VARCHAR(20) DEFAULT 'Pending'  -- Pending / Completed / Cancelled
);

-- Dữ liệu mẫu
INSERT INTO Appointments (doctor_id, patient_name, appt_date, start_time, end_time, status) VALUES
-- Bác sĩ 1: có ca Pending 9h-10h
(1, 'Nguyễn Văn A', '2024-04-10', '09:00:00', '10:00:00', 'Pending'),

-- Bác sĩ 1: có ca Cancelled 10h-11h → khung giờ này coi như trống
(1, 'Trần Thị B',   '2024-04-10', '10:00:00', '11:00:00', 'Cancelled'),

-- Bác sĩ 1: có ca Completed 14h-15h
(1, 'Lê Văn C',     '2024-04-10', '14:00:00', '15:00:00', 'Completed'),

-- Bác sĩ 2: có ca Pending 9h-10h
(2, 'Phạm Thị D',   '2024-04-10', '09:00:00', '10:00:00', 'Pending');

DELIMITER //
CREATE TRIGGER check_booking
BEFORE INSERT ON Appointments
FOR each row
BEGIN
	IF status!='Cancelled' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch khám trong khung giờ này!';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_booking_update
BEFORE UPDATE ON Appointments
for each row
BEGIN
	IF status!='Cancelled' AND id!=OLD.id THEN
     SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch khám trong khung giờ này!';
    END IF;
END //
DELIMITER ;