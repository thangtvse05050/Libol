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
    
    public partial class CAT_DIC_COUNTRY
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CAT_DIC_COUNTRY()
        {
            this.ACQ_ITEM = new HashSet<ACQ_ITEM>();
            this.ACQ_VENDOR = new HashSet<ACQ_VENDOR>();
            this.ITEMs = new HashSet<ITEM>();
            this.CIR_PATRON_OTHER_ADDR = new HashSet<CIR_PATRON_OTHER_ADDR>();
            this.EDELIV_USER = new HashSet<EDELIV_USER>();
            this.ITEM_COUNTRY = new HashSet<ITEM_COUNTRY>();
        }
    
        public int ID { get; set; }
        public string DisplayEntry { get; set; }
        public string AccessEntry { get; set; }
        public Nullable<int> DicItemID { get; set; }
        public string ISOCode { get; set; }
        public string NameViet { get; set; }
        public string Name { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ACQ_ITEM> ACQ_ITEM { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ACQ_VENDOR> ACQ_VENDOR { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ITEM> ITEMs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CIR_PATRON_OTHER_ADDR> CIR_PATRON_OTHER_ADDR { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EDELIV_USER> EDELIV_USER { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ITEM_COUNTRY> ITEM_COUNTRY { get; set; }
    }
}
