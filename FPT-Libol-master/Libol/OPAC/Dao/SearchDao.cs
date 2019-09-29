using OPAC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PagedList;

namespace OPAC.Dao
{
    public class SearchDao
    {
        /// <summary>
        /// Search book with key word
        /// </summary>
        /// <param name="searchKeyword"></param>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public IEnumerable<SearchingResult> GetSearchingBook(string searchKeyword, int page, int pageSize)
        {
            using (var dbContext = new OpacEntities())
            {
                var listResult = (from r in dbContext.ITEMs
                                  join a in dbContext.ITEM_TITLE on r.ID equals a.ItemID
                                  join b in dbContext.ITEM_AUTHOR on r.ID equals b.ItemID
                                  join c in dbContext.ITEM_PUBLISHER on r.ID equals c.ItemID
                                  join d in dbContext.CAT_DIC_PUBLISHER on c.PublisherID equals d.ID
                                  join e in dbContext.CAT_DIC_YEAR on r.ID equals e.ItemID
                                  join f in dbContext.CAT_DIC_AUTHOR on b.AuthorID equals f.ID
                                  where a.Title.Contains(searchKeyword) ||
                                        d.DisplayEntry.Contains(searchKeyword) ||
                                        e.Year.Contains(searchKeyword) ||
                                        f.DisplayEntry.Contains(searchKeyword)
                                  select new SearchingResult
                                  {
                                      ItemID = r.ID,
                                      Title = a.Title,
                                      Publisher = d.DisplayEntry,
                                      Year = e.Year,
                                      Author = f.DisplayEntry
                                  }).Distinct().OrderBy(x => x.Title).ToPagedList(page, pageSize);
                return listResult;
            }
        }

        /// <summary>
        /// Get all copy number of book by itemID
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public static List<string> GetListCopyNumber(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var copyNum = (from g in dbContext.HOLDINGs
                               where g.ItemID == itemID
                               select g.CopyNumber).ToList();

                return copyNum;
            }
        }

        /// <summary>
        /// Get all copy number of not borrowing book by itemID
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public static List<string> GetListCopyNumberNotBorrowing(int itemID, string symbol)
        {
            using (var dbContext = new OpacEntities())
            {
                var copyNum = (from g in dbContext.HOLDINGs
                               join d in dbContext.HOLDING_LOCATION on g.LocationID equals d.ID
                               where g.ItemID == itemID && d.Symbol.Equals(symbol) && g.InUsed == false
                               select g.CopyNumber).ToList();

                return copyNum;
            }
        }

        /// <summary>
        /// Count number of book following by symbol
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="symbol"></param>
        /// <returns></returns>
        public static int CountTotalCopyNumberBySymbol(int itemID, string symbol)
        {
            using (var dbContext = new OpacEntities())
            {
                var counting = (from g in dbContext.HOLDINGs
                               join d in dbContext.HOLDING_LOCATION on g.LocationID equals d.ID
                               where g.ItemID == itemID && d.Symbol.Equals(symbol)
                               select g.CopyNumber).Count();

                return counting;
            }
        }

        /// <summary>
        /// Count number of book which is free to borrow, following by symbol
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="symbol"></param>
        /// <returns></returns>
        public static int CountTotalCopyNumberFreeBySymbol(int itemID, string symbol)
        {
            using (var dbContext = new OpacEntities())
            {
                var counting = (from g in dbContext.HOLDINGs
                               join d in dbContext.HOLDING_LOCATION on g.LocationID equals d.ID
                               where g.ItemID == itemID && d.Symbol.Equals(symbol) && g.InUsed == false
                               select g.CopyNumber).Count();

                return counting;
            }
        }

        /// <summary>
        /// Count number of book which is borrowing by a patron, following by symbol
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="symbol"></param>
        /// <returns></returns>
        public static int CountTotalCopyNumberNotFreeBySymbol(int itemID, string symbol)
        {
            using (var dbContext = new OpacEntities())
            {
                var counting = (from g in dbContext.HOLDINGs
                                join d in dbContext.HOLDING_LOCATION on g.LocationID equals d.ID
                                where g.ItemID == itemID && d.Symbol.Equals(symbol) && g.InUsed == true
                                select g.CopyNumber).Count();

                return counting;
            }
        }

        /// <summary>
        /// Count number of result book after searching by key word
        /// </summary>
        /// <param name="searchKeyword"></param>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public int GetNumberResult(string searchKeyword, int page, int pageSize)
        {
            int total = 0;
            using (var dbContext = new OpacEntities())
            {
                if (string.IsNullOrEmpty(searchKeyword))
                {
                    total = (from r in dbContext.ITEMs
                             join a in dbContext.ITEM_TITLE on r.ID equals a.ItemID
                             join b in dbContext.ITEM_AUTHOR on r.ID equals b.ItemID
                             join c in dbContext.ITEM_PUBLISHER on r.ID equals c.ItemID
                             join d in dbContext.CAT_DIC_PUBLISHER on c.PublisherID equals d.ID
                             join e in dbContext.CAT_DIC_YEAR on r.ID equals e.ItemID
                             join f in dbContext.CAT_DIC_AUTHOR on b.AuthorID equals f.ID
                             select new SearchingResult
                             {
                                 Title = a.Title,
                                 Publisher = d.DisplayEntry,
                                 Year = e.Year,
                                 Author = f.DisplayEntry
                             }).Distinct().OrderBy(x => x.Title).ToList().Count;
                }
                else
                {
                    total = (from r in dbContext.ITEMs
                             join a in dbContext.ITEM_TITLE on r.ID equals a.ItemID
                             join b in dbContext.ITEM_AUTHOR on r.ID equals b.ItemID
                             join c in dbContext.ITEM_PUBLISHER on r.ID equals c.ItemID
                             join d in dbContext.CAT_DIC_PUBLISHER on c.PublisherID equals d.ID
                             join e in dbContext.CAT_DIC_YEAR on r.ID equals e.ItemID
                             join f in dbContext.CAT_DIC_AUTHOR on b.AuthorID equals f.ID
                             where a.Title.Contains(searchKeyword) ||
                                   d.DisplayEntry.Contains(searchKeyword) ||
                                   e.Year.Contains(searchKeyword) ||
                                   f.DisplayEntry.Contains(searchKeyword)
                             select new SearchingResult
                             {
                                 Title = a.Title,
                                 Publisher = d.DisplayEntry,
                                 Year = e.Year,
                                 Author = f.DisplayEntry
                             }).Distinct().OrderBy(x => x.Title).ToList().Count;
                }
            }

            return total;
        }

        /// <summary>
        /// Get detail information of book and display by MARC
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="isAuthority"></param>
        /// <returns></returns>
        public List<SP_CATA_GET_CONTENTS_OF_ITEMS_Result> SP_CATA_GET_CONTENTS_OF_ITEMS_LIST(int itemID, int isAuthority)
        {
            using (var dbContext = new OpacEntities())
            {
                List<SP_CATA_GET_CONTENTS_OF_ITEMS_Result> list = dbContext.Database.SqlQuery<SP_CATA_GET_CONTENTS_OF_ITEMS_Result>("SP_CATA_GET_CONTENTS_OF_ITEMS {0}, {1}",
                    new object[] { itemID, isAuthority }).ToList();

                return list;
            }
        }

        /// <summary>
        /// Information of copy number
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="serID"></param>
        /// <returns></returns>
        public List<InfoCopyNumber> GetInforCopyNumberList(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var list = (from h in dbContext.HOLDINGs
                            join s in dbContext.HOLDING_LIBRARY on h.LibID equals s.ID
                            join c in dbContext.HOLDING_LOCATION on h.LocationID equals c.ID
                            where h.ItemID == itemID
                            select new InfoCopyNumber
                            {
                                ItemID = h.ItemID,
                                Code = s.Code,
                                Symbol = c.Symbol
                            }).Distinct().ToList();

                return list;
            }
        }

        /// <summary>
        /// Get total of book
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public int GetTotalBook(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var totalBook = (from total in dbContext.HOLDINGs
                                 where total.ItemID == itemID
                                 select total).Count();

                return totalBook;
            }
        }

        /// <summary>
        /// Get total of book which is not using yet
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public int GetFreeBook(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var freeBook = (from f in dbContext.HOLDINGs
                                 where f.ItemID == itemID && f.InUsed == false
                                 select f).Count();

                return freeBook;
            }
        }

        /// <summary>
        /// Get number of book preparing to borrow by patron
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public int GetOnHoldingBook(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var holdingBook = (from h in dbContext.HOLDINGs
                                where h.ItemID == itemID && h.OnHold == true
                                select h).Count();

                return holdingBook;
            }
        }
    }
}