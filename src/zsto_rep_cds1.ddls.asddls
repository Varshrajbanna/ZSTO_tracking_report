@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sto report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTO_REP_CDS1 as select from I_MaterialDocumentItem_2
{
    key Plant,
    key IssuingOrReceivingPlant,
    key PurchaseOrder ,
    key PurchaseOrderItem,
    key DeliveryDocument,
    key DeliveryDocumentItem,
    PostingDate,
    Batch,
    MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    QuantityInBaseUnit
}
   where GoodsMovementType = '641' and GoodsMovementIsCancelled = ''
        and DebitCreditCode = 'H'
