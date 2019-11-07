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
    
    public partial class EDELIV_USER
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public EDELIV_USER()
        {
            this.EDELIV_PAYMENT = new HashSet<EDELIV_PAYMENT>();
            this.EDELIV_REQUEST = new HashSet<EDELIV_REQUEST>();
        }
    
        public int UserID { get; set; }
        public string Username { get; set; }
        public string Name { get; set; }
        public string DelivName { get; set; }
        public string DelivXAddr { get; set; }
        public string DelivStreet { get; set; }
        public string DelivBox { get; set; }
        public string DelivCity { get; set; }
        public string DelivRegion { get; set; }
        public Nullable<int> DelivCountry { get; set; }
        public string DelivCode { get; set; }
        public string Telephone { get; set; }
        public string EmailAddress { get; set; }
        public string Note { get; set; }
        public string Password { get; set; }
        public decimal Debt { get; set; }
        public bool Approved { get; set; }
        public string Fax { get; set; }
        public string ContactPerson { get; set; }
        public int SecretLevel { get; set; }
    
        public virtual CAT_DIC_COUNTRY CAT_DIC_COUNTRY { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EDELIV_PAYMENT> EDELIV_PAYMENT { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EDELIV_REQUEST> EDELIV_REQUEST { get; set; }
    }
}
