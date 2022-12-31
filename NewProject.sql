	USE MASTER
	GO

	IF EXISTS  (SELECT * FROM SYS.databases WHERE NAME = 'TIMECARD')
	DROP DATABASE TIMECARD

	USE MASTER
	CREATE DATABASE TimeCard
	GO


	----------------------------------------------------------------------------------------


	USE TimeCard
	GO
	CREATE SCHEMA Payment
	GO
	CREATE SCHEMA ProjectDetails
	GO
	CREATE SCHEMA CustomerDetails
	GO
	CREATE SCHEMA HumanResources
	GO


	---------------------------------------------------------------------------------------------------------



	 CREATE TABLE Employees(EmployeeID INT IDENTITY(1,1), FirstName VARCHAR(15),
	 LastName VARCHAR(15), Title VARCHAR(30), PhoneNumber VARCHAR(20), 
	 BillingRate FLOAT)
	 GO

	 CREATE TABLE Clients (ClientID int IDENTITY(1,1), CompanyName varchar(35), ClientAddress 
	 VARCHAR(50), City VARCHAR(20), StateZip VARCHAR(7), Country VARCHAR(30), 
	 ContactPerson VARCHAR(30), PhoneNumber VARCHAR(20))

	 GO

	 CREATE TABLE  Projects (ProjectID INT IDENTITY(1,1), ClientID INT,  
	 ProjectName VARCHAR(30), BillingEstimate MONEY, 
	 StartDate DATE, EndDate DATE)
	 GO

	 CREATE TABLE WorkCodes(WorkCodeID INT IDENTITY(1,1), WorkCodeDescription VARCHAR(35))
	 GO

	 CREATE TABLE  TimeCards(TimeCardID INT IDENTITY(1,1), EmployeeID INT, 
	 ProjectID INT, WorkCodeID INT,
	 DateIssued DATE, DaysWorked INT,
	 BillableHours INT, TotalCost MONEY)                     
	 GO
 
	 CREATE TABLE  ExpenseDetails
	 (ExpenseID INT IDENTITY(1,1), ExpenseDescription VARCHAR(35))
	 GO
 

	 CREATE TABLE TimeCardExpenses(TimeCardExpensID INT IDENTITY(1,1), TimeCardID INT, 
	 ExpenseID INT, ExpenseDate DATE, ProjectID INT, ExpenseAmount MONEY)
	 GO

	 CREATE TABLE PaymentMethod(PaymentMethodID INT IDENTITY(1,1), PaymentDescription varchar(35))
	 GO

	 CREATE TABLE Payments(PaymentID INT IDENTITY(1,1), ProjectID INT, PaymentAmount MONEY, PaymentDate DATE,
	 CreditCardNumber VARCHAR(20), CardHoldersName varchar(30), CreditCardExpiryDate DATE, PaymentMethodID INT)
	 GO


	--------------------------------------------------------------------------------------------------------


	 ALTER SCHEMA Humanresources
	 TRANSFER dbo.Employees
	 GO
	 ALTER SCHEMA customerdetails
	 TRANSFER dbo.clients
	 GO
	 ALTER SCHEMA projectdetails
	 TRANSFER dbo.ExpenseDetails
	 Go
	 ALTER SCHEMA ProjectDetails   
	 TRANSFER dbo.projects
	 GO
	 ALTER SCHEMA ProjectDetails
	 TRANSFER dbo.workCodes
	 GO
	 ALTER SCHEMA ProjectDetails
	 TRANSFER dbo.TimeCards
	 GO
	 ALTER SCHEMA Projectdetails
	 TRANSFER dbo.TimeCardExpenses
	 GO
	 ALTER SCHEMA Payment
	 TRANSFER dbo.PaymentMethod
	 GO
	 ALTER SCHEMA Payment
	 TRANSFER dbo.Payments
	 GO


	-----------------------------------------------------------------------------------------------------


	CREATE RULE When_X_is_zero_or_Less as @column_name > 0
	GO

