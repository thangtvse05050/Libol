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
    
    public partial class MARC_LINK_TYPE
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MARC_LINK_TYPE()
        {
            this.MARC_AUTHORITY_FIELD = new HashSet<MARC_AUTHORITY_FIELD>();
            this.MARC_BIB_FIELD = new HashSet<MARC_BIB_FIELD>();
        }
    
        public int ID { get; set; }
        public string Type { get; set; }
        public int InvertID { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MARC_AUTHORITY_FIELD> MARC_AUTHORITY_FIELD { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MARC_BIB_FIELD> MARC_BIB_FIELD { get; set; }
    }
}
