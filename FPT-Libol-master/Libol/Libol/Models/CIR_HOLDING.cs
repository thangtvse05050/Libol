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
    
    public partial class CIR_HOLDING
    {
        public int ID { get; set; }
        public bool CheckMail { get; set; }
        public Nullable<int> ItemID { get; set; }
        public Nullable<bool> InTurn { get; set; }
        public string CopyNumber { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<System.DateTime> TimeOutDate { get; set; }
        public Nullable<System.DateTime> ExpiredDate { get; set; }
        public string PatronCode { get; set; }
        public Nullable<bool> CopySpecified { get; set; }
    
        public virtual ITEM ITEM { get; set; }
    }
}