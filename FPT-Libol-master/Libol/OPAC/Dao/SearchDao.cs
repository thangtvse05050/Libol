﻿using OPAC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PagedList;
using System.Text;
using System.Text.RegularExpressions;

namespace OPAC.Dao
{
    public class SearchDao
    {
        /// <summary>
        /// Search book with key word
        /// </summary>
        /// <param name="searchKeyword"></param>
        /// <param name="option"></param>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public IEnumerable<FPT_SP_GET_SEARCHED_INFO_BOOK_Result> GetSearchingBook(string searchKeyword, string option, int page, int pageSize)
        {
            using (var dbContext = new OpacEntities())
            {
                searchKeyword = Regex.Replace(searchKeyword, @"\s+", " ").Trim();
                var list = dbContext.Database.SqlQuery<FPT_SP_GET_SEARCHED_INFO_BOOK_Result>("FPT_SP_GET_SEARCHED_INFO_BOOK {0}, {1}",
                     new object[] { searchKeyword, option }).ToList();

                return list.ToPagedList(page, pageSize);
            }
        }

        /// <summary>
        /// Search book by key word
        /// </summary>
        /// <param name="searchKeyword"></param>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public IEnumerable<FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD_Result> GetSearchingBookByKeyWord(string searchKeyword, int page, int pageSize)
        {
            using (var dbContext = new OpacEntities())
            {
                var getItemID = dbContext.FPT_SP_GET_ITEMID_BY_KEYWORD(searchKeyword).ToList();
                var listResult = new List<FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD_Result>();

                foreach (var item in getItemID)
                {
                    var list = dbContext.Database.SqlQuery<FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD_Result>("FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD {0}",
                        new object[] { item }).ToList();

                    listResult.AddRange(list);
                }

                return listResult.ToPagedList(page, pageSize);
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
                               select g.CopyNumber).Take(18).ToList();

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
        /// Count number of result book after searching
        /// </summary>
        /// <param name="searchKeyword"></param>
        /// <param name="option"></param>
        /// <returns></returns>
        public int GetNumberResult(string searchKeyword, string option)
        {
            using (var dbContext = new OpacEntities())
            {
                searchKeyword = Regex.Replace(searchKeyword, @"\s+", " ").Trim();
                var numberResult = dbContext.Database.SqlQuery<FPT_SP_GET_SEARCHED_INFO_BOOK_Result>("FPT_SP_GET_SEARCHED_INFO_BOOK {0}, {1}",
                    new object[] { searchKeyword, option }).ToList().Count();

                return numberResult;
            }
        }

        /// <summary>
        /// Count number of result book after searching by key word
        /// </summary>
        /// <param name="searchKeyword"></param>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public int GetNumberResultByKeyWord(string searchKeyword, int page, int pageSize)
        {
            var numberResult = new List<FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD_Result>();
            using (var dbContext = new OpacEntities())
            {
                var getItemID = dbContext.FPT_SP_GET_ITEMID_BY_KEYWORD(searchKeyword).ToList();
                foreach (var item in getItemID)
                {
                    var list = dbContext.Database.SqlQuery<FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD_Result>("FPT_SP_GET_SEARCHED_INFO_BOOK_BY_KEYWORD {0}",
                        new object[] { item }).ToList();

                    numberResult.AddRange(list);
                }

                return numberResult.ToPagedList(page, pageSize).TotalItemCount;
            }
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
        /// <param name="code"></param>
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

        /// <summary>
        /// Get full information of book after searching (Lấy thông tin sách hiển thị đầy đủ)
        /// </summary>
        /// <param name="itemID"></param>
        /// <returns></returns>
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
                var getISBNTemp = dbContext.FPT_SP_GET_ISBN_ITEM(itemID).ToList();
                foreach (var item in getISBNTemp)
                {
                    getISBN.Append(item + " ");
                }
                
                var getLanguageCodeTemp = dbContext.FPT_SP_GET_LANGUAGE_CODE_ITEM(itemID).ToList();
                foreach (var item in getLanguageCodeTemp)
                {
                    getLanguageCode.Append(item);
                }
                
                var getPublishingTemp = dbContext.FPT_SP_GET_PUBLISH_INFO_ITEM(itemID).ToList();
                foreach (var item in getPublishingTemp)
                {
                    getPublishing.Append(item + " ");
                }

                var getPhysicDescriptionTemp = dbContext.FPT_SP_GET_PHYSICAL_INFO_ITEM(itemID).ToList();
                foreach (var item in getPhysicDescriptionTemp)
                {
                    getPhysicDescription.Append(item + " ");
                }

                foreach (var item in specialCharacterList)
                {
                    getISBN.Replace(item, "");
                    getLanguageCode.Replace(item, "");
                    getPublishing.Replace(item, "");
                    getPhysicDescription.Replace(item, "");
                }
            }

            FullInforBook fullBookInformation = new FullInforBook
            {
                ISBN = getISBN.ToString().Trim(),
                LanguageCode = getLanguageCode.ToString().Trim(),
                Publishing = getPublishing.ToString().Trim(),
                PhysicDescription = getPhysicDescription.ToString().Trim()
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