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
    
    public partial class ILL_INCOMING_REQUESTS_BILINF
    {
        public int ID { get; set; }
        public string BillDelivName { get; set; }
        public string BillDelivXAddress { get; set; }
        public string BillDelivBox { get; set; }
        public string BillDelivStreet { get; set; }
        public string BillDelivCity { get; set; }
        public string BillDelivRegion { get; set; }
        public Nullable<int> BillDelivCountry { get; set; }
        public string BillDelivCode { get; set; }
    }
}
