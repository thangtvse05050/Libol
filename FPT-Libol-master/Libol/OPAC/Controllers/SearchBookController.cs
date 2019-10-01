using OPAC.Dao;
using OPAC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OPAC.Controllers
{
    public class SearchBookController : Controller
    {
        private SearchDao dao = new SearchDao();

        // GET: DetailBook
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        public ActionResult DetailBook(int itemID, string code)
        {
            ViewBag.OnHoldingBook = dao.GetOnHoldingBook(itemID);
            ViewBag.TotalBook = dao.GetTotalBook(itemID);
            ViewBag.FreeBook = dao.GetFreeBook(itemID);
            ViewBag.InforCopyNumber = dao.GetInforCopyNumberList(itemID);
            ViewBag.RelatedTerm = dao.SP_OPAC_RELATED_TERMS_LIST(itemID);
            ViewBag.BookTitle = dao.GetItemTitle(itemID);
            ViewBag.FullBookInfo = dao.GetFullInforBook(itemID);
            TempData["itemID"] = itemID;
            TempData["code"] = code;

            return View(dao.SP_CATA_GET_CONTENTS_OF_ITEMS_LIST(itemID, 0));
        }

        [HttpPost]
        public ActionResult GetKeyword(string searchKeyword)
        {
            if (string.IsNullOrEmpty(searchKeyword.Trim()))
            {
                ViewBag.EmptyKeword = searchKeyword.Trim();
                TempData["errorMessage"] = "Ô tìm kiếm không được để trống";
                return RedirectToAction("Home", "Home");
            }
            else
            {
                Session["searchKey"] = searchKeyword.Trim();
            }

            return RedirectToAction("SearchBook", new { page = 1 });
        }

        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        public ActionResult SearchBook(int page)
        {
            string key = Session["searchKey"].ToString();
            int maxItemInOnePage = 10;
            ViewBag.NumberResult = dao.GetNumberResult(key, page, maxItemInOnePage);
            ViewBag.ItemInOnePage = maxItemInOnePage;
            Session["PageNo"] = page;

            return View(dao.GetSearchingBook(key, page, maxItemInOnePage));
        }

        public ActionResult AdvancedSearchBook()
        {
            return View();
        }
    }
}