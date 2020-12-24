

INSERT INTO Station (IDStation, X, Y, Capacity)
VALUES ('RES1',0,2,15)
       ('SHE1',2,1,20)
       ('SHE2',4,1,20)
       ('SHE3',6,1,20)
       ('SHE4',8,1,20)
       ('SHE5',10,1,20)
       ('SHE6',2,3,20)
       ('SHE7',4,3,20)
       ('SHE8',6,3,20)
       ('SHE9',8,3,20)
       ('SHE10',10,3,20)
       ('DRS1',12,2,15)

INSERT INTO Pallet (IDPallet,Product,Quantity,Company,`Type`,Station)
VALUES ('PAL000001','Thinkpad X13 Gen1',5,'Lenovo','Nonpersihable','SHE1')
       ('PAL000002','Banana',20,'Chiquita','Persihable','SHE2')
       ('PAL000003','iPhone X',5,'Apple Inc.','Nonpersihable','SHE3')
       ('PAL000004','Crime And Punishment Book','Farrar, Straus and Giroux;',10,'Nonpersihable','SHE4')
       ('PAL000005','Codfish',10,'Tricana','Nonpersihable','SHE5')
       ('PAL000006','Stadium Arcadium Vinil',5,'Capitol Records','Nonpersihable','SHE6')
       ('PAL000007','The Brothers Karamazov Book',10,'Farrar, Straus and Giroux','Nonpersihable','SHE7')
       ('PAL000008','AirPods',9,'Apple Inc.','Nonpersihable','SHE8')
       ('PAL000009','Switch',2,'Nitendo','Nonpersihable','SHE9')
       ('PAL000010','Xbox Controller',1,'Microsoft','Nonpersihable','SHE10')

INSERT INTO Order(IDOrder,`Date`,Product,Quantity)
VALUES ('ORD000001','2021-2-1','Thinkpad X13',1)


