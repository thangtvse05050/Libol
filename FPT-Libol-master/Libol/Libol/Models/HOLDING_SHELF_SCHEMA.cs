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
    
    public partial class HOLDING_SHELF_SCHEMA
    {
        public int LibID { get; set; }
        public int LocID { get; set; }
        public string Shelf { get; set; }
        public int Width { get; set; }
        public int Depth { get; set; }
        public bool Direction { get; set; }
        public int TopCoor { get; set; }
        public int LeftCoor { get; set; }
    
        public virtual HOLDING_LIBRARY HOLDING_LIBRARY { get; set; }
        public virtual HOLDING_LOCATION HOLDING_LOCATION { get; set; }
    }
}
