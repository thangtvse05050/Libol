//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace OPAC.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class CIR_PATRON_OTHER_ADDR
    {
        public int ID { get; set; }
        public int PatronID { get; set; }
        public string Address { get; set; }
        public int ProvinceID { get; set; }
        public string City { get; set; }
        public int CountryID { get; set; }
        public string ZIP { get; set; }
        public bool Active { get; set; }
    
        public virtual CAT_DIC_COUNTRY CAT_DIC_COUNTRY { get; set; }
        public virtual CIR_DIC_PROVINCE CIR_DIC_PROVINCE { get; set; }
        public virtual CIR_PATRON CIR_PATRON { get; set; }
    }
}