-----------------------------------------------------------------------------------------------------


	 EXEC sp_bindrule When_X_is_zero_or_Less, 'Humanresources.employees.BillingRate';
	 GO
	 ALTER TABLE Humanresources.employees
	 ALTER COLUMN BillingRate FLOAT NOT NULL
	 GO
	 ALTER TABLE Humanresources.employees
	 ALTER COLUMN Title VARCHAR(30) NOT NULL
	 GO
	 ALTER TABLE Humanresources.employees
	 ALTER COLUMN phoneNumber VARCHAR(20) NOT NULL
	 GO
	 ALTER TABLE Humanresources.employees
	 ADD CONSTRAINT Check_Phone_Number 
	 CHECK(PhoneNumber LIKE '0[7-9][01]' + 
	 REPLICATE('[0-9]', 8)
	 OR PhoneNumber LIKE '+234[7-9][01]' +
	 REPLICATE('[0-9]', 8))
	 GO
	 ALTER TABLE Humanresources.employees
	 ADD CONSTRAINT Title_Not_Included CHECK(Title IN 
	 ( 'Trainee', 'Team member', 'Team Leader' ,'Project Manager')
	  OR Title IN ('Senior Project Manager'))
	 GO
	 ALTER TABLE Humanresources.employees
	 ALTER COLUMN FirstName VARCHAR(15) NOT NULL
	 GO
	 ALTER TABLE Humanresources.employees
	 ADD CONSTRAINT Emp_Pk PRIMARY KEY (EmployeeID)
	 GO


	 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	 ALTER TABLE CustomerDetails.clients
	 ADD CONSTRAINT Chk_Phone_Number 
	 CHECK(PhoneNumber LIKE '0[7-9][01]' +
	  REPLICATE('[0-9]', 8) OR PhoneNumber LIKE 
	 '+234[7-9][01]' + REPLICATE('[0-9]', 8))
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN PhoneNumber VARCHAR(20) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN companyName VARCHAR(35) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN ClientAddress VARCHAR(50) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN City VARCHAR(20) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN StateZip VARCHAR(7) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN Country VARCHAR(15) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ALTER COLUMN ContactPerson VARCHAR(30) NOT NULL
	 GO
	 ALTER TABLE CustomerDetails.clients
	 ADD CONSTRAINT ClientID_Pk PRIMARY KEY (ClientID)
	 GO


	------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
	 ALTER TABLE ProjectDetails.Projects
	 ALTER COLUMN ClientID INT NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ALTER COLUMN  ProjectName VARCHAR(30) NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ADD CONSTRAINT Proj_PK PRIMARY KEY (ProjectID)
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ALTER COLUMN StartDate DATE NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ALTER COLUMN EndDate DATE NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ADD CONSTRAINT EndDate_Greater CHECK(EndDate > StartDate) 
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ALTER COLUMN  BillingEstimate MONEY Not NULL
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ADD CONSTRAINT Amt_NotBelow_1000 CHECK(BillingEstimate > 1000)
	 GO
	 ALTER TABLE ProjectDetails.Projects
	 ADD CONSTRAINT ClientID_Fk_Occurred_because_the_ClientID_does_not_exist
	 FOREIGN KEY (ClientID) REFERENCES customerdetails.clients(ClientID)
	 ON UPDATE NO ACTION
	 ON DELETE CASCADE
 
	 GO

	 ----------------------------------------------------------------------------------------------------------------------------------------------------------


	 ALTER TABLE ProjectDetails.WorkCodes
	 ALTER COLUMN WorkCodeDescription VARCHAR(32) NOT NULL 
	 GO
	 ALTER TABLE ProjectDetails.WorkCodes
	 ADD CONSTRAINT WcID_Pk PRIMARY KEY (WorkCodeID)
	 GO


	 ------------------------------------------------------------------------------------------------------------------------------------------------------------


	 ALTER TABLE projectdetails.ExpenseDetails
	 ADD CONSTRAINT Chk_Exp_details CHECK(ExpenseDescription IN 
	 ('Repairs', 'Transportation', 'System accessaries replacement',
	 'Fuelling', 'Medicals'))

	 GO

	 ALTER TABLE projectdetails.ExpenseDetails
	 ALTER COLUMN ExpenseDescription VARCHAR(35) Not Null
	 GO
	 ALTER TABLE projectdetails.ExpenseDetails
	 ADD CONSTRAINT Expdt_PK PRIMARY KEY (ExpenseID)

	 GO


	-----------------------------------------------------------------------------------------------------------------------------------------------------------------



	 sp_bindrule When_X_is_zero_or_Less, 'ProjectDetails.Timecards.BillableHours'
	 GO
	 sp_bindrule When_X_is_zero_or_Less, 'ProjectDetails.Timecards.DaysWorked'
	 GO

	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN TotalCost MONEY  NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN BillableHours INT NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN WorkCodeID INT NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN DaysWorked INT NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN DateIssued DATE NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN EmployeeID INT NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ALTER COLUMN ProjectID INT  NOT NULL
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ADD CONSTRAINT Tmc_pk PRIMARY KEY (TimeCardID)
	 GO
	 ALTER TABLE ProjectDetails.Timecards
	 ADD CONSTRAINT FK_EmpID_Occurred_because_the_EmployeeID_does_not_exist 
	 FOREIGN KEY(EmployeeID) References Humanresources.employees(EmployeeID)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ADD CONSTRAINT WcID_Fk_Occurred_because_the_workcodeID_does_not_exist 
	 FOREIGN KEY(WorkCodeID) References ProjectDetails.WorkCodes(WorkCodeID)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION
	 GO
	 ALTER TABLE ProjectDetails.Timecards 
	 ADD CONSTRAINT ProID_Fk_Occurred_because_the_ProjectID_does_not_exist
	 FOREIGN KEY(ProjectID) References ProjectDetails.Projects(ProjectID)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION

	 GO


	 ---------------------------------------------------------------------------------------------------------------------------------------



	 sp_Bindrule When_X_is_zero_or_Less, 
	 'Projectdetails.TimeCardExpenses.ExpenseAmount'
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ADD CONSTRAINT TCE_PK PRIMARY KEY (TimeCardExpensID)
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ALTER COLUMN ExpenseDate DATE NOT NULL
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ALTER COLUMN TimeCardID INT NOT NULL
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ALTER COLUMN ExpenseID INT NOT NULL
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ALTER COLUMN ProjectID INT NOT NULL
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ADD CONSTRAINT TC_FK_Occurred_because_the_TimeCardID_does_not_exist
	  FOREIGN KEY (TimeCardID) references projectdetails.timecards(TimeCardID)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION
	 GO

	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ADD CONSTRAINT FK_ExpCID_Occurred_because_the_ExpenseID_does_not_exist
	 FOREIGN KEY (ExpenseID)REFERENCES projectdetails.ExpenseDetails(ExpenseID)
	 On DELETE CASCADE  
	 ON UPDATE NO ACTION
	 GO
	 ALTER TABLE Projectdetails.TimeCardExpenses
	 ADD CONSTRAINT FK_Proj_Occurred_because_the_ProjectID_does_not_exist 
	 FOREIGN KEY(ProjectID) REFERENCES projectdetails.Projects(ProjectID)
	 ON UPDATE NO ACTION
	 ON DELETE NO ACTION

	 GO
 
 
	 ------------------------------------------------------------------------------------------------------------------------------------------------
	 
 
	 ALTER TABLE payment.PaymentMethod
	 ADD CONSTRAINT PMM_PK PRIMARY KEY (PaymentMethodID)
	 GO
	 ALTER TABLE payment.PaymentMethod
	 ALTER COLUMN PaymentDescription VARCHAR(15) Not NULL 
	 GO
	 ALTER TABLE payment.PaymentMethod
	 ADD CONSTRAINT Pmm_not_included CHECK
	  (PaymentDescription IN ('Cash', 'Credit Card', 'Cheque')) 
	 GO



	------------------------------------------------------------------------------------------------------------------------------------------------------------



	 sp_bindrule When_X_is_zero_or_Less,
	 'payment.payments.PaymentAmount'
	 GO
	 ALTER TABLE Payment.payments
	 ADD ChequeNumber VARCHAR(10) Null
	 GO
	 ALTER TABLE Payment.payments
	 ADD CONSTRAINT When_Cheque_Num_not_6digids 
	 CHECK (ChequeNumber like '[1-9][0-9][0-9]' + 
	 REPLICATE('[0-9][0-9][0-9]',1))

	 GO
	 ALTER TABLE Payment.payments
	 ADD Balance MONEY
	 GO
	 ALTER TABLE Payment.payments
	 ADD [Status] VARCHAR(10)
	 GO
	 ALTER TABLE Payment.payments
	 ALTER COLUMN PaymentMethodID INT  NOT NULL
	 GO
	 ALTER TABLE Payment.payments
	 ALTER COLUMN ProjectID INT NOT NULL
	 GO
	 ALTER TABLE Payment.payments
	 ALTER COLUMN PaymentAmount MONEY NOT NULL
	 GO
	 ALTER TABLE Payment.payments
	 ALTER COLUMN CreditCardNumber VARCHAR(30) NULL
	 GO
	 ALTER TABLE Payment.payments
	 ADD CONSTRAINT When_Card_Num_not_16digits
	 CHECK (CreditCardNumber like '[1-9][0-9][0-9][0-9]' + 
	 REPLICATE('-[0-9][0-9][0-9][0-9]',3))
	 GO
	 ALTER TABLE Payment.payments
	 ALTER COLUMN CreditCardExpiryDate DATE NULL   
	 GO
	 ALTER TABLE Payment.payments
	 Alter column CardHoldersName VARCHAR(15)  NULL
	 GO
	 ALTER TABLE Payment.payments
	 ADD CONSTRAINT Pm_PK PRIMARY KEY (PaymentID)
	 GO
	 ALTER TABLE Payment.payments
	 ADD CONSTRAINT FK_Proj_Occurred_because_the_ProjectID_does_not_exist 
	 FOREIGN KEY (ProjectID) REFERENCES ProjectDetails.Projects(ProjectID)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION
	 GO
	 ALTER TABLE Payment.payments
	 ADD CONSTRAINT Pmt_Fk_Occurred_because_the_PaymentMethodID_does_not_exist 
	 FOREIGN KEY (PaymentMethodID) REFERENCES payment.PaymentMethod(PaymentMethodID)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION
	 GO
	 ALTER TABLE Payment.payments
	 ALTER COLUMN PaymentDate DATE NOT NULL
	 GO
 

 ------------------------------------------------------------------------------------------------------------------------------------------------


	 
  CREATE TRIGGER Tr_TimeCards_ChK ON ProjectDetails.Timecards
  INSTEAD OF INSERT AS BEGIN
  SET NOCOUNT ON
  DECLARE  @ProjectID INT,  @empID INT, @WorkCodeID INT,
  @DateIssued DATE, @DaysWorked INT, @BillableHours INT, @TotalCost MONEY, 
  @BillingRate FLOAT, @ProjectID2 INT, @empID2 INT, @TotalCost2 MONEY,
  @WorkcodeID2 INT, @DateIssued2 DATE ,  @BillableHours2 INT, @StartDate Date

    SELECT @ProjectID = ProjectID FROM inserted 
    SELECT @empID = EmployeeID FROM inserted
	SELECT @WorkCodeID = WorkCodeID FROM inserted
	SELECT @DateIssued = DateIssued FROM inserted
	SELECT @DaysWorked = DaysWorked FROM inserted
	SELECT @BillableHours = BillableHours FROM inserted

	SELECT @StartDate = StartDate FROM ProjectDetails.Projects
	WHERE ProjectID = @ProjectID
	SELECT @BillingRate = BillingRate FROM HumanResources.Employees 
	WHERE EmployeeID = @empID  
	      
		   SET @TotalCost = (@BillingRate *  @BillableHours)

	   IF @DateIssued <= GETDATE() OR @DateIssued <= @StartDate
	       BEGIN
		      PRINT 'INSERTION FAILED. Time Card date issued should be greater than current date and project start date.'
			  ROLLBACK
		   END
	  ELSE
	   BEGIN
	      IF Exists (Select EmployeeID, ProjectID, WorkCodeID  FROM ProjectDetails.Timecards 
	       WHERE EmployeeID = @empID)
		   BEGIN
		     PRINT 'INSERTION FAILED. The Employee exists on the table. An employee should not have more ' +
			       'than one TimeCard ID and should not be assigned more than one job on a project ' +
				   'and also sholud not be assigned more than one project at a time.'
			 ROLLBACK
		   END 
	   ELSE 
	       BEGIN 
			 INSERT INTO ProjectDetails.Timecards (EmployeeID,  ProjectID, WorkCodeID,
			 DateIssued, DaysWorked, BillableHours, TotalCost) 
			 values(@empID, @ProjectID, @WorkCodeID, 
			 @DateIssued, @DaysWorked, @BillableHours, @TotalCost) 
             PRINT 'The values inserted successfully.'
		  END		 	    
    END
   END
 GO


 ----------------------------------------------------------------------------------------------------------------------------------------------



 CREATE TRIGGER Tr_TimeCardExp_Chk ON ProjectDetails.TimeCardExpenses
 INSTEAD OF INSERT 
     AS BEGIN
			 DECLARE @TimeCardID INT, @TimeCardID2 INT, @ExpenseID INT,
			         @ExpenseID2 INT, @projectID INT, @projectID2 INT,
					 @ExpenseDate DATE,  @ExpenseDate2 DATE, @DateIssued DATE,
					 @Amount MONEY, @Amount2 MONEY, @EndDate DATE, @count INT 

			 SELECT  @TimeCardID2 = TimeCardID FROM inserted
			 SELECT  @ExpenseID2  =   ExpenseID FROM inserted
			 SELECT  @projectID2 = ProjectID FROM inserted
			 SELECT  @ExpenseDate2 = ExpenseDate FROM inserted
			 SELECT  @Amount2 = ExpenseAmount FROM inserted
			 SELECT  @EndDate = EndDate FROM ProjectDetails.Projects
			         WHERE ProjectID = @projectID2 
			                                                                                 
			 SELECT  @TimeCardID = TimeCardID FROM ProjectDetails.TimeCardExpenses
			         Where ProjectID = @projectID2
			 SELECT  @ExpenseID = ExpenseID FROM ProjectDetails.TimeCardExpenses
			         Where ProjectID = @projectID2
			 SELECT  @projectID = ProjectID FROM ProjectDetails.TimeCardExpenses
			         Where ProjectID = @projectID2
			 SELECT  @ExpenseDate = ExpenseDate FROM ProjectDetails.TimeCardExpenses
			         Where TimeCardID = @TimeCardID2
			 SELECT  @Amount = ExpenseAmount FROM ProjectDetails.TimeCardExpenses
			         Where TimeCardID = @TimeCardID2
			SELECT  @DateIssued = DateIssued FROM ProjectDetails.TimeCards

			 IF @ProjectID2 NOT IN (SELECT projectID FROM ProjectDetails.Projects) 
		         BEGIN
			           PRINT 'INSERTION FAILED. Invalid Project ID'
			           ROLLBACK
		           END 
			 ELSE
			      BEGIN 
				       IF @TimeCardID2 NOT IN (SELECT TimeCardID FROM ProjectDetails.TimeCards) 
					       BEGIN
							 PRINT 'INSERTION FAILED. Invalid Time Card ID'
							 ROLLBACK
						  END
			 ELSE 
			      BEGIN

			           IF @ExpenseDate2 > @EndDate OR @ExpenseDate2 < @DateIssued
		                  BEGIN  
		                      PRINT 'INSERTION FAILED. The expense date is less than the Time Card issued date or greater than the project end date.'
			                  ROLLBACK
		                    END 
			  ELSE
			       BEGIN
				        IF @TimeCardID = @TimeCardID2 AND @ExpenseID = @ExpenseID2 AND @projectID = @projectID2 
					        BEGIN
				                PRINT 'INSERTION FAILED. The record exists on the table.'
		        	            ROLLBACK
				             END 
			  ELSE
				   BEGIN
					     IF @projectID2 NOT IN  (SELECT ProjectID FROM ProjectDetails.TimeCards WHERE TimeCardID = @TimeCardID2)
				            BEGIN
					           PRINT 'INSERTION FAILED. The Time Card expeses is being assigned to more than one project.'
					           ROLLBACK
					        END
				ELSE
				     BEGIN
					   INSERT INTO ProjectDetails.TimeCardExpenses
					   (TimeCardID, ExpenseID, ExpenseDate, ProjectID,ExpenseAmount)
					   VALUES(@TimeCardID2, @ExpenseID2, @ExpenseDate2, @projectID2,@Amount2)

					   PRINT 'The values inserted Successfully.'
					END
				  END   
	     	  END
		  END
	    END
	  END 

GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------


 
CREATE TRIGGER Tr_Payment_Chk ON Payment.Payments
  INSTEAD OF INSERT AS
  BEGIN
        SET NOCOUNT ON
	    DECLARE 
	        @ProjectID INT, @PaymentAmount MONEY, @PaymentDate DATE, @CardNumber VARCHAR(20),
			@CardName VARCHAR(30), @CardExpiryDate DATE, @PmMethodID INT, @ChequeNo VARCHAR(10),
			@EndDate DATE, @Pro_Bil_Estimate MONEY, @PaidAmount MONEY, @Balance MONEY,
			@paymentMethod VARCHAR(15), @PaymentID INT, @MaxID INT, @Status VARCHAR(15)
       
			SELECT @ProjectID = ProjectID FROM inserted
			SELECT @PaymentAmount = PaymentAmount FROM inserted
			SELECT @PaymentDate = PaymentDate FROM inserted
			SELECT @CardNumber = CreditCardNumber FROM inserted
			SELECT @CardName = CardHoldersName FROM inserted
			SELECT @CardExpiryDate = CreditCardExpiryDate FROM inserted
			SELECT @PmMethodID = PaymentMethodID FROM inserted	
			SELECT @ChequeNo = ChequeNumber FROM inserted
			SELECT @EndDate = EndDate, @Pro_Bil_Estimate = BillingEstimate 
			       FROM ProjectDetails.Projects WHERE ProjectID = @ProjectID

			SET @PaidAmount = (SELECT SUM(PaymentAmount) FROM Payment.Payments WHERE ProjectID = @ProjectID
					GROUP BY ProjectID)

			SET @paymentMethod  = (Select PaymentDescription FROM Payment.PaymentMethod WHERE 
			             PaymentMethodID = @PmMethodID)

			IF @paymentMethod IS NULL
				  BEGIN
						PRINT 'PAYMENT UNSUCCESSFUL. We are sorry we do not accept the Payment Option'
						PRINT ' '
						ROLLBACK
				  END
			ELSE
				 BEGIN
					  IF @PaidAmount IS NULL 
						 BEGIN
							  SET @Balance = @Pro_Bil_Estimate - @PaymentAmount
						 END 
				  
			ELSE
				 BEGIN
					  SET @Balance = @Pro_Bil_Estimate - ( @PaidAmount + @PaymentAmount)
				 END
			END

			     SELECT @Status = IIF (@Balance > 0, 'Pending','PAID')   
			 
				IF @PaymentAmount > @Pro_Bil_Estimate AND @PaidAmount is null    
					BEGIN 
						PRINT 'ProJect Billing Eastimate: '+  CAST(@Pro_Bil_Estimate AS VARCHAR(30))
						PRINT 'Amount being paid:'+ ' ' +CAST(@PaymentAmount AS VARCHAR(30))
						PRINT 'PAYMENT UNSUCCESSFUL. We noticed over payment in the account. The exceeding amount: ' +
						CAST(@PaymentAmount -  @Pro_Bil_Estimate AS VARCHAR(100))
						ROllBack 
					END 
			ELSE 
				 BEGIN     
					   IF @PaymentDate <= @EndDate 
							BEGIN
								PRINT 'PAYMENT UNSUCCESSFUL. Payment date should be greater than the Project end date.'
								ROLLBACK
							END
			ELSE
				 BEGIN 
					   IF @CardExpiryDate <= GetDate() AND @paymentMethod IS NOT NULL
					      BEGIN
						      PRINT 'PAYMENT UNSUCCESSFUL. The Credit Card has expired.'
						      ROLLBACK
					      END 
			ELSE
				 BEGIN
					   IF @Balance < @PaymentAmount AND @PaidAmount IS NOT NULL AND @Balance < 0  
		    				BEGIN  PRINT 'Balance: '+ CAST((@Pro_Bil_Estimate - @PaidAmount) AS VARCHAR(30))
								  PRINT 'PAYMENT UNSUCCESSFUL. We noticed over payment in the account. The exceeding amount: '   
								  + CAST((@PaymentAmount + @PaidAmount - @Pro_Bil_Estimate) AS VARCHAR(100))            

								  ROLLBACK
						    END
		   ELSE
		        BEGIN 
					   IF @CardNumber IS NOT NULL AND @CardName IS NOT NULL AND  @CardExpiryDate IS NOT NULL AND @ChequeNo IS NULL
						  AND @paymentMethod = 'CREDIT CARD' AND @CardNumber IN (SELECT DISTINCT(CreditCardNumber) FROM Payment.Payments 
						  WHERE CreditCardNumber IS NOT NULL) AND @CardName != ''
						  BEGIN	  
						     DECLARE @CardName2 VARCHAR(30), @CardExpiryDate2 DATE
							 SET @CardName2 = (SELECT  DISTINCT(CardHoldersName) FROM Payment.Payments WHERE CreditCardNumber = @CardNumber)
						     SET @CardExpiryDate2 = (SELECT  DISTINCT(CreditCardExpiryDate) FROM Payment.Payments WHERE CreditCardNumber = @CardNumber)
							   IF @CardName = @CardName2 AND @CardExpiryDate = @CardExpiryDate2 
							      BEGIN
										INSERT INTO Payment.Payments 
										(ProjectID, PaymentAmount, PaymentDate, CreditCardNumber, CardHoldersName,
										CreditCardExpiryDate, PaymentMethodID, Balance, [Status]) VALUES(@ProjectID, @PaymentAmount, 
										@PaymentDate, @CardNumber, @CardName, @CardExpiryDate, @PmMethodID, @Balance, @Status)
			 
										PRINT 'PAYMENT SUCCESSFUL.'
										PRINT ' '

										SELECT @MaxID = MAX(PaymentID) FROM Payment.Payments
										Select @PaymentID = PaymentID FROM Payment.Payments where PaymentID = @MaxID

										PRINT 'PmtID ' + CAST(@PaymentID AS VARCHAR(5)) + ' | ProjID : ' +   CAST(@ProjectID AS VARCHAR(5)) 
										+ ' | PmtAmt: ' +  CAST(@PaymentAmount AS VARCHAR(30)) + ' | PmtDate: ' + CAST(@PaymentDate AS VARCHAR(20)) + 
										' | Card Number: ' + @CardNumber + ' | Card Holder Name: ' + @CardName
										+ ' | Card Expiry Date: ' + CAST(@CardExpiryDate AS VARCHAR(20)) + ' | PmtMethod: '+ CAST(@PmMethodID AS VARCHAR(10)) +
										' | Bal: '  + CAST(@Balance AS VARCHAR(50)) + ' | Status: ' + @Status
						         END
						   END
					   
				 
					   IF @CardNumber IS NOT NULL AND @CardName IS NOT NULL AND  @CardExpiryDate IS NOT NULL AND @ChequeNo IS NULL
								AND @paymentMethod = 'CREDIT CARD' AND @CardNumber NOT IN (SELECT DISTINCT(CreditCardNumber) FROM Payment.Payments WHERE
								CreditCardNumber IS NOT NULL) AND @CardName != ''
								BEGIN	  
									INSERT INTO Payment.Payments 
											(ProjectID, PaymentAmount, PaymentDate, CreditCardNumber, CardHoldersName,
											CreditCardExpiryDate, PaymentMethodID, Balance, [Status]) VALUES(@ProjectID, @PaymentAmount, 
											@PaymentDate, @CardNumber, @CardName, @CardExpiryDate, @PmMethodID, @Balance, @Status)
			 
											PRINT 'PAYMENT SUCCESSFUL.'
											PRINT ' '

											SELECT @MaxID = MAX(PaymentID) FROM Payment.Payments
											Select @PaymentID = PaymentID FROM Payment.Payments where PaymentID = @MaxID

											PRINT 'PmtID ' + CAST(@PaymentID AS VARCHAR(5)) + ' | ProjID : ' +   CAST(@ProjectID AS VARCHAR(5)) 
											+ ' | PmtAmt: ' +  CAST(@PaymentAmount AS VARCHAR(30)) + ' | PmtDate: ' + CAST(@PaymentDate AS VARCHAR(20)) + 
											' | Card Number: ' + @CardNumber + ' | Card Holder Name: ' + @CardName
											+ ' | Card Expiry Date: ' + CAST(@CardExpiryDate AS VARCHAR(20)) + ' | PmtMethod: '+ CAST(@PmMethodID AS VARCHAR(10)) +
											' | Bal: '  + CAST(@Balance AS VARCHAR(50)) + ' | Status: ' + @Status
								END
							
			ELSE     

				    BEGIN 
					      IF @CardNumber IS NOT NULL AND @CardName IS NOT NULL AND  @CardExpiryDate IS NOT NULL AND @ChequeNo IS NULL
						  AND @paymentMethod = 'CREDIT CARD' AND  EXISTS (SELECT DISTINCT(CardHoldersName) FROM Payment.Payments 
						  WHERE CreditCardNumber = @CardNumber)
							  BEGIN	  
								 DECLARE @CardName3 VARCHAR(30), @CardExpiryDate3 DATE
								 SET @CardName3 = (SELECT  DISTINCT(CardHoldersName) FROM Payment.Payments WHERE CreditCardNumber = @CardNumber)
								 SET @CardExpiryDate3 = (SELECT  DISTINCT(CreditCardExpiryDate) FROM Payment.Payments WHERE CreditCardNumber = @CardNumber)
								   IF @CardName != @CardName3 OR @CardExpiryDate != @CardExpiryDate3 
									 BEGIN
										 PRINT'PAYMENT UNSUCCESSFUL. The name or expiry date entered is inconsistent with the credit card record with us.'
										 print  'Info: | Name: ' + CAST(@CardName3 AS VARCHAR(35)) + ' | Number: ' + CAST(@CardNumber AS VARCHAR(20))
										       + ' | Expiry Date: ' + CAST(@CardExpiryDate3 AS VARCHAR(20))
										 ROLLBACK
									END
							 END
			ELSE	
			
                  BEGIN            
				                  	    
					   IF @CardNumber  IS NULL AND @CardName IS NULL AND @CardExpiryDate IS NULL AND @ChequeNo IS NULL
					      AND @paymentMethod = 'CASH'  
						   BEGIN
		          				INSERT INTO Payment.Payments (ProjectID, PaymentAmount, PaymentDate, 
								PaymentMethodID, Balance, [Status]) VALUES(@ProjectID, @PaymentAmount, @PaymentDate, 
								@PmMethodID, @Balance, @Status)

								PRINT 'PAYMENT SUCCESSFUL.'
								PRINT ' '

								SELECT @MaxID = MAX(PaymentID) FROM Payment.Payments
								SELECT @PaymentID = PaymentID  FROM Payment.Payments WHERE PaymentID = @MaxID 
								 
								PRINT 'PmtID ' + CAST(@PaymentID as varchar(5)) + ' | ProjID : ' +   cast(@ProjectID AS VARCHAR(5)) 
								+ ' | PmtAmt: ' +  CAST(@PaymentAmount as varchar(30)) + ' | PmtDate: ' + 
								CAST(@PaymentDate as VARCHAR(20))  + ' | PmMethod: '+ CAST(@PmMethodID AS VARCHAR(10)) +
								' | Bal: '  + CAST(@Balance AS VARCHAR(50)) + ' | Status: '+ @Status
						   END 
				
		    ELSE
				 BEGIN 
					   IF @paymentMethod = 'CHEQUE' AND @CardNumber IS NULL AND @CardName IS NULL AND @CardExpiryDate IS NULL 
					      AND @ChequeNo IS NOT NULL	
						  BEGIN
								INSERT INTO Payment.Payments (ProjectID, PaymentAmount, PaymentDate, 
								PaymentMethodID, ChequeNumber, Balance, [Status]) 
								VALUES(@ProjectID, @PaymentAmount, @PaymentDate, @PmMethodID, @ChequeNo, @Balance, @Status)
								 
								PRINT 'PAYMENT SUCCESSFUL.'
								PRINT ' '

								SELECT @MaxID = MAX(PaymentID) FROM Payment.Payments
								SELECT @PaymentID = PaymentID  FROM Payment.Payments where PaymentID = @MaxID 
								 
								PRINT 'PmtID ' + CAST(@PaymentID AS VARCHAR(5)) + ' | ProjID : ' +   CAST(@ProjectID as varchar(5)) 
					    			+ ' | PmtAmt: ' +  CAST(@PaymentAmount AS VARCHAR(30)) + ' | PmtDate: ' + 
									CAST(@PaymentDate AS VARCHAR(20)) + + ' | PmMethod: '+ CAST(@PmMethodID AS VARCHAR(10)) + 
									' | Cheque Number: ' + @ChequeNo  +' | Bal: '  + CAST(@Balance AS VARCHAR(50)) +
									' | Status: '+ @Status
						    END 

				ELSE 
				     BEGIN  

						IF @paymentMethod = 'CHEQUE' 
						   BEGIN   
								PRINT ' '
								PRINT UPPER(@paymentMethod) + ' PAYEMENT UNSUCCESSFUL.....'
								PRINT 'The ' + @paymentMethod + ' number is NULL ' + 
								      ' or it is being used with other payment methods simultaneously'
								ROLLBACK
						   END
			ELSE 
				 BEGIN
					   IF @paymentMethod = 'CREDIT CARD' 
						  BEGIN
								PRINT ' '
								PRINT UPPER(@paymentMethod) + ' PAYEMENT UNSUCCESSFUL.....'   
								PRINT 'One or more values of the ' + @paymentMethod + ' are NULL or empty ' +  
								      'or it is being used with other payment methods simultaneously'
					    		ROLLBACK
						  END
			ELSE 
				 BEGIN  
				       IF @paymentMethod = 'CASH'
						  BEGIN    
								PRINT UPPER(@paymentMethod) +' PAYEMENT UNSUCCESSFUL.....'
								PRINT 'it is being used with other payment methods simultaneously' 
	     	    				ROLLBACK
				         END
				       END
			         END        
			      END
		        END     
		      END
	        END
	       END
         END
        END
	  END
	 END
	
	  			 
			
GO	
	
	  			 
		
-----------------------------------------------------------------------------------------------------------------------------

		
		
	CREATE TRIGGER Tr_Chk_Duplicate_Project ON ProjectDetails.Projects
	INSTEAD OF INSERT AS BEGIN 
	SET NOCOUNT ON
				DECLARE @ProjactName VARCHAR(30), @ClientID INT,
						@Tab_ClientID INT, @Tab_ProjectName VARCHAR(30), @Count INT,
						@BillingEstimate MONEY, @StartDate DATE, @EndDate DATE
						SELECT @ProjactName = ProjectName FROM Inserted
						SELECT @ClientID = ClientID FROM Inserted
						SELECT @BillingEstimate = BillingEstimate FROM Inserted
						SELECT @StartDate = StartDate FROM Inserted
						SELECT @EndDate = EndDate FROM Inserted 

				 IF @StartDate <= GETDATE() 
				    BEGIN
					     PRINT 'INSERTION FAILED. A project start date should be greater than current date.'
						 ROLLBACK
					END
			ELSE
				BEGIN

				 IF EXISTS(SELECT ProjectName, ClientID FROM ProjectDetails.Projects
				     WHERE ProjectName = @ProjactName and ClientID = @ClientID)
					   BEGIN
					       PRINT'INSERTION FAILED. The Project exists on the table.'
						   ROLLBACK
					   END 
				 ELSE 
					   BEGIN
						    INSERT INTO ProjectDetails.Projects (ClientID, ProjectName,
							BillingEstimate, StartDate, EndDate) 
							VALUES (@ClientID, @ProjactName, @BillingEstimate,  @StartDate,@EndDate)
							PRINT 'The values inserted successfully.'
					   END
				END
			END				
								
	    GO



--------------------------------------------------------------------------------------------------------------------------------



	CREATE TRIGGER Tr_Duplicate_Inst_Chk ON HumanResources.Employees
	INSTEAD OF INSERT AS BEGIN 
	SET NOCOUNT ON
				DECLARE @FirstName VARCHAR(20), @LastName VARCHAR(30), @Title VARCHAR(50),
				@PhoneNum VARCHAR(18), @BillingRate MONEY
				SELECT @FirstName  = FirstName FROM Inserted
				SELECT @LastName = LastName FROM Inserted
				SELECT @Title = Title FROM Inserted
				SELECT @PhoneNum = PhoneNumber From Inserted
				SELECT @BillingRate = BillingRate FROM Inserted

				IF @PhoneNum IN (SELECT PhoneNumber FROM HumanResources.Employees 
					 WHERE PhoneNumber = @PhoneNum)
				     Begin
				         PRINT'INSERTION FAILED. The employee record exists on the table.'
					     ROLLBACK
					 END 
				ELSE
					 BEGIN
						 INSERT INTO HumanResources.Employees (FirstName, LastName, Title,
						 PhoneNumber, BillingRate) VALUES (@FirstName, @LastName , @Title,
				         @PhoneNum, @BillingRate)
						 PRINT 'The values inserted successfully.'
					END
				END			  
			 GO		
	
	

--------------------------------------------------------------------------------------------------------------------------------

		
	
	CREATE TRIGGER Tr_Duplicate_Constraint_Client ON CustomerDetails.Clients
	INSTEAD OF INSERT AS BEGIN 
	SET NOCOUNT ON
				DECLARE @CompanyName VARCHAR(50), @Address VARCHAR(50), @City VARCHAR(20),
				@StateZip VARCHAR(7), @Country VARCHAR(15), @ContactPerson VARCHAR(18),
				@PhoneNum VARCHAR(18)
				SELECT @CompanyName  = CompanyName FROM Inserted
				SELECT @Address = ClientAddress From inserted
				SELECT @City= City FROM inserted
				SELECT @StateZip = StateZip FROM Inserted
				SELECT @Country = Country FROM Inserted
				SELECT @ContactPerson = ContactPerson FROM Inserted
				SELECT @PhoneNum = PhoneNumber FROM Inserted

				 IF EXISTS(SELECT CompanyName, PhoneNumber, ClientAddress FROM CustomerDetails.Clients
				     WHERE CompanyName = @CompanyName OR PhoneNumber  = @PhoneNum OR ClientAddress = @Address)
				     BEGIN
				          PRINT 'INSERTION FAILED. The Client record exists on the table.'
					      ROLLBACK
					 END 
				 ELSE
					 BEGIN
						 INSERT INTO CustomerDetails.Clients (CompanyName, ClientAddress, 
						 City, StateZip, Country, ContactPerson,PhoneNumber) 
						 VALUES (@CompanyName, @Address, 
						 @City, @StateZip, @Country, @ContactPerson, @PhoneNum)
						 PRINT 'The values inserted successfully.'
					END
				END
    
	GO



-----------------------------------------------------------------------------------------------------------



  CREATE TRIGGER Tr_Pmt_Method ON Payment.PaymentMethod
  FOR INSERT As BEGIN
	  BEGIN
		   SET NOCOUNT ON
			DECLARE 
				@Count INT, @Insert_Pm_Desc VARCHAR(30)
				SELECT @Insert_Pm_Desc = PaymentDescription FROM Inserted
				SELECT @count = COUNT(PaymentDescription) FROM Payment.PaymentMethod 
				WHERE PaymentDescription = @Insert_Pm_Desc	
				
				IF @Count = 1		
				    BEGIN
	        	       PRINT'The value insert Secussfully.'
				    END
                ELSE 
				    BEGIN
					   PRINT'INSERTION FAILED. The Payment Method exists on the table.'
     	    		   ROLLBACK
				    END	 
			   END
		END
		
	GO	  
	 

--------------------------------------------------------------------------------------------------------


  CREATE TRIGGER Tr_Delete_constraint ON Payment.payments
		 FOR DELETE AS BEGIN
		         PRINT'PERMISSION DENIED.'
				 ROLLBACK
		 END
		


GO

-----------------------------------------------------------------------------------------------------------
 CREATE PROC PROC_FOR_DELETE_FROM_PROJECT_TABLE 
		@PROJECTID INT, @keyword VARCHAR(10)
		AS BEGIN
		        IF NOT EXISTS(SELECT projectID from ProjectDetails.Projects WHERE ProjectID = @PROJECTID)
				    BEGIN
				        PRINT'The ProjectID does not exist on the table.' 
				    END
		        ELSE
					BEGIN
						DECLARE @password VARCHAR(10)
						SET  @Password = 'log!-419'
						IF @keyword != @password
						BEGIN 
							PRINT'PERMISSION DENIED.'
					    END
				ELSE
					BEGIN
					 IF EXISTS(SELECT ProjectID from Payment.payments WHERE ProjectID = @PROJECTID)
						DISABLE TRIGGER Payment.Tr_Delete_constraint ON Payment.payments			   	       
						DELETE FROM ProjectDetails.Projects WHERE ProjectID = @PROJECTID
						
		  
					 IF NOT EXISTS(SELECT ProjectID from Payment.payments WHERE ProjectID = @PROJECTID)
						ENABLE TRIGGER Payment.Tr_Delete_constraint ON Payment.payments
					    PRINT'Delete successful'	  
			  
			     END 
			 END  	          
	    END

  		    

  GO
		 
 ---------------------------------------------------------------------------------------------------------------------------

 CREATE PROC PROC_FOR_DELETE_FROM_PAYMENT_TABLE 
		@PaymentID INT, @keyword VARCHAR(10)
		AS BEGIN
		         IF NOT EXISTS(SELECT projectID from Payment.payments WHERE ProjectID = @PaymentID)
				    BEGIN
				        PRINT'The Project does not exist on the table.' 
				    END
		        ELSE 
			        BEGIN  
						DECLARE @password VARCHAR(10)
						SET  @Password = 'log!-419'

						IF @keyword != @password
						   BEGIN 
							   PRINT'PERMISSION DENIED.'
							   ROLLBACK
					       END
			    ELSE
				   BEGIN
						 IF EXISTS(SELECT projectID from Payment.payments WHERE PaymentID = @PaymentID)
							DISABLE TRIGGER Payment.Tr_Delete_constraint ON Payment.payments			   	       
							DELETE FROM Payment.payments WHERE PaymentID = @PaymentID
						
		              
						 IF NOT EXISTS(SELECT projectID from Payment.payments WHERE PaymentID = @PaymentID)
							ENABLE TRIGGER Payment.Tr_Delete_constraint ON Payment.payments	
							PRINT'Delete successful'
					END

			  END
					   
		  END   	           
	 

GO

 ----------------------------------------------------------------------------------------------------------------------------

 
  CREATE TRIGGER Tr_Payment_Table_Update_constraint ON Payment.payments
	FOR UPDATE AS 	         
	  BEGIN	   
		    PRINT'PERMISSION DENIED.'
		    ROLLBACK
      END
		
 

GO


---------------------------------------------------------------------------------------------------------------------

  
	CREATE TRIGGER ProjectDetails.Tr_Projects_Table_Update_constraint ON ProjectDetails.projects
	FOR UPDATE AS 	         
	  BEGIN

		   IF (UPDATE(BILLINGESTIMATE)) 
		      BEGIN
		          PRINT 'PERMISSION DENIED.'
			      ROLLBACK	
		   END
	  END
 GO


------------------------------------------------------------------------------------------------------------------


  CREATE TRIGGER Tr_Employees_Table_Update_constraint ON HumanResources.Employees
	 FOR UPDATE As 	         
		BEGIN
		   IF (UPDATE(BillingRate))
		      BEGIN
		         PRINT 'PERMISSION DENIED.'
		         ROLLBACK
		      END
		  ELSE
		      BEGIN
    	         PRINT'Update Successful'  
		 END
     END
 GO


---------------------------------------------------------------------------------------------------------------------



  CREATE TRIGGER Tr_TimeCards_Table_Update_constraint ON ProjectDetails.Timecards
		 FOR UPDATE AS 	         
	 BEGIN
		   PRINT 'PERMISSION DENIED.'
		   ROLLBACK
	  END
   
  GO


---------------------------------------------------------------------------------------------------------------------



  CREATE TRIGGER Tr_TimeCardExpenses__Table_Update_constraint ON ProjectDetails.TimeCardExpenses
	 FOR UPDATE As 	         
	 BEGIN
		  IF (UPDATE(ExpenseAmount))
		      BEGIN
		         PRINT'PERMISSION DENIED.'
		         ROLLBACK 
		     END
		  ELSE
		     BEGIN
		         PRINT'Update successful.'
		 END
     END
		
  GO


 -----------------------------------------------------------------------------------------------------------------------



  CREATE TRIGGER Tr_WorkCode_Duplicate_Chk ON ProjectDetails.Workcodes
  FOR INSERT AS BEGIN SET NOCOUNT ON
		DECLARE @WDescription VARCHAR(30), @count VARCHAR(30)

		SELECT @WDescription = WorkCodeDescription FROM inserted
		SELECT @count = COUNT(WorkCodeDescription) FROM ProjectDetails.Workcodes 
				WHERE WorkCodeDescription = @WDescription
				
			IF @count > 1
			    BEGIN
					PRINT'INSERTION FAILED! The description exists on the table.'
					ROLLBACK
				END
			ELSE 
				BEGIN
					PRINT'The Value Inserted successfully.'
				END
		END

GO	

			   
		 
--------------------------------------------------------------------------------------------------------------------------------------------



  CREATE TRIGGER Tr_Exp_Details_Duplicate_Chk ON ProjectDetails.ExpenseDetails
  FOR INSERT AS BEGIN
  SET NOCOUNT ON
		    DECLARE @Exp_Description VARCHAR(30), @count VARCHAR(30)

			SELECT @Exp_Description = ExpenseDescription FROM inserted
			SELECT @count = COUNT(ExpenseDescription) FROM ProjectDetails.ExpenseDetails 
				   WHERE ExpenseDescription = @Exp_Description
				
			IF @count > 1
			     BEGIN
					  PRINT('INSERTION FAILED! The description exists on the table.')
					  ROLLBACK
				 END
			ELSE 
				BEGIN
					PRINT'The Value Inserted successfully.'
	 		   END
		 END	
				   
  GO

-------------------------------------------------------------------------------------------------------------------------------------------------------------------



 CREATE PROC PROC_FOR_INSERT_INTO_PAYMENT_TABLE_CREDIT_CARD_PAYMENT
	@ProjectID INT, @PaymentAmount MONEY, @PaymentDate DATE, @CardNumber VARCHAR(35),
	@CardName VARCHAR(30), @CardExpiryDate DATE
    AS BEGIN 
	       IF @ProjectID NOT IN (SELECT ProjectID FROM ProjectDetails.Projects)
			      BEGIN
			          PRINT 'Invalid Project ID.'
				  END
	   ELSE
	        BEGIN
            
		IF @CardNumber IS NOT NULL 
		   BEGIN
				DECLARE  @PaymentMethodID INT, @PmID VARCHAR(30)
				SET @PmID = 'CREDIT CARD'
				SET @PaymentMethodID  = (SELECT PaymentMethodID FROM TimeCard.Payment.PaymentMethod 
	 			WHERE PaymentDescription = @PmID)
			
				INSERT INTO TimeCard.Payment.Payments 
				(ProjectID, PaymentAmount, PaymentDate, CreditCardNumber, CardHoldersName,
				CreditCardExpiryDate, PaymentMethodID) VALUES
				(@ProjectID, @PaymentAmount,  @PaymentDate, @CardNumber, 
				@CardName, @CardExpiryDate, @PaymentMethodID)
			END
		ELSE
			BEGIN
				Print  'Please enter the Credit Card number.'			 
			END
		END
    END
GO	

		
---------------------------------------------------------------------------------------------------------------------------------------------------------		 
		

  CREATE PROC PROC_FOR_INSERT_CHEQUE_PAYMENT_INTO_PAYMENT_TABLE		
   @ProjectID INT, @PaymentAmount MONEY, @PaymentDate DATE,
   @ChequeNumber VARCHAR(30)
   AS BEGIN
         IF @ProjectID NOT IN (SELECT ProjectID FROM ProjectDetails.Projects)
			      BEGIN
			          PRINT 'Invalid Project ID.'
				  END
	   ELSE
	        BEGIN 
	         
		IF @ChequeNumber IS NOT NULL
            BEGIN
			    DECLARE  @PaymentMethodID INT, @PmID VARCHAR(30)
				SET @PmID = 'CHEQUE'
			    SET @PaymentMethodID  = (SELECT PaymentMethodID FROM TimeCard.Payment.PaymentMethod 
			    WHERE PaymentDescription = @PmID)
			
				INSERT INTO TimeCard.Payment.Payments 
				(ProjectID, PaymentAmount, PaymentDate, PaymentMethodID, ChequeNumber) VALUES
				(@ProjectID, @PaymentAmount,  @PaymentDate, @PaymentMethodID, @ChequeNumber)
		    END
		ELSE
		    BEGIN
			    PRINT 'Please enter cheque number.'
		END
     END
END		  


GO


--------------------------------------------------------------------------------------------------------------------------------



  CREATE PROC PROC_FOR_INSERT_CASH_PAYMENT_INTO_PAYMENT_TABLE		
	@ProjectID INT, @PaymentAmount MONEY, @PaymentDate DATE
    AS BEGIN 
	         IF @ProjectID NOT IN (SELECT ProjectID FROM ProjectDetails.Projects)
			      BEGIN
			          PRINT 'Invalid Project ID.'
				  END
	   ELSE
	        BEGIN
	       
				DECLARE  @PaymentMethodID INT, @PmID VARCHAR(30)
					
				SET @PmID = 'CASH'

				SET @PaymentMethodID  = (SELECT PaymentMethodID FROM TimeCard.Payment.PaymentMethod 
				WHERE PaymentDescription = @PmID)

				INSERT INTO TimeCard.Payment.Payments 
				(ProjectID, PaymentAmount, PaymentDate, PaymentMethodID) VALUES
				(@ProjectID, @PaymentAmount,  @PaymentDate, @PaymentMethodID)
		END
	 END
GO



-----------------------------------------------------------------------------------------------------------------------------


  CREATE TRIGGER NO_DROP_TABLE ON DATABASE
	 FOR DROP_TABLE AS 
	 BEGIN
		  PRINT 'PERMISSION DENIED'
			     ROLLBACK
	 END
GO


---------------------------------------------------

  
  CREATE TRIGGER NO_ALTER_TABLE ON DATABASE                                    
   FOR ALTER_TABLE AS 
   BEGIN
       PRINT 'PERMISSION DENIED'
	   ROLLBACK
    END
GO     

---------------------------------------------------------------------------------------------------------------------


  CREATE PROC PROC_FOR_INSERT_INTO_EMPLOYEES_TABLE 
	@FirtstName VARCHAR(15), @LastName VARCHAR(15),
	@Title VARCHAR(20), @PhoneNumber VARCHAR(20),
	@Amount MONEY
	AS BEGIN
	        INSERT INTO Humanresources.employees VALUES
	       (@FirtstName, @LastName, @Title, @PhoneNumber, @Amount)
		    
			DECLARE @ID INT

		    SET @ID = (SELECT MAX(EmployeeID) FROM HumanResources.Employees)

		    PRINT 'EmployeeID:' + CAST(@ID AS VARCHAR(5)) + ' |' + ' FirstName: ' + 
		          @FirtstName + ' |' + ' Last Name: ' + @LastName + ' |' + 
		         ' Tile: '+ @Title + ' |' + ' Phone Number: ' + 
				 @PhoneNumber + ' |' +' Billing Rate: ' + CAST(@Amount AS VARCHAR(50))
       END


	GO


----------------------------------------------------------------------------------------------------------------------------



  CREATE PROC PROC_FOR_INSERT_INTO_CLIENTS_TABLE 
   @compName VARCHAR(20), @address VARCHAR(50),
   @City VARCHAR(20), @StateZip VARCHAR(7), @Country VARCHAR(20), @person VARCHAR(20), 
   @PhoneNumber VARCHAR(20)	
   AS BEGIN
	    INSERT INTO CustomerDetails.clients VALUES 
	    (@compName , @address, @City, @StateZip, @Country, @person, 
	        @PhoneNumber)
		    
		DECLARE @ID INT

		SET @ID = (SELECT MAX(ClientID) FROM CustomerDetails.clients)

		PRINT'ClientID: ' + CAST(@ID AS VARCHAR(100)) + ' |' + ' Company Name: ' + 
		        @compName + ' |' + ' Adderss: ' + @address + ' |' +  ' City: '+ @City +
				' |' + ' State Zip: '+ CAST(@StateZip AS VARCHAR(100)) + 
				' |' + ' Country: ' + @Country + ' |' +' Contact Person: '+ @person +
				' |' +' Phone Number: ' +  @PhoneNumber
    END




GO



----------------------------------------------------------------------------------------------------------------------



  CREATE PROC PROC_FOR_INSERT_INTO_PROJECTS_TABLE 
    @ClientID INT, @Name VARCHAR(50),
	@Billing MONEY, @Start DATE, @End DATE

	AS BEGIN
	        INSERT INTO ProjectDetails.Projects VALUES 
	        (@ClientID, @Name, @Billing, @Start, @End)
		    
			DECLARE @ID INT

		    SET @ID = (SELECT Max(ProjectID) FROM ProjectDetails.Projects)

		    PRINT 'ProjectID: ' + CAST(@ID AS VARCHAR(100)) + ' |' + 'ClientID: ' +
		        CAST(@ClientID AS VARCHAR(100)) + 
		        ' |' + ' Billing Eastimate: '+ Cast(@Billing AS VARCHAR(100)) + ' |' +
				' State Date: ' + + CAST(@Start AS VARCHAR(20)) 
				+ ' |' + ' End Date: ' + + CAST(@End AS VARCHAR(20)) 
     END


GO



-------------------------------------------------------------------------------------------------------------------------------------------


  CREATE PROC PROC_FOR_INSERT_INTO_TIMECARDS_TABLE 
	@Emp INT, @Proj INT, @WorkCodeDes VARCHAR(30), @DateIssued DATE, @DaysWorked INT,
	@Bill MONEY
	           
	AS BEGIN
	        IF EXISTS(SELECT WorkCodeDescription FROM ProjectDetails.WorkCodes
			   WHERE WorkCodeDescription = @WorkCodeDes) 
		       BEGIN
				   DECLARE @WorkCodeID INT
				    SET @WorkCodeID = (SELECT WorkCodeID FROM ProjectDetails.WorkCodes
			        WHERE WorkCodeDescription = @WorkCodeDes)
					INSERT INTO ProjectDetails.Timecards (EmployeeID, ProjectID, WorkCodeID, 
					DateIssued, DaysWorked, BillableHours) 
					VALUES (@Emp,  @Proj, @WorkCodeID, @DateIssued, @DaysWorked, @Bill)
		    
					DECLARE @ID INT, @Cost MONEY

					SET @ID = (SELECT MAX(TimeCardID)FROM ProjectDetails.Timecards)
					SET @Cost = (SELECT TotalCost FROM ProjectDetails.Timecards WHERE TimeCardID = @ID )

					PRINT 'TimeCardID: ' + CAST(@ID as varchar(100)) + ' |' + ' EmployeeID: ' +
					    CAST(@Emp as varchar(100)) + 
						' |' + ' ProjectID: '+ CAST(@Proj AS VARCHAR(100)) + ' |' +
						' WorkCodeID: ' +  CAST(@WorkCodeID AS VARCHAR(100)) 
						+ ' |' + ' Date Issued: ' +  CAST(@DateIssued AS VARCHAR(20)) 
						+ ' |' + ' Days Worked: ' +  CAST(@DaysWorked AS VARCHAR(20))
						+ ' |' + ' Billable Hours ' +  CAST(@Bill AS VARCHAR(20))
						+ ' |' + ' Total Cost ' +  CAST(@Cost AS VARCHAR(50))
                   END
		      ELSE
			       BEGIN
			            PRINT 'Invalid WorkCode'
			END
	END
 GO

-----------------------------------------------------------------------------------------------------------------------------------------



   CREATE PROC PROC_FOR_INSERT_INTO_TIMECARD_EXP_TABLE 

	@TimeCardID INT, @ExpDesc VARCHAR(50), @ExpDate DATE, @ProjID INT, @ExpAmount MONEY

	AS BEGIN         
	       IF EXISTS (SELECT ExpenseID FROM projectdetails.ExpenseDetails  
		    WHERE ExpenseDescription = @ExpDesc)

			   BEGIN
					DECLARE @ExpenseID INT
					SET @ExpenseID  = (SELECT ExpenseID FROM projectdetails.ExpenseDetails  
						WHERE ExpenseDescription = @ExpDesc)

					INSERT INTO ProjectDetails.TimeCardExpenses
					VALUES (@TimeCardID, @ExpenseID, @ExpDate, @ProjID, @ExpAmount)
		    
					DECLARE @ID INT

					SET @ID = (SELECT MAX(TimeCardExpensID) FROM ProjectDetails.TimeCardExpenses)
			
					PRINT 'TimeCardExpenseID: ' + cast(@ID AS VARCHAR(50)) + ' |' +
							'TimeCardID: ' + cast(@TimeCardID AS VARCHAR(50)) + ' |' + 
							' ExpenseID: ' + cast(@ExpenseID AS VARCHAR(50))  + ' |' + 
							' Expense Date: '  + Cast(@ExpDate AS VARCHAR(20)) +' |' + 
							' ProjectID: '+ Cast(@ProjID AS VARCHAR(50)) + ' |' +
							' Expense Amount: ' +  Cast(@ExpAmount AS VARCHAR(50)) 
			   END
		   ELSE 
			   BEGIN
			        PRINT UPPER(@ExpDesc) + ' expenses is  unaceptable.'
			END

     END

	GO



------------------------------------------------------------------------------------------------------------------------------------------




   Proc_For_Insert_into_Employees_Table 'Udoke', 'Excellence', 'Project Manager', '08038263822', 6000

   GO

   Proc_For_Insert_into_Employees_Table 'Dominion', 'luke', 'Team Leader', '08038263823',  5800

   GO

   Proc_For_Insert_into_Employees_Table 'Tolani', 'Sodiq', 'Team Member', '08038263824', 5500

   GO

   Proc_For_Insert_into_Employees_Table 'Bewaji', 'Tackle', 'Team Member', '08038263825', 3250

   GO

-----------------------------------------------------------------------------------------------------------------------


	Proc_For_Insert_into_Clients_Table  'Luiz', 'N close, House 4 1st Ave, Festac', 'lagos ','LAG', 'Nig', ' Bewaji', '08038263889'
	GO

	Proc_For_Insert_into_Clients_Table  'Topmost School', 'No 9, 3th fllor 4 Awolowo Way, Ikeja', 'lagos ','LAG', 'Nig', ' Dominion', '07038263884'
	GO

	Proc_For_Insert_into_Clients_Table  'SemiStone', 'No 9, 4th fllor 4 Awolowo Way, Ikeja', 'lagos ','LAG', 'Nig', ' Promise', '07038263894'
	GO

	Proc_For_Insert_into_Clients_Table  'JinGha', '72, mathin close Ikeja', 'Ibadan ','IBA', 'Nig', ' Udoka', '08038263825'


GO


---------------------------------------------------------------------------------------------------------------------------------------




	 Proc_For_Insert_into_Projects_Table  1,   'SoftWare Development', 1500000, '2023-04-5', '2023-11-01'

	 GO

	 Proc_For_Insert_into_Projects_Table  2,   'Data Analysis',  1250000, '2023-01-15', '2023-11-15'

	 GO

	 Proc_For_Insert_into_Projects_Table  3,   'Computer Networking',   2000000,  '2023-02-01', '2023-11-02'

	 GO

	 Proc_For_Insert_into_Projects_Table  4,   'SoftWare Development',  1500000, '2023-03-10', '2023-11-10'
 

	 GO
	 

	
----------------------------------------------------------------------------------------------------------------------------------------

	INSERT INTO ProjectDetails.WorkCodes values('Software Developer') 
	INSERT INTO ProjectDetails.WorkCodes values('Doctor')
	INSERT INTO ProjectDetails.WorkCodes values('Data Analyst')
	INSERT INTO ProjectDetails.WorkCodes values('ICT Engineer')

	GO


 --------------------------------------------------------------------------------------------------------
 

	 Proc_For_Insert_into_TimeCards_Table 1,  1,'Software Developer', '2023-04-6', 10, 80 

	 GO
    
	 Proc_For_Insert_into_TimeCards_Table 2,  4, 'Software Developer', '2023-03-11', 25, 74 
 
	 GO

	 Proc_For_Insert_into_TimeCards_Table 3,  2, 'Data Analyst', '2023-01-16', 28, 86

	 GO

	 Proc_For_Insert_into_TimeCards_Table 4,   3, 'ICT Engineer', '2023-02-02', 26, 69

	 
-----------------------------------------------------------------------------------------------------------------------
 
 

  Insert into projectdetails.ExpenseDetails values('Repairs')
  Insert into projectdetails.ExpenseDetails values('Transportation')
  Insert into projectdetails.ExpenseDetails values('System accessaries replacement')
  Insert into projectdetails.ExpenseDetails values('Fuelling')
  Insert into projectdetails.ExpenseDetails values('Medicals')
  
  GO


------------------------------------------------------------------------------------------------------------------------



 	 Proc_For_Insert_into_TimeCard_Exp_Table 1, 'Repairs', '2023-10-27', 1, 12500

	 GO

	  Proc_For_Insert_into_TimeCard_Exp_Table 2, 'Fuelling', '2023-11-07', 4, 6334

	 GO

	  Proc_For_Insert_into_TimeCard_Exp_Table 3, 'Medicals', '2023-10-15', 2, 8430

	 GO

	  Proc_For_Insert_into_TimeCard_Exp_Table 4, 'Transportation', '2023-10-28', 3, 17500

  GO


------------------------------------------------------------------------------------------------

 

	 Insert into Payment.PaymentMethod values('Credit Card')
	 Insert into Payment.PaymentMethod values('Cash')
	 Insert into Payment.PaymentMethod values('Cheque')
 
	 GO
 

----------------------------------------------------------------------------------------------------------------------------------------------------


---PROCEDURE  
   

     Exec Proc_For_Insert_Cheque_Payment_Into_Payment_Table 4, 90000, '2023-11-12',  '480401'

     Exec Proc_For_Insert_Into_Payment_Table_Credit_Card_Payment 1, 500000,  '2023-11-03', '4002-3782-9754-8065','Udoka', '2023-10-01'

     Exec Proc_For_Insert_Cheque_Payment_Into_Payment_Table 2, 90000, '2023-11-16', '801345'

     Exec Proc_For_Insert_Cash_Payment_Into_Payment_Table 3, 120000, '2023-11-04'


GO
	 Exec Proc_For_Insert_Cheque_Payment_Into_Payment_Table 2, 10000, '2023-11-18', '401671'

     Exec Proc_For_Insert_Into_Payment_Table_Credit_Card_Payment 3, 65000,  '2023-11-11', '4009-3748-9754-8066','Dominion', '2024-01-15'

	 Exec Proc_For_Insert_Cash_Payment_Into_Payment_Table 1, 150000, '2023-11-05'

	 Exec Proc_For_Insert_Into_Payment_Table_Credit_Card_Payment 4, 199000,  '2023-11-19', '4006-3748-9754-8067','Bewaji', '2023-06-11'
 
 GO
	 
	 Exec Proc_For_Insert_Cash_Payment_Into_Payment_Table 3, 9500, '2023-11-22'

	 Exec Proc_For_Insert_Into_Payment_Table_Credit_Card_Payment 1, 300000,  '2023-11-15', '4004-3748-9754-8068','Tolani', '2023-08-21'

	 Exec Proc_For_Insert_Cheque_Payment_Into_Payment_Table 2, 1100000, '2023-11-20', '102868'

	 Exec Proc_For_Insert_Cheque_Payment_Into_Payment_Table 4, 11000, '2023-11-28', '708567'

	 
GO
	
   SELECT * FROM INFORMATION_SCHEMA.TABLES
 /*
 select * from Payment.Payments

 INSERT INTO Payment.Payments (ProjectID,PaymentAmount,PaymentDate,CreditCardNumber,
 CreditCardExpiryDate,CardHoldersName,PaymentMethodID,ChequeNumber) 
 values (1, 500000,  '2023-11-03', '4002-3782-9754-8065','2023-10-01','Udoka', 1,null)

 SELECT * FROM ProjectDetails.TimeCardExpenses
 SELECT * FROM ProjectDetails.ExpenseDetails

 SELECT * FROM  Payment.Payments WHERE 
 */