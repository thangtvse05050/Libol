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
    
    public partial class CIR_PATRON_UNIVERSITY
    {
        public int PatronID { get; set; }
        public string Grade { get; set; }
        public Nullable<int> FacultyID { get; set; }
        public string Class { get; set; }
        public int CollegeID { get; set; }
    
        public virtual CIR_DIC_COLLEGE CIR_DIC_COLLEGE { get; set; }
        public virtual CIR_DIC_FACULTY CIR_DIC_FACULTY { get; set; }
        public virtual CIR_PATRON CIR_PATRON { get; set; }
    }
}