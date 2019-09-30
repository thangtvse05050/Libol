USE [Libol]
GO
/****** Object:  StoredProcedure [dbo].[FPT_SP_CATA_GET_CONTENTS_OF_ITEMS_Newest]    Script Date: 9/30/2019 12:00:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--FPT_SP_CATA_GET_CONTENTS_OF_ITEMS'1090',0
--Doanhdq created
--use to display all property by  Record
--Fixed : 852 khong lay thong tin ma dang ky ca biet
CREATE       PROCEDURE [dbo].[FPT_SP_CATA_GET_CONTENTS_OF_ITEMS_Newest]
	@strItemIDs varchar(1000),
	@intIsAuthority INT
AS

IF @intIsAuthority = 0 
	BEGIN
		--Ldr
		SELECT '000' as IDSort,'Ldr' as FieldCode, '' as Ind, Leader as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		
		--Code
		UNION
		SELECT '001' as IDSort,'001' as FieldCode, '' as Ind, I.Code as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		
		--Field000s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content
		FROM Field000s F, MARC_BIB_FIELD M
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs)  
		
		--Field100s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content 
		FROM Field100s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs)  
		
		--Field200s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content
		FROM Field200s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field300s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content 
		FROM Field300s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field400s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content
		FROM Field400s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field500s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content 
		FROM Field500s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field600s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content
		FROM Field600s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field700s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content 
		FROM Field700s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field800s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content
		FROM Field800s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--Field900s
		UNION 
		SELECT M.FieldCode as IDSort, M.FieldCode,REPLACE(F.Ind1,' ','#')  + REPLACE(F.Ind2,' ','#')  as Ind, F.Content as Content
		FROM Field900s F, MARC_BIB_FIELD M 
		WHERE M.FieldCode=F.FieldCode AND F.ItemID IN (@strItemIDs) 
		
		--NewRecord
		UNION
		SELECT '900' as IDSort,'900' as FieldCode, '' as Ind, CAST(I.NewRecord as varchar(5)) as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		
		--CoverPicture
		UNION
		SELECT '907' as IDSort,'907' as FieldCode, '' as Ind, I.CoverPicture as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		AND CoverPicture IS NOT NULL AND CoverPicture <> ''
		
		--Reviewer
		UNION
		SELECT '912' as IDSort,'912' as FieldCode, '' as Ind, I.Reviewer as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		AND Reviewer  IS NOT NULL AND Reviewer <>''
		
		--Cataloguer
		UNION
		SELECT '911' as IDSort,'911' as FieldCode, '' as Ind,  I.Cataloguer as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		AND Cataloguer  IS NOT NULL AND Cataloguer  <>''
		
		--M.Code
		UNION
		SELECT '925' as IDSort,'925' as FieldCode, '' as Ind, M.Code as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		
		--AccessLevel
		UNION
		SELECT '926' as IDSort,'926' as FieldCode, '' as Ind, CAST(I.AccessLevel as varchar(1)) as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
		
		--D.TypeCode
		UNION
		SELECT '927' as IDSort,'927' as FieldCode, '' as Ind, D.TypeCode as Content
		FROM ITEM I , CAT_DIC_MEDIUM M, CAT_DIC_ITEM_TYPE D 
		WHERE 
		I.MediumID=M.ID 
		AND I.TypeID = D.ID
		AND I.ID IN (@strItemIDs)
			-- copynumber : 852$j
			--Doanhdq
	    UNION
	    SELECT distinct '852' as IDSort,'852' as FieldCode, '' as Ind,  '$a' + HLB.code + '$b' + hl.symbol+'$j'+ H.CopyNumber as Content
     FROM HOLDING H, HOLDING_LOCATION HL, HOLDING_LIBRARY HLB WHERE H.ItemID  =@strItemIDs AND H.locationid=HL.ID AND HL.LIBID=HLB.ID

		--ORDER
		
		ORDER BY IDSort
	END
ELSE
	BEGIN
		SELECT '0' as IDSort,'Ldr' as FieldCode, '0' as Ind, Leader as Content
		FROM CAT_AUTHORITY where
		ID IN (@strItemIDs)
		
		UNION
		-- 001 : code
		SELECT '001' as IDSort,'001' as FieldCode, '0' as Ind, Code as Content
		FROM CAT_AUTHORITY where
		ID IN (@strItemIDs)
		
		UNION	
		
		SELECT MA.FieldCode as IDSort,MA.FieldCode, REPLACE(FA.Ind1,' ','#')  + REPLACE(FA.Ind2,' ','#')  as Ind, REPLACE(FA.Content,' ','&nbsp;') as Content
		FROM Field_Authority FA, MARC_Authority_field MA
		WHERE MA.FieldCode = FA.FieldCode
		And AuthorityID IN (@strItemIDs)
		
		UNION	
		-- cataloguer
		SELECT '911' as IDSort,'911' as FieldCode, '0' as Ind, Cataloguer as Content
		FROM CAT_AUTHORITY CA 	
		where CA.ID IN (@strItemIDs)
		
		UNION	
		-- reviewer
		SELECT '912' as IDSort,'912' as FieldCode, '0' as Ind, Reviewer as Content
		FROM CAT_AUTHORITY CA 
		where	
		CA.ID IN (@strItemIDs)
		--ORDER
		
		ORDER BY IDSort;
	END
	


