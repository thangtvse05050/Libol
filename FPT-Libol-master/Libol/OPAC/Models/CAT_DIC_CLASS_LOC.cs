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
    
    public partial class CAT_DIC_CLASS_LOC
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CAT_DIC_CLASS_LOC()
        {
            this.ITEM_LOC = new HashSet<ITEM_LOC>();
        }
    
        public string DisplayEntry { get; set; }
        public Nullable<int> DicItemID { get; set; }
        public int ID { get; set; }
        public string AccessEntry { get; set; }
        public string Name { get; set; }
        public string NameViet { get; set; }
        public string Note { get; set; }
        public Nullable<int> ParentID { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ITEM_LOC> ITEM_LOC { get; set; }
    }
}
