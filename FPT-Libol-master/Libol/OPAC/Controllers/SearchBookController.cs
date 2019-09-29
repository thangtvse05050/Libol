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
        public ActionResult DetailBook(int itemID)
        {
            ViewBag.OnHoldingBook = dao.GetOnHoldingBook(itemID);
            ViewBag.TotalBook = dao.GetTotalBook(itemID);
            ViewBag.FreeBook = dao.GetFreeBook(itemID);
            ViewBag.InforCopyNumber = dao.GetInforCopyNumberList(itemID);

            return View(dao.SP_CATA_GET_CONTENTS_OF_ITEMS_LIST(itemID, 0));
        }

        [HttpPost]
        public ActionResult GetKeyword(string searchKeyword)
        {
            Session["searchKey"] = searchKeyword;

            return RedirectToAction("SearchBook", new { page = 1 });
        }

        public ActionResult SearchBook(int page)
        {
            string key = Session["searchKey"].ToString();
            int maxItemInOnePage = 10;
            ViewBag.NumberResult = dao.GetNumberResult(key, page, maxItemInOnePage);
            ViewBag.ItemInOnePage = maxItemInOnePage;
            Session["pageNo"] = page;

            return View(dao.GetSearchingBook(key, page, maxItemInOnePage));
        }

        public ActionResult AdvancedSearchBook()
        {
            return View();
        }
    }
}