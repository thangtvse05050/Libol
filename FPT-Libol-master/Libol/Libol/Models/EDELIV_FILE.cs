//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Libol.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class EDELIV_FILE
    {
        public int ID { get; set; }
        public Nullable<int> ItemID { get; set; }
        public string URL { get; set; }
        public string Filename { get; set; }
        public string FileSize { get; set; }
        public Nullable<decimal> Price { get; set; }
        public string Currency { get; set; }
        public string Note { get; set; }
        public string Pagination { get; set; }
        public string FileFormat { get; set; }
    
        public virtual ACQ_CURRENCY ACQ_CURRENCY { get; set; }
        public virtual ITEM ITEM { get; set; }
    }
}