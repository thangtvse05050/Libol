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
    
    public partial class SYS_USER_RIGHT_DETAIL
    {
        public int RightID { get; set; }
        public int UserID { get; set; }
        public int ID { get; set; }
    
        public virtual SYS_USER SYS_USER { get; set; }
        public virtual SYS_USER_RIGHT SYS_USER_RIGHT { get; set; }
    }
}
