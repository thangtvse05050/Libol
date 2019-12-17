using OPAC.Dao;
using OPAC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace OPAC.Controllers
{
    public class InformationPatronController : Controller
    {
        private OpacEntities dbContext = new OpacEntities();
        private PatronDao dao = new PatronDao();

        //Show information of Patron
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        [Route("Patron")]
        public ActionResult PatronAfterLoginPage()
        {
            var patron = (SP_OPAC_CHECK_PATRON_CARD_Result)Session["Info"];

            return View(patron);
        }

        [HttpPost]
        public ActionResult PatronAfterLoginPage(string username, string password)
        {
            var checkUser = dbContext.SP_OPAC_CHECK_PATRON_CARD(username, password).FirstOrDefault();

            if (checkUser != null)
            {
                int userId = checkUser.ID;
                Session["ID"] = userId;
                Session["Info"] = checkUser;
                Session["OnHolding"] = checkUser.Code;

                return View(checkUser);
            }

            TempData["LoginFail1"] = "Tên đăng nhập/mật khẩu không đúng!";

            return View();
        }

        //Change password of Patron
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        [HttpPost]
        public ActionResult UpdatePatron(string newPassword)
        {
            if (Session["ID"] != null)
            {
                var userID = (int)Session["ID"];
                dao.UpdatePassword(newPassword, userID);
                TempData["success"] = "Đổi mật khẩu thành công!";
            }

            return RedirectToAction("PatronAfterLoginPage");
        }

        //View the borrowing book (Sách đang mượn)
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        [Route("Borrowing")]
        public ActionResult BookBorrowingPage()
        {
            if (Session["OnHolding"] == null)
            {
                return View();
            }

            string studentCode = Session["OnHolding"].ToString();
            var listBookOnHolding = dbContext.SP_OPAC_GET_ONHOLDING(studentCode).ToList();
            string[] specialCharacterList = { "$a", "$b", "$c", "$p", "$e", "$n" };
            foreach (var item in listBookOnHolding)
            {
                foreach (var specialCharacter in specialCharacterList)
                {
                    item.Content = item.Content.Replace(specialCharacter, 
                        item.Content.Contains(specialCharacter[0]) ? "" : " ");
                }

                item.CODate = item.CODate.Replace("0:0", "").Trim();
                item.CIDate = item.CIDate.Replace("0:0", "").Trim();
            }

            TempData["Flag"] = null;
            TempData["CountResultList"] = 0;

            return View(listBookOnHolding);
        }

        [HttpPost]
        public ActionResult BookBorrowingPage(string username, string password)
        {
            var checkUser = dbContext.SP_OPAC_CHECK_PATRON_CARD(username, password).FirstOrDefault();

            if (checkUser != null)
            {
                int userId = checkUser.ID;
                Session["ID"] = userId;
                Session["Info"] = checkUser;
                Session["OnHolding"] = checkUser.Code;

                return RedirectToAction("BookBorrowingPage");
            }

            TempData["LoginFail2"] = "Tên đăng nhập/mật khẩu không đúng!";

            return View();
        }

        //Renew the returned date of the book (Gia hạn ngày trả sách)
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        [HttpPost]
        public ActionResult ExtendDate(string newDate, int countRenew, int ID)
        {
            dao.ExtendDate(newDate, countRenew, ID);
            TempData["ExtendSuccessMessage"] = "Gia hạn thành công!!";

            return RedirectToAction("BookBorrowingPage");
        }

        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        [Route("RegisterToBorrow")]
        public ActionResult RegisterToBorrowBookPage()
        {
            //List được sắp xếp theo thứ tự: sách đặt mượn sẽ được thông báo sau, sách đặt mượn thành công và sách đã quá hạn
            var onHoldingList = dao.GetOnHoldingList(Convert.ToString(Session["OnHolding"]))
                .OrderByDescending(t => t.TimeOutDate == DateTime.MinValue).ThenByDescending(t => t.TimeOutDate).ToList();
            TempData["CountResultList"] = 0;
            TempData["Flag"] = null;

            return View(onHoldingList);
        }

        [HttpPost]
        public ActionResult RegisterToBorrowBookPage(string username, string password)
        {
            var checkUser = dbContext.SP_OPAC_CHECK_PATRON_CARD(username, password).FirstOrDefault();

            if (checkUser != null)
            {
                int userId = checkUser.ID;
                Session["ID"] = userId;
                Session["Info"] = checkUser;
                Session["OnHolding"] = checkUser.Code;
                var onHoldingList = dao.GetOnHoldingList(checkUser.Code).OrderByDescending(t => t.TimeOutDate == DateTime.MinValue)
                    .ThenByDescending(t => t.TimeOutDate).ToList();

                return View(onHoldingList);
            }

            TempData["LoginFail3"] = "Tên đăng nhập/mật khẩu không đúng!";

            return View();
        }

        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
        [Route("History")]
        public ActionResult ViewHistoryPage()
        {
            int patronID = 0;
            if (Session["ID"] != null)
            {
                patronID = (int) Session["ID"];
                TempData["Flag"] = null;
            }

            TempData["CountResultList"] = 0;
            TempData["Flag"] = null;

            return View(dao.GetLoanHistoryList(patronID));
        }

        [HttpPost]
        public ActionResult ViewHistoryPage(string username, string password)
        {
            var checkUser = dbContext.SP_OPAC_CHECK_PATRON_CARD(username, password).FirstOrDefault();

            if (checkUser != null)
            {
                int userId = checkUser.ID;
                Session["ID"] = userId;
                Session["Info"] = checkUser;
                Session["OnHolding"] = checkUser.Code;

                return RedirectToAction("ViewHistoryPage");
            }

            TempData["LoginFail4"] = "Tên đăng nhập/mật khẩu không đúng!";

            return View();
        }
    }
}