-- purpose : Get code (Thư viện) and symbol (kho) for searching copy number
-- Last Update: 01/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_CODE_AND_SYMBOL_BY_ITEMID]
(
	@intItemID INT
)
AS
	SELECT DISTINCT H.ItemID, L.Code, C.Symbol FROM [dbo].[HOLDING] AS H
	INNER JOIN [dbo].[HOLDING_LIBRARY] AS L ON H.LibID = L.ID
	INNER JOIN [dbo].[HOLDING_LOCATION] AS C ON H.LocationID = C.ID
	WHERE H.ItemID = @intItemID
GO


-- purpose : Get detail information of book: code, symbol, copy number with the borrowing status
-- Last Update: 01/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_DETAIL_BOOK_WITH_STATUS]
(
	@intItemID INT,
	@strCode NVARCHAR(32)
) 
AS
	SELECT DISTINCT L.Code, C.Symbol, H.CopyNumber, H.InUsed FROM [dbo].[HOLDING] AS H
	INNER JOIN [dbo].[HOLDING_LIBRARY] AS L ON H.LibID = L.ID
	INNER JOIN [dbo].[HOLDING_LOCATION] AS C ON H.LocationID = C.ID
	WHERE (H.ItemID = @intItemID) AND (L.Code = @strCode)
GO

/****** Object:  StoredProcedure [dbo].[FPT_SP_OPAC_GET_SEARCHED_INFO_BOOK]    Script Date: 12/16/2019 6:58:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- purpose : Get information of book after user use search function
-- Last Update: 06/12/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_SEARCHED_INFO_BOOK]
(
	@strCode NVARCHAR(250),
	@strOption NVARCHAR(5)
)
AS
	IF @strOption = '0'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strCode+'%' 
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD100S WHERE FieldCode = '110' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD700S WHERE FieldCode = '700' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
			WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
			WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
			WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
			WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
			WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 Content FROM FIELD600S WHERE FIELD600S.ItemID = A.ID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '1'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 Title FROM ITEM_TITLE WHERE ItemID = A.ID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '2'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
			WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD100S WHERE FieldCode = '110' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD100S WHERE FieldCode = '100' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD700S WHERE FieldCode = '700' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			OR (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD700S WHERE FieldCode = '710' AND ItemID = A.ID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '3'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
			WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '4'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
			WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '5'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
			WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '6'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
			WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
	ELSE IF @strOption = '7'
		BEGIN
			SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author'
			FROM [dbo].ITEM AS A
			WHERE (SELECT TOP 1 Content FROM FIELD600S WHERE FIELD600S.ItemID = A.ID) LIKE '%'+@strCode+'%'
			ORDER BY Title
		END
GO

-- purpose : Get ISBN
-- Last Update: 03/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_ISBN_ITEM]
(
	@intItemID INT
)
AS
	SELECT DISTINCT [dbo].[FIELD000S].Content FROM [dbo].[ITEM]
	INNER JOIN [dbo].[FIELD000S] ON [dbo].[FIELD000S].ItemID = [dbo].[ITEM].ID
	WHERE [dbo].[ITEM].ID = @intItemID AND [dbo].[FIELD000S].FieldCode = '020'
GO

-- purpose : Get Language Code
-- Last Update: 03/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_LANGUAGE_CODE_ITEM]
(
	@intItemID INT
)
AS
	SELECT DISTINCT Content FROM [dbo].[FIELD000S]
	WHERE [dbo].[FIELD000S].ItemID = @intItemID AND [dbo].[FIELD000S].FieldCode = '041'
GO

-- purpose : Get publishing information of book
-- Last Update: 03/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_PUBLISH_INFO_ITEM]
(
	@intItemID INT
)
AS
	SELECT DISTINCT Content FROM [dbo].[FIELD200S]
	WHERE ([dbo].[FIELD200S].ItemID = @intItemID AND [dbo].[FIELD200S].FieldCode = '250')
	   OR ([dbo].[FIELD200S].ItemID = @intItemID AND [dbo].[FIELD200S].FieldCode = '260')
GO

-- purpose : Get physical information of book
-- Last Update: 03/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_PHYSICAL_INFO_ITEM]
(
	@intItemID INT
)
AS
	SELECT DISTINCT Content FROM [dbo].[FIELD300S]
	WHERE [dbo].[FIELD300S].ItemID = @intItemID AND [dbo].[FIELD300S].FieldCode = '300'
GO

-- purpose : Get itemID by keyword
-- Last Update: 03/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_GET_ITEMID_BY_KEYWORD]
( 
	@strKeyWord NVARCHAR(100)
)
AS
	SELECT A.ItemID FROM ITEM_KEYWORD A ,CAT_DIC_KEYWORD B
	WHERE A.KeyWordID = B.ID and B.DisplayEntry = @strKeyWord
GO

-- purpose : Get itemID by DDC
-- Last Update: 17/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_ITEMID_BY_DDC]
( 
	@strDDC NVARCHAR(100)
)
AS
	SELECT ItemID FROM [dbo].[FIELD000S]
	WHERE [dbo].[FIELD000S].Content LIKE @strDDC AND [dbo].[FIELD000S].FieldCode = '090'
GO

-- purpose : Get information of book by keyword
-- Last Update: 22/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_SEARCHED_INFO_BOOK_BY_KEYWORD]
(
	@intItemID INT
)
AS
	SELECT DISTINCT A.ID, (SELECT DISTINCT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, (SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version], E.DisplayEntry AS 'Publisher', F.[Year], G.DisplayEntry AS 'Author' FROM [dbo].ITEM AS A
	INNER JOIN [dbo].[ITEM_AUTHOR] AS C ON A.ID = C.ItemID
	INNER JOIN [dbo].[ITEM_PUBLISHER] AS D ON A.ID = D.ItemID
	INNER JOIN [dbo].[CAT_DIC_PUBLISHER] AS E ON D.PublisherID = E.ID
	INNER JOIN [dbo].[CAT_DIC_YEAR] AS F ON A.ID = F.ItemID
	INNER JOIN [dbo].[CAT_DIC_AUTHOR] AS G ON C.AuthorID = G.ID
	WHERE A.ID = @intItemID
	ORDER BY Title
GO

-- purpose : Get location
-- Last Update: 08/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_LOCATION]
AS
	SELECT * FROM [dbo].[HOLDING_LOCATION]
GO
/****** Object:  StoredProcedure [dbo].[SP_HOLDING_LIBLOCUSER_SEL2]    Script Date: 10/10/2019 3:31:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******/
ALTER PROCEDURE [dbo].[SP_HOLDING_LIBLOCUSER_SEL2](@intUserID int,@intLibID int)
AS
BEGIN
iF(@intLibID=81)
BEGIN
	SELECT * FROM (SELECT CODE + ':' + SYMBOL AS LOCNAME, B.ID AS ID, REPLACE(CAST(A.ID AS CHAR(3)) + ':' + CAST(B.ID AS CHAR(3)), ' ', '') AS GroupID, 
	A.ID AS LibID, B.Symbol, A.Code
	FROM HOLDING_LIBRARY A, HOLDING_LOCATION B, SYS_USER_LOCATION C 
	WHERE A.LocalLib = 1 AND A.ID = B.LibID AND B.ID = C.LocID AND C.UserID = @intUserID AND B.LibID = @intLibID
	UNION SELECT CODE + ':' + SYMBOL AS LOCNAME, B.ID AS ID, REPLACE(CAST(A.ID AS CHAR(3)) + ':' + CAST(B.ID AS CHAR(3)), ' ', '') AS GroupID, 
	A.ID AS LibID, B.Symbol, A.Code
	FROM HOLDING_LIBRARY A, HOLDING_LOCATION B, SYS_USER_LOCATION C 
	WHERE A.LocalLib = 1 AND A.ID = B.LibID AND B.ID = C.LocID AND B.ID IN (13,15,16,27)) H
	ORDER BY H.LibID, H.Symbol
END
ELSE IF(@intLibID=20)
BEGIN
SELECT * FROM (SELECT CODE + ':' + SYMBOL AS LOCNAME, B.ID AS ID, REPLACE(CAST(A.ID AS CHAR(3)) + ':' + CAST(B.ID AS CHAR(3)), ' ', '') AS GroupID, 
	A.ID AS LibID, B.Symbol, A.Code
	FROM HOLDING_LIBRARY A, HOLDING_LOCATION B, SYS_USER_LOCATION C 
	WHERE A.LocalLib = 1 AND A.ID = B.LibID AND B.ID = C.LocID AND C.UserID = @intUserID AND B.LibID = @intLibID
	EXCEPT SELECT CODE + ':' + SYMBOL AS LOCNAME, B.ID AS ID, REPLACE(CAST(A.ID AS CHAR(3)) + ':' + CAST(B.ID AS CHAR(3)), ' ', '') AS GroupID, 
	A.ID AS LibID, B.Symbol, A.Code
	FROM HOLDING_LIBRARY A, HOLDING_LOCATION B, SYS_USER_LOCATION C 
	WHERE A.LocalLib = 1 AND A.ID = B.LibID AND B.ID = C.LocID AND B.ID IN (13,15,16,27) ) H
	ORDER BY H.LibID, H.Symbol
	END
	ELSE 
	BEGIN
	SELECT CODE + ':' + SYMBOL AS LOCNAME, B.ID AS ID, REPLACE(CAST(A.ID AS CHAR(3)) + ':' + CAST(B.ID AS CHAR(3)), ' ', '') AS GroupID, 
	A.ID AS LibID, B.Symbol, A.Code
	FROM HOLDING_LIBRARY A, HOLDING_LOCATION B, SYS_USER_LOCATION C 
	WHERE A.LocalLib = 1 AND A.ID = B.LibID AND B.ID = C.LocID AND C.UserID = @intUserID AND B.LibID = @intLibID
	ORDER BY B.LibID, B.Symbol
	END
	END
GO

-- purpose : Get detail term
-- Last Update: 16/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_RELATED_TERMS]
@intItemID INT
AS
    SELECT DISTINCT 'KeyWord' AS TermType, A.KeyWordID AS ID,B.DisplayEntry, '' AS AccessEntry FROM ITEM_KEYWORD A, CAT_DIC_KEYWORD B WHERE A.KeyWordID = B.ID AND A.ItemID = @intItemID
	UNION ALL
	SELECT DISTINCT 'DDC' AS TermType, A.DDCID AS ID, B.Content AS DisplayEntry, '' AS AccessEntry FROM ITEM_DDC A, FIELD000S B WHERE A.ItemID = B.ItemID AND B.FieldCode = '090' AND A.ItemID = @intItemID
	UNION ALL
	SELECT DISTINCT 'UDC' AS TermType, A.UDCID AS ID, B.DisplayEntry, '' AS AccessEntry FROM ITEM_UDC A, CAT_DIC_CLASS_UDC B WHERE A.UDCID = B.ID AND A.ItemID = @intItemID
	UNION ALL
	SELECT DISTINCT 'Author' AS TermType, A.AuthorID AS ID, B.DisplayEntry, B.AccessEntry  FROM ITEM_AUTHOR A, CAT_DIC_AUTHOR B WHERE  A.AuthorID = B.ID AND  A.ItemID = @intItemID
	UNION ALL
	SELECT DISTINCT 'BBK' AS TermType, A.BBKID AS ID, DisplayEntry, AccessEntry FROM ITEM_BBK A, CAT_DIC_CLASS_BBK B WHERE A.BBKID = B.ID AND A.ItemID =@intItemID
	UNION ALL
	SELECT DISTINCT 'NSC' AS TermType, A.NSCID AS ID, DisplayEntry, '' AS AccessEntry FROM ITEM_NSC A, CAT_DIC_CLASS_NSC B WHERE A.NSCID = B.ID AND A.ItemID = @intItemID
	UNION ALL
	SELECT DISTINCT 'SubjectHeading' AS TermType, A.SHID AS ID, DisplayEntry, '' AS AccessEntry FROM ITEM_SH A, CAT_DIC_SH B WHERE A.SHID = B.ID AND A.ItemID = @intItemID;
GO

-- purpose : Get history of borrowed books
-- Last Update: 22/10/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_LOAN_HISTORY]
@intPatronID INT
AS
	SELECT ID, (SELECT DISTINCT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ItemID) AS Title, 
		   CopyNumber, CheckOutdate, CheckInDate, PatronID, ItemID, LocationID, LoanTypeID, OverdueDays, RenewCount FROM [dbo].[CIR_LOAN_HISTORY] AS A
	WHERE PatronID = @intPatronID
GO

-- purpose : Get all book from specific LibraryID and LocationID
-- Last Update: 09/11/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_BOOK_BY_LIBID_AND_LOCATIONID]
(
	@strLibraryID NVARCHAR(5),
	@strLocationID NVARCHAR(5),
	@strDocumentTypeID NVARCHAR(5)
)
AS
	DECLARE @strSQL VARCHAR(4000)
	IF @strLibraryID = '0'
		IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS [Title], 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS [Publisher], 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS [Author],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) AS [KeyWord],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) AS [Language],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) AS [DDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) AS [BBK],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) AS [LOC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) AS [NLM],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) AS [UDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) AS [SH],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) AS [Country],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) AS [Series],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) AS [Thesis Subject],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) AS [OAI SET],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) AS [Dictionary40],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) AS [Dictionary41],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) AS [Dictionary42],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) AS [Dictionary43] FROM [dbo].ITEM AS A
			END
		ELSE
			BEGIN
				SET @strSQL = 'SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' ''), ''$p'', '' ''), ''$s'', '' '') FROM FIELD200S WHERE FieldCode = 245 AND ItemID = A.ID) AS [Title], 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' '') FROM FIELD200S WHERE FieldCode = 250 AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS [Publisher], 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS [Author],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) AS [KeyWord],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) AS [Language],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) AS [DDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) AS [BBK],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) AS [LOC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) AS [NLM],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) AS [UDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) AS [SH],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) AS [Country],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) AS [Series],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) AS [Thesis Subject],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) AS [OAI SET],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) AS [Dictionary40],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) AS [Dictionary41],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) AS [Dictionary42],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) AS [Dictionary43] FROM [dbo].ITEM AS A
					WHERE A.TypeID = ' + @strDocumentTypeID
				
				EXECUTE(@strSQL)
			END
	ELSE
		IF @strLocationID = '0'
			IF @strDocumentTypeID = '0'
				BEGIN
				SET @strSQL = 'SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' ''), ''$p'', '' ''), ''$s'', '' '') FROM FIELD200S WHERE FieldCode = 245 AND ItemID = A.ID) AS [Title], 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' '') FROM FIELD200S WHERE FieldCode = 250 AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS [Publisher], 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS [Author],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) AS [KeyWord],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) AS [Language],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) AS [DDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) AS [BBK],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) AS [LOC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) AS [NLM],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) AS [UDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) AS [SH],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) AS [Country],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) AS [Series],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) AS [Thesis Subject],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) AS [OAI SET],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) AS [Dictionary40],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) AS [Dictionary41],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) AS [Dictionary42],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) AS [Dictionary43] FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					INNER JOIN HOLDING_LIBRARY ON HOLDING_LIBRARY.ID = HOLDING.LibID
					WHERE HOLDING_LIBRARY.ID = ' + @strLibraryID
					
					EXECUTE(@strSQL)
				END
			ELSE
				BEGIN
					SET @strSQL = 'SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' ''), ''$p'', '' ''), ''$s'', '' '') FROM FIELD200S WHERE FieldCode = 245 AND ItemID = A.ID) AS [Title], 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' '') FROM FIELD200S WHERE FieldCode = 250 AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS [Publisher], 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS [Author],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) AS [KeyWord],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) AS [Language],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) AS [DDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) AS [BBK],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) AS [LOC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) AS [NLM],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) AS [UDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) AS [SH],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) AS [Country],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) AS [Series],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) AS [Thesis Subject],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) AS [OAI SET],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) AS [Dictionary40],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) AS [Dictionary41],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) AS [Dictionary42],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) AS [Dictionary43] FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					INNER JOIN HOLDING_LIBRARY ON HOLDING_LIBRARY.ID = HOLDING.LibID
					WHERE HOLDING_LIBRARY.ID = ' + @strLibraryID + ' AND A.TypeID = ' + @strDocumentTypeID
					
					EXECUTE(@strSQL)
				END
		ELSE
			IF @strDocumentTypeID = '0'
				BEGIN
				SET @strSQL = 'SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' ''), ''$p'', '' ''), ''$s'', '' '') FROM FIELD200S WHERE FieldCode = 245 AND ItemID = A.ID) AS [Title], 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' '') FROM FIELD200S WHERE FieldCode = 250 AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS [Publisher], 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS [Author],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) AS [KeyWord],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) AS [Language],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) AS [DDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) AS [BBK],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) AS [LOC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) AS [NLM],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) AS [UDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) AS [SH],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) AS [Country],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) AS [Series],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) AS [Thesis Subject],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) AS [OAI SET],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) AS [Dictionary40],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) AS [Dictionary41],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) AS [Dictionary42],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) AS [Dictionary43] FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					INNER JOIN HOLDING_LIBRARY ON HOLDING_LIBRARY.ID = HOLDING.LibID
					INNER JOIN HOLDING_LOCATION ON HOLDING_LOCATION.ID = HOLDING.LocationID
					WHERE HOLDING_LIBRARY.ID = ' + @strLibraryID +
					' AND HOLDING_LOCATION.ID = ' + @strLocationID

					EXECUTE(@strSQL)
				END
			ELSE
				BEGIN
				SET @strSQL = 'SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' ''), ''$p'', '' ''), ''$s'', '' '') FROM FIELD200S WHERE FieldCode = 245 AND ItemID = A.ID) AS [Title], 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,''$a'',''''),''$b'','' ''),''$c'','' ''),''$n'','' '') FROM FIELD200S WHERE FieldCode = 250 AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS [Publisher], 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS [Author],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) AS [KeyWord],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) AS [Language],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) AS [DDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) AS [BBK],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) AS [LOC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) AS [NLM],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) AS [UDC],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) AS [SH],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) AS [Country],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) AS [Series],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) AS [Thesis Subject],
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) AS [OAI SET],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) AS [Dictionary40],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) AS [Dictionary41],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) AS [Dictionary42],
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) AS [Dictionary43] FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					INNER JOIN HOLDING_LIBRARY ON HOLDING_LIBRARY.ID = HOLDING.LibID
					INNER JOIN HOLDING_LOCATION ON HOLDING_LOCATION.ID = HOLDING.LocationID
					WHERE HOLDING_LIBRARY.ID' + @strLibraryID + ' AND HOLDING_LOCATION.ID = ' + @strLocationID
					+ ' AND A.TypeID = ' + @strDocumentTypeID
					
					EXECUTE(@strSQL)
				END
GO
-- purpose : Get information of books after searching by advanced search
-- Last Update: 02/11/2019
-- Creator: Thangnt
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_ADVANCED_SEARCHED_INFO_BOOK]
(
	@strLibraryID NVARCHAR(5),
	@strLocationID NVARCHAR(5),
	@strSearchType NVARCHAR(20),
	@strDocumentTypeID NVARCHAR(5),
	@strKeyWord NVARCHAR(250)
)
AS
	IF @strLibraryID = '0'
		IF @strSearchType = 'AllFields'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE ((@strKeyWord IS NULL OR 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
				WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
				WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
				WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
				WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
				WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
				WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
				WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
				WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
				WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
				WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
				WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
				WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
				WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
				WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
				WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
				WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%'))
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND ((@strKeyWord IS NULL OR 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
				WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
				WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
				WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
				WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
				WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
				WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
				WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
				WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
				WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
				WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
				WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
				WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
				WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
				WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
				WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
				OR (@strKeyWord IS NULL OR
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
				WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%'))
			END
		ELSE IF @strSearchType = 'Title'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '1'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '2'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '3'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
				WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
				WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '4'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
				WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
				WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '5'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
				WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
				WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '6'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
				WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
				WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '7'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
				WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
				WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '9'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
				WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
				WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '10'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
				WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
				WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '11'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
				WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
				WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '12'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
				WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
				WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '19'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
				WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
				WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '30'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
				WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
				WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '31'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
				WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
				WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '40'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
				WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
				WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '41'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
				WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
				WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE IF @strSearchType = '42'
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
				WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
				WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
			END
		ELSE
			IF @strDocumentTypeID = '0'
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
				WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%')
			END
			ELSE
			BEGIN
				SELECT DISTINCT A.ID, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
				(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
				WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
				AND D.ItemID = A.ID) AS 'Publisher', 
				(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
				(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
				WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
				AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
				WHERE (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
				AND (@strKeyWord IS NULL OR 
				(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
				WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%')
			END
	ELSE
		IF @strLocationID = '0'
			IF @strSearchType = 'AllFields'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND ((@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%'))
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND ((@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%'))
				END
			ELSE IF @strSearchType = 'Title'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '1'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '2'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '3'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '4'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '5'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '6'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '7'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '9'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '10'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT) 
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '11'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '12'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '19'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '30'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '31'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '40'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '41'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '42'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
						AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%')
				END
		ELSE
			IF @strSearchType = 'AllFields'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND ((@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%'))
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND ((@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
					OR (@strKeyWord IS NULL OR
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%'))
				END
			ELSE IF @strSearchType = 'Title'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '1'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID AND C.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '2'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID AND D.ItemID = A.ID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '3'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_KEYWORD, [dbo].ITEM_KEYWORD AS H 
					WHERE H.KeyWordID = [dbo].CAT_DIC_KEYWORD.ID AND A.ID = H.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '4'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_BBK, [dbo].ITEM_BBK AS M
					WHERE M.BBKID = [dbo].CAT_DIC_CLASS_BBK.ID AND A.ID = M.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '5'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_DDC, [dbo].ITEM_DDC AS L
					WHERE L.DDCID = [dbo].CAT_DIC_CLASS_DDC.ID AND A.ID = L.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '6'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_LOC, [dbo].ITEM_LOC AS N
					WHERE N.LOCID = [dbo].CAT_DIC_CLASS_LOC.ID AND A.ID = N.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '7'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_UDC, [dbo].ITEM_UDC AS P
					WHERE P.UDCID = [dbo].CAT_DIC_CLASS_UDC.ID AND A.ID = P.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '9'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SH, [dbo].ITEM_SH AS Q
					WHERE Q.SHID = [dbo].CAT_DIC_SH.ID AND A.ID = Q.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '10'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT) 
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_LANGUAGE, [dbo].ITEM_LANGUAGE AS J 
					WHERE J.LanguageID = [dbo].CAT_DIC_LANGUAGE.ID AND A.ID = J.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '11'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
						AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_COUNTRY, [dbo].ITEM_COUNTRY AS R
					WHERE R.CountryID = [dbo].CAT_DIC_COUNTRY.ID AND A.ID = R.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '12'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_SERIES, [dbo].ITEM_SERIES AS S
					WHERE S.SeriesID = [dbo].CAT_DIC_SERIES.ID AND A.ID = S.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '19'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_THESIS_SUBJECT, [dbo].ITEM_THESIS_SUBJECT AS T
					WHERE T.SubjectID = [dbo].CAT_DIC_THESIS_SUBJECT.ID AND A.ID = T.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '30'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND	(@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_CLASS_NLM, [dbo].ITEM_NLM AS O
					WHERE O.NLMID = [dbo].CAT_DIC_CLASS_NLM.ID AND A.ID = O.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '31'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 DisplayEntry FROM [dbo].CAT_DIC_OAI_SET, [dbo].ITEM_OAI_SET AS U
					WHERE U.OaiID = [dbo].CAT_DIC_OAI_SET.ID AND A.ID = U.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '40'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY40, [dbo].ITEM_DICTIONARY40 AS V
					WHERE V.DICTIONARY40ID = [dbo].DICTIONARY40.ID AND A.ID = V.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '41'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY41, [dbo].ITEM_DICTIONARY41 AS W
					WHERE W.DICTIONARY41ID = [dbo].DICTIONARY41.ID AND A.ID = W.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE IF @strSearchType = '42'
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY42, [dbo].ITEM_DICTIONARY42 AS X
					WHERE X.DICTIONARY42ID = [dbo].DICTIONARY42.ID AND A.ID = X.ItemID) LIKE '%'+@strKeyWord+'%')
				END
			ELSE
				IF @strDocumentTypeID = '0'
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%')
				END
				ELSE
				BEGIN
					SELECT DISTINCT A.ID, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' '), '$p', ' '), '$s', ' ') FROM FIELD200S WHERE FieldCode = '245' AND ItemID = A.ID) AS Title, 
					(SELECT REPLACE(REPLACE(REPLACE(REPLACE(Content,'$a',''),'$b',' '),'$c',' '),'$n',' ') FROM FIELD200S WHERE FieldCode = '250' AND ItemID = A.ID) AS [Version],
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_PUBLISHER], [dbo].[ITEM_PUBLISHER] AS D
					WHERE [dbo].[CAT_DIC_PUBLISHER].ID = D.PublisherID
					AND D.ItemID = A.ID) AS 'Publisher', 
					(SELECT TOP 1 [Year] FROM [dbo].[CAT_DIC_YEAR] WHERE [dbo].[CAT_DIC_YEAR].ItemID = A.ID) AS [Year], 
					(SELECT TOP 1 DisplayEntry FROM [dbo].[CAT_DIC_AUTHOR], [dbo].[ITEM_AUTHOR] AS C
					WHERE [dbo].[CAT_DIC_AUTHOR].ID = C.AuthorID
					AND C.ItemID = A.ID) AS 'Author' FROM [dbo].ITEM AS A
					INNER JOIN HOLDING ON HOLDING.ItemID = A.ID
					WHERE HOLDING.LibID = CAST(@strLibraryID AS INT)
					AND HOLDING.LocationID = CAST(@strLocationID AS INT)
					AND (SELECT TypeID FROM [dbo].ITEM WHERE [dbo].ITEM.ID = A.ID) = CAST(@strDocumentTypeID AS INT)
					AND (@strKeyWord IS NULL OR 
					(SELECT TOP 1 Dictionary FROM [dbo].DICTIONARY43, [dbo].ITEM_DICTIONARY43 AS Y
					WHERE Y.DICTIONARY43ID = [dbo].DICTIONARY43.ID AND A.ID = Y.ItemID) LIKE '%'+@strKeyWord+'%')
				END
GO
--Purpose : Get top newest ItemID
--Creator : thangnt
--Last Update: 13/11/2019
ALTER PROCEDURE [dbo].[SP_OPAC_GET_NEW_ITEMS]
	@bitSECUREDOPAC	BIT,
	@intAccessLevel INT,
	@intTOP	INT,
	@intLibID INT
AS
	IF @intTOP=0 
		SET @intTOP=5
	IF @bitSECUREDOPAC=1
		BEGIN
			SET ROWCOUNT @intTOP
			SELECT Content, ItemID FROM (SELECT DISTINCT F.Content,F.ItemID FROM ITEM I,FIELD200S F,HOLDING_COPY H, HOLDING B
			WHERE F.ItemID=I.ID  AND H.ItemID=I.ID AND B.ItemID = I.ID
				AND H.TotalCopies > 0  
				AND F.FieldCode=245  AND I.Opac=1 
				AND I.NewRecord=1
				AND AccessLevel < = @intAccessLevel
				AND B.LibID = @intLibID
			) AS A, ITEM IT
			WHERE IT.ID = A.ItemID
			ORDER BY IT.CreatedDate DESC
			SET ROWCOUNT 0
		END
	ELSE
		BEGIN
			SET ROWCOUNT @intTOP
			SELECT Content, ItemID FROM (SELECT F.Content,F.ItemID FROM ITEM I,FIELD200S F,HOLDING_COPY H, HOLDING B
			WHERE F.ItemID=I.ID  AND H.ItemID=I.ID AND B.ItemID = I.ID
				AND H.TotalCopies > 0  
				AND F.FieldCode=245  AND I.Opac=1 
				AND I.NewRecord=1
				AND B.LibID = @intLibID
			) AS A, ITEM IT
			WHERE IT.ID = A.ItemID
			ORDER BY IT.CreatedDate DESC
			SET ROWCOUNT 0
		END
GO
--Purpose : Get top use book
--Creator : thangnt
--Last Update: 17/11/2019
ALTER PROCEDURE [dbo].[FPT_SP_OPAC_GET_MOST_USE_ITEMS]
AS
	SET ROWCOUNT 5
	SELECT DISTINCT H.ItemID, F.Content, SUM(UseCount) AS TotalUse FROM HOLDING H, FIELD200S F
	WHERE F.ItemID = H.ItemID AND F.FieldCode = '245'
	AND SUBSTRING(H.CopyNumber, 1, 2) = 'TK'
	GROUP BY H.ItemID, F.Content
	ORDER BY TotalUse DESC
	SET ROWCOUNT 0
GO

--ALTER TABLE [dbo].[SYS_COUNTER] (
--	ID int primary key identity(1, 1) NOT NULL,
--	IPAddress nvarchar(20) NOT NULL,
--	AccessedDate datetime NOT NULL,
--	AccessedTime int
--);

UPDATE CIR_LOAN_TYPE
SET Renewals = 1
WHERE ID = 13 OR ID = 21 OR ID = 22

UPDATE CIR_LOAN_TYPE
SET RenewalPeriod = 7
WHERE ID = 21 OR ID = 22

TRUNCATE TABLE TYPE_NOTICE
INSERT INTO TYPE_NOTICE (TypeNotice) VALUES (N'Tin tức')
INSERT INTO TYPE_NOTICE (TypeNotice) VALUES (N'Thông báo')
INSERT INTO TYPE_NOTICE (TypeNotice) VALUES (N'Nội quy')
INSERT INTO TYPE_NOTICE (TypeNotice) VALUES (N'Giới thiệu')
INSERT INTO TYPE_NOTICE (TypeNotice) VALUES (N'Sản phẩm')
INSERT INTO TYPE_NOTICE (TypeNotice) VALUES (N'Dịch vụ')

--/****** Object:  Job [Update_CIR_HOLDING]    Script Date: 12/03/2019 11:45:08 AM ******/
--BEGIN TRANSACTION
--DECLARE @ReturnCode INT
--SELECT @ReturnCode = 0
--/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/03/2019 11:45:08 AM ******/
--IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
--BEGIN
--EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

--END

--DECLARE @jobId BINARY(16)
--EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Update_CIR_HOLDING', 
--		@enabled=1, 
--		@notify_level_eventlog=0, 
--		@notify_level_email=0, 
--		@notify_level_netsend=0, 
--		@notify_level_page=0, 
--		@delete_level=0, 
--		@description=N'No description available.', 
--		@category_name=N'[Uncategorized (Local)]', 
--		@owner_login_name=N'DESKTOP-J01SHC3\NGUYENTHANG', @job_id = @jobId OUTPUT
--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
--/****** Object:  Step [UPDATE]    Script Date: 12/03/2019 11:45:08 AM ******/
--EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'UPDATE', 
--		@step_id=1, 
--		@cmdexec_success_code=0, 
--		@on_success_action=1, 
--		@on_success_step_id=0, 
--		@on_fail_action=2, 
--		@on_fail_step_id=0, 
--		@retry_attempts=0, 
--		@retry_interval=0, 
--		@os_run_priority=0, @subsystem=N'TSQL', 
--		@command=N'UPDATE CIR_HOLDING SET InTurn=0, CheckMail=1 WHERE TimeOutDate=GETDATE();', 
--		@database_name=N'Libol', 
--		@flags=0
--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
--EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
--EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'UPDATE DAILY', 
--		@enabled=1, 
--		@freq_type=4, 
--		@freq_interval=1, 
--		@freq_subday_type=1, 
--		@freq_subday_interval=0, 
--		@freq_relative_interval=0, 
--		@freq_recurrence_factor=0, 
--		@active_start_date=20191203, 
--		@active_end_date=99991231, 
--		@active_start_time=0, 
--		@active_end_time=235959, 
--		@schedule_uid=N'300662c1-3627-4469-9a1b-1bb7c0a1b85a'
--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
--EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
--COMMIT TRANSACTION
--GOTO EndSave
--QuitWithRollback:
--    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
--EndSave:
GO

--Update db daily
ALTER PROCEDURE [dbo].[FPT_OPAC_UPDATE_REGISTER_TO_BORRROW_DAILY]
AS
BEGIN
    UPDATE CIR_HOLDING SET InTurn=0, CheckMail=1 WHERE TimeOutDate <= GETDATE();
END
GO