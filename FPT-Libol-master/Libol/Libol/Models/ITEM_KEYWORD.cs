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
    
    public partial class ITEM_KEYWORD
    {
        public int ItemID { get; set; }
        public int KeyWordID { get; set; }
        public string FieldCode { get; set; }
    
        public virtual CAT_DIC_KEYWORD CAT_DIC_KEYWORD { get; set; }
        public virtual ITEM ITEM { get; set; }
    }
}
