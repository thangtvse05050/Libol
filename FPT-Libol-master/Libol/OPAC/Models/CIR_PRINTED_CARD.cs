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
    
    public partial class CIR_PRINTED_CARD
    {
        public int ID { get; set; }
        public int PatronID { get; set; }
        public int TemplateID { get; set; }
        public int IssueLibraryID { get; set; }
        public System.DateTime PrintedDate { get; set; }
    
        public virtual CIR_PATRON CIR_PATRON { get; set; }
    }
}
