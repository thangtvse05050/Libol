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
    
    public partial class ITEM_SH
    {
        public int ItemID { get; set; }
        public int SHID { get; set; }
        public string FieldCode { get; set; }
    
        public virtual CAT_DIC_SH CAT_DIC_SH { get; set; }
        public virtual ITEM ITEM { get; set; }
    }
}
