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
    
    public partial class OPAC_SUBJECT_BBK
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public OPAC_SUBJECT_BBK()
        {
            this.OPAC_SUBJECT_BBK1 = new HashSet<OPAC_SUBJECT_BBK>();
        }
    
        public string Number { get; set; }
        public int ID { get; set; }
        public Nullable<int> ParentID { get; set; }
        public string Code { get; set; }
        public string Caption { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<OPAC_SUBJECT_BBK> OPAC_SUBJECT_BBK1 { get; set; }
        public virtual OPAC_SUBJECT_BBK OPAC_SUBJECT_BBK2 { get; set; }
    }
}
