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
    
    public partial class SP_ILL_GET_IR_DETAIL_Result
    {
        public string MediumDisplay { get; set; }
        public string dPaymentType { get; set; }
        public bool Alert { get; set; }
        public string Barcode { get; set; }
        public Nullable<System.DateTime> CancelledDate { get; set; }
        public Nullable<byte> ChargeableUnits { get; set; }
        public Nullable<System.DateTime> CheckedInDate { get; set; }
        public Nullable<System.DateTime> CheckedOutDate { get; set; }
        public byte CopyrightCompliance { get; set; }
        public Nullable<decimal> Cost { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyCode1 { get; set; }
        public string CurrencyCode2 { get; set; }
        public string CurrencyCode3 { get; set; }
        public Nullable<byte> DelivConditionID { get; set; }
        public byte DelivMode { get; set; }
        public Nullable<System.DateTime> DueDate { get; set; }
        public string EDelivMode { get; set; }
        public string EDelivTSAddr { get; set; }
        public string EmailReplyAddress { get; set; }
        public Nullable<System.DateTime> ExpiryDate { get; set; }
        public int ID { get; set; }
        public Nullable<decimal> InsuredForCost { get; set; }
        public string InternalRefNumber { get; set; }
        public Nullable<int> ItemType { get; set; }
        public Nullable<byte> LoanTypeID { get; set; }
        public Nullable<decimal> MaxCost { get; set; }
        public Nullable<byte> Medium { get; set; }
        public Nullable<System.DateTime> NeedBeforeDate { get; set; }
        public string Note { get; set; }
        public string PatronID { get; set; }
        public string PatronName { get; set; }
        public string PatronStatus { get; set; }
        public bool PaymentProvided { get; set; }
        public Nullable<byte> PaymentType { get; set; }
        public Nullable<byte> Priority { get; set; }
        public Nullable<System.DateTime> ReceivedDate { get; set; }
        public bool ReciprocalAgreement { get; set; }
        public bool Renewable { get; set; }
        public Nullable<short> Renewals { get; set; }
        public System.DateTime RequestDate { get; set; }
        public int RequesterID { get; set; }
        public string RequestID { get; set; }
        public Nullable<System.DateTime> RespondDate { get; set; }
        public Nullable<System.DateTime> ReturnedDate { get; set; }
        public Nullable<decimal> ReturnInsuranceCost { get; set; }
        public Nullable<byte> ReturnLocID { get; set; }
        public byte ServiceType { get; set; }
        public Nullable<System.DateTime> ShippedDate { get; set; }
        public string IssueID { get; set; }
        public Nullable<int> Status { get; set; }
        public Nullable<int> ItemID { get; set; }
        public string Title { get; set; }
        public Nullable<byte> TransportationModeID { get; set; }
        public bool WillPayFee { get; set; }
        public Nullable<int> ID1 { get; set; }
        public Nullable<int> RequestType { get; set; }
        public string CallNumber { get; set; }
        public string Title1 { get; set; }
        public string Author { get; set; }
        public string PlaceOfPub { get; set; }
        public string Publisher { get; set; }
        public string SeriesTitleNumber { get; set; }
        public string VolumeIssue { get; set; }
        public string Edition { get; set; }
        public Nullable<System.DateTime> PubDate { get; set; }
        public Nullable<System.DateTime> ComponentPubDate { get; set; }
        public string ArticleAuthor { get; set; }
        public string ArticleTitle { get; set; }
        public string Pagination { get; set; }
        public string NationalBibNumber { get; set; }
        public string ISBN { get; set; }
        public string ISSN { get; set; }
        public Nullable<byte> ItemType1 { get; set; }
        public string SystemNumber { get; set; }
        public string OtherNumbers { get; set; }
        public string Verification { get; set; }
        public string LocalNote { get; set; }
        public string SponsoringBody { get; set; }
        public string LibrarySymbol { get; set; }
        public string EmailReplyAddress1 { get; set; }
        public string LibraryName { get; set; }
        public string AccountNumber { get; set; }
        public string dCopyrightCompliance { get; set; }
        public string dServiceType { get; set; }
        public System.DateTime dRequestDate { get; set; }
        public Nullable<System.DateTime> dNeedBeforeDate { get; set; }
        public Nullable<System.DateTime> dExpiryDate { get; set; }
        public Nullable<int> ID2 { get; set; }
        public string PostDelivName { get; set; }
        public string PostDelivXAddress { get; set; }
        public string PostDelivStreet { get; set; }
        public string PostDelivBox { get; set; }
        public string PostDelivCity { get; set; }
        public string PostDelivRegion { get; set; }
        public Nullable<int> PostDelivCountry { get; set; }
        public string PostDelivCode { get; set; }
        public string PostCountry { get; set; }
        public Nullable<int> ID3 { get; set; }
        public string BillDelivName { get; set; }
        public string BillDelivXAddress { get; set; }
        public string BillDelivBox { get; set; }
        public string BillDelivStreet { get; set; }
        public string BillDelivCity { get; set; }
        public string BillDelivRegion { get; set; }
        public Nullable<int> BillDelivCountry { get; set; }
        public string BillDelivCode { get; set; }
        public string BillCountry { get; set; }
        public string ItemTypeName { get; set; }
        public string LoanType { get; set; }
    }
}
