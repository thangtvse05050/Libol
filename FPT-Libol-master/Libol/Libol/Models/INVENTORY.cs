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
    
    public partial class INVENTORY
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public INVENTORY()
        {
            this.HOLDING_INVENTORY = new HashSet<HOLDING_INVENTORY>();
        }
    
        public int ID { get; set; }
        public string Name { get; set; }
        public System.DateTime OpenedDate { get; set; }
        public Nullable<System.DateTime> ClosedDate { get; set; }
        public string DoneBy { get; set; }
        public bool Status { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<HOLDING_INVENTORY> HOLDING_INVENTORY { get; set; }
    }
}
