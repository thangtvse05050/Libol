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
    
    public partial class CIR_PATRON_BLOCK
    {
        public int ID { get; set; }
        public int PatronID { get; set; }
        public Nullable<System.DateTime> FromDate { get; set; }
        public int NumberOfDays { get; set; }
    
        public virtual CIR_PATRON CIR_PATRON { get; set; }
    }
}