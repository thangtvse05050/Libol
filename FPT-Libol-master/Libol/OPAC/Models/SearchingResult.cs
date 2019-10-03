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
        public string PublishInfo { get; set; }
        public string PhysicInfo { get; set; }
    }
}