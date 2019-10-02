using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OPAC.Models
{
    public class SearchingResult
    {
        public int ItemID { get; set; }
        public string Title { get; set; }
        public string Publisher { get; set; }
        public string Year { get; set; }
        public string Author { get; set; }
        public string CopyNumber { get; set; }
    }
}