using OPAC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PagedList;
using System.Text;

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
                                      Author = f.DisplayEntry,
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
        /// Get title of item by itemID
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public string GetItemTitle(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var itemTitle = (from r in dbContext.ITEM_TITLE
                                  where r.ItemID == itemID
                                  select r.Title).FirstOrDefault();

                return itemTitle;
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
                var list = dbContext.Database.SqlQuery<SP_CATA_GET_CONTENTS_OF_ITEMS_Result>("SP_CATA_GET_CONTENTS_OF_ITEMS {0}, {1}",
                    new object[] { itemID, isAuthority }).ToList();

                return list;
            }
        }

        /// <summary>
        /// Get related term of a book
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public List<SP_OPAC_RELATED_TERMS_Result> SP_OPAC_RELATED_TERMS_LIST(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var list = dbContext.Database.SqlQuery<SP_OPAC_RELATED_TERMS_Result>("SP_OPAC_RELATED_TERMS {0}",
                    new object[] { itemID }).ToList();

                return list;
            }
        }

        /// <summary>
        /// Get all copy number of book
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="serID"></param>
        /// <returns></returns>
        public List<FPT_SP_GET_CODE_AND_SYMBOL_BY_ITEMID_Result> GetInforCopyNumberList(int itemID)
        {
            using (var dbContext = new OpacEntities())
            {
                var list = dbContext.Database.SqlQuery<FPT_SP_GET_CODE_AND_SYMBOL_BY_ITEMID_Result>("FPT_SP_GET_CODE_AND_SYMBOL_BY_ITEMID {0}",
                    new object[] { itemID }).ToList();

                return list;
            }
        }

        /// <summary>
        /// Get detal book with status
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
        public static List<FPT_SP_GET_DETAIL_BOOK_WITH_STATUS_Result> GetDetailBookWithStatus(int itemID, string code)
        {
            using (var dbContext = new OpacEntities())
            {
                var list = dbContext.Database.SqlQuery<FPT_SP_GET_DETAIL_BOOK_WITH_STATUS_Result>("FPT_SP_GET_DETAIL_BOOK_WITH_STATUS {0}, {1}",
                    new object[] { itemID, code }).ToList();

                return list;
            }
        }

        public FullInforBook GetFullInforBook(int itemID)
        {
            StringBuilder getDocumentType = new StringBuilder("");
            StringBuilder getISBN = new StringBuilder("");
            StringBuilder getLanguageCode = new StringBuilder("");
            StringBuilder getPublishing = new StringBuilder("");
            StringBuilder getPhysicDescription = new StringBuilder("");
            StringBuilder getBrief = new StringBuilder("");
            string[] specialCharacterList = { "$a", "$b", "$c", "$p", "$e", "$n" };

            using (var dbContext = new OpacEntities())
            {
                var getISBNTemp = (from i in dbContext.FIELD000S
                                   where i.ItemID == itemID && i.FieldCode.Equals("020")
                                   select i.Content).Distinct().FirstOrDefault();
                getISBN.Append(getISBNTemp);
                foreach (var item in specialCharacterList)
                {
                    getISBN.Replace(item, "");
                }

                var getLanguageCodeTemp = (from i in dbContext.FIELD000S
                                           where i.ItemID == itemID && i.FieldCode.Equals("041")
                                           select i.Content).Distinct().FirstOrDefault();
                getLanguageCode.Append(getLanguageCodeTemp);
                foreach (var item in specialCharacterList)
                {
                    getLanguageCode.Replace(item, "");
                }

                var getPublishingTemp = (from i in dbContext.FIELD200S
                                         where (i.ItemID == itemID && i.FieldCode.Equals("250"))
                                         || (i.ItemID == itemID && i.FieldCode.Equals("260"))
                                         select i.Content).Distinct().ToList();
                string temp = "";
                foreach (var item in getPublishingTemp)
                {
                    temp += item + " ";
                }
                getPublishing.Append(temp.Trim());
                foreach (var item in specialCharacterList)
                {
                    getPublishing.Replace(item, "");
                }

                var getPhysicDescriptionTemp = (from i in dbContext.FIELD300S
                                                where i.ItemID == itemID
                                                select i.Content).Distinct().FirstOrDefault();
                getPhysicDescription.Append(getPhysicDescriptionTemp);
                foreach (var item in specialCharacterList)
                {
                    getPhysicDescription.Replace(item, "");
                }
            }

            FullInforBook fullBookInformation = new FullInforBook
            {
                ISBN = getISBN.ToString(),
                LanguageCode = getLanguageCode.ToString(),
                Publishing = getPublishing.ToString(),
                PhysicDescription = getPhysicDescription.ToString()
            };

            return fullBookInformation;
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