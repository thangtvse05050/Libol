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
    
    public partial class SYS_EVENT_GROUP
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SYS_EVENT_GROUP()
        {
            this.SYS_LOG = new HashSet<SYS_LOG>();
            this.HOLDING_LOCATION = new HashSet<HOLDING_LOCATION>();
        }
    
        public bool LogMode { get; set; }
        public string Description { get; set; }
        public int ID { get; set; }
        public Nullable<int> ParentID { get; set; }
        public string VietName { get; set; }
        public string Name { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYS_LOG> SYS_LOG { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<HOLDING_LOCATION> HOLDING_LOCATION { get; set; }
    }
}
