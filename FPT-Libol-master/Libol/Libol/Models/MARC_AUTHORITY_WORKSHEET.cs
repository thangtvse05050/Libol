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
    
    public partial class MARC_AUTHORITY_WORKSHEET
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MARC_AUTHORITY_WORKSHEET()
        {
            this.MARC_AUTHORITY_WS_DETAIL = new HashSet<MARC_AUTHORITY_WS_DETAIL>();
        }
    
        public int ID { get; set; }
        public string Name { get; set; }
        public string Creator { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public string Note { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MARC_AUTHORITY_WS_DETAIL> MARC_AUTHORITY_WS_DETAIL { get; set; }
    }
}