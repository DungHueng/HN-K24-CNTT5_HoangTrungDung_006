create database finalsql;
use finalsql;

#PHẦN 1: DDL – THIẾT KẾ CSDL
create table shippers(
	shipper_id int primary key auto_increment,
	full_name varchar(255) not null,
	phone varchar(255) unique,
	license_type varchar(255) not null,
	rating int default 5
);

create table vehicle_details(
	vehicle_id int primary key auto_increment,
	shipper_id int,
	license_plate varchar(255) unique,
	vehicle_type varchar(255) not null,
	max_payload int,

	foreign key (shipper_id) references shippers(shipper_id)
);

create table shipments(
	shipment_id int primary key auto_increment,
	product_name varchar(255) not null,
	weight int default 0,
	goods_value int default 0,
	status varchar(255) not null check(status in('In Transit', 'Delivered'))
);

create table delivery_orders(
	order_id int primary key auto_increment,
	shipment_id int,
	shipper_id int,
	order_date datetime default current_timestamp,
	delivery_fee int default 0,
	status varchar(255) not null check(status in('Processing', 'Finished')),
	foreign key (shipment_id) references shipments(shipment_id),
	foreign key (shipper_id) references shippers(shipper_id)
);

create table delivery_log(
	log_id int primary key auto_increment,
	order_id int,
	current_location varchar(255) not null,
	log_time datetime default current_timestamp not null,
	note text,
	foreign key (order_id) references delivery_orders(order_id)
);

#PHẦN 2: DML – INSERT, UPDATE, DELETE
insert into shippers(full_name, phone, license_type, rating) values
	('Nguyen Van An', '0901234567', 'C', 4.8),
	('Tran Thi Binh', '0912345678', 'A2', 5),
	('Le Hoang Nam', '0983456789', 'FC', 4.2),
	('Pham Minh Duc', '0354567890', 'B2', 4.9),
	('Hoang Quoc Viet', '0775678901', 'C', 4.7);

insert into vehicle_details(vehicle_id, shipper_id, license_plate, vehicle_type, max_payload) values
	('101', '1', '29C-123.45', 'Truck', 3500),
	('102', '2', '59A-888.88', 'Motorbike', 500),
	('103', '3', '15R-999.99', 'Container', 32000),
	('104', '4', '30F-111.22', 'Truck', 1500),
	('105', '5', '43C-444.55', 'Truck', 5000);

insert into shipments(shipment_id, product_name, weight, goods_value, status) values
	('5001', 'Smart TV Samsung 55 inch', 25.5, 15000000, 'In Transit'),
	('5002', 'Laptop Dell XPS', 2, 35000000, 'Delivered'),
	('5003', 'Industrial Air Compressor', 45, 120000000, 'In Transit'),
	('5004', 'Imported Fruit Boxes', 15, 2500000, 'Returned'),
	('5005', 'LG Inverter Washing Machine', 70, 9500000, 'In Transit');

insert into delivery_orders(order_id, shipment_id, shipper_id, order_date, delivery_fee, status) values
	('9001', '5001', '1', '2024-05-20 8:00:00', 2000000, 'Processing'),
	('9002', '5002', '2', '2024-05-20 9:30:00', 3500000, 'Finished'),
	('9003', '5003', '3', '2024-05-20 10:15:00', 2500000, 'Processing'),
	('9004', '5004', '5', '2024-05-21 7:00:00', 1500000, 'Finished'),
	('9005', '5005', '4', '2024-05-21 8:45:00', 2500000, 'Pending');

insert into delivery_log(log_id, order_id, current_location, log_time, note) values
	('1', '9001', 'Main Warehouse - Hanoi', '2024-05-15 8:15:00', 'Departed'),
	('2', '9001', 'Phu Ly Toll Station', '2024-05-17 10:00:00', 'In transit'),
	('3', '9002', 'District 1 - HCM', '2024-05-19 10:30:00', 'Arrived'),
	('4', '9003', 'Hai Phong Port', '2024-05-20 11:00:00', 'Departed'),
	('5', '9004', 'Return Warehouse - Da Nang', '2024-05-21 14:00:00', 'Returned');

#PHẦN 3: TRUY VẤN CƠ BẢN
#Câu 1: Liệt kê các thông tin phương tiện gồm license_plate, vehicle_type và max_payload của những phương tiện có trọng tải lớn hơn 5000 hoặc thuộc loại Container.
select license_plate, vehicle_type, max_payload from vehicle_details
where max_payload > 5000;

#Câu 2: Liệt kê các thông tin tài xế gồm full_name và phone_number của những tài xế có điểm đánh giá nằm trong khoảng từ 4.5 đến 5.0 và số điện thoại bắt đầu bằng “090”.
select full_name, phone from shippers
where phone_number = '090';

#Câu 3:Liệt kê các thông tin vận đơn gồm shipment_id, product_name và goods_value, trong đó danh sách được sắp xếp theo giá trị hàng hóa từ cao xuống thấp và chỉ hiển thị hai vận đơn ở trang thứ hai.
select shipment_id, product_name, goods_values from shipments 
order by good_values desc
limit 2;

#PHẦN 5: INDEX & VIEW
#Câu 1: Tạo một chỉ mục trên bảng shipments dựa trên hai thông tin là trạng thái vận đơn và giá trị hàng hóa nhằm phục vụ việc tối ưu truy vấn.
create index idx_shipments on shipments(goods_value);
create index idx_shipments on shipments(status);

#Câu 2: Tạo một khung nhìn dữ liệu hiển thị họ tên tài xế, tổng số phiếu giao hàng mà tài xế đã nhận và tổng doanh thu phí vận chuyển mà tài xế đó mang lại, trong đó không tính các phiếu giao hàng bị hủy.

