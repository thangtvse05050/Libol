using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OPAC.Models;

namespace OPAC.Controllers
{
    public class LoginController : Controller
    {
        private OpacEntities db = new OpacEntities();
        // GET: Login
        public ActionResult Login()
        {
            if (Session["ID"] != null)
            {
                return RedirectToAction("Home", "Home");
            }
            return View();
        }
        [HttpPost]
        public ActionResult Login(string username, string password)
        {
            
            var checkUser = db.SP_OPAC_CHECK_PATRON_CARD(username, password).ToList();
            if (checkUser.Count > 0)
            {
                int UserID = checkUser[0].ID;
                Session["ID"] = UserID;
                
                return RedirectToAction("PatronAfterLoginPage", "InformationPatron");
            }
            else
            {
                ViewData["Notification"] = "Tên đăng nhập/mật khẩu không đúng!";
                return View();
            }

        }

    }
}