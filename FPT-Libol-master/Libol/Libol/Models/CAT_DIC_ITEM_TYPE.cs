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
    
    public partial class CAT_DIC_ITEM_TYPE
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CAT_DIC_ITEM_TYPE()
        {
            this.ACQ_ITEM = new HashSet<ACQ_ITEM>();
            this.ITEMs = new HashSet<ITEM>();
        }
    
        public int ID { get; set; }
        public string TypeName { get; set; }
        public string TypeCode { get; set; }
        public string AccessEntry { get; set; }
        public bool IsNotSystem { get; set; }
        public Nullable<int> DicItemID { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ACQ_ITEM> ACQ_ITEM { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ITEM> ITEMs { get; set; }
    }
}
