@AbapCatalog.sqlViewName: 'YSTOTRACKREP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For STO Tracking Report'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BillingDocumentItem_COGS as select from I_BillingDocument as a 
  left outer join I_BillingDocumentItem as b on (b.BillingDocument = a.BillingDocument and b.CompanyCode = a.CompanyCode )
{
    key a.BillingDocument,
    key b.BillingDocumentItem,
    key a.CompanyCode,
    key b.ReferenceSDDocument,
    key b.ReferenceSDDocumentItem,
        a.BillingDocumentDate,
        a.TransactionCurrency,
        a.PayerParty,
        b.BillingQuantityInBaseUnit
}  
  where  a.CancelledBillingDocument <> 'X'  and a.AccountingTransferStatus <> 'E'
  and b.ReturnItemProcessingType = ''
  and a.CancelledBillingDocument = ''
   group by 
   
     a.BillingDocument,
     b.BillingDocumentItem,
     b.ReferenceSDDocumentItem,
     a.CompanyCode,
     b.ReferenceSDDocument,
     a.BillingDocumentDate,
     a.TransactionCurrency,
     a.PayerParty,
     b.BillingQuantityInBaseUnit
