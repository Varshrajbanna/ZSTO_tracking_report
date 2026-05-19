@AbapCatalog.sqlViewName: 'YTRACKCDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For STO Tracking Report'
@Metadata.ignorePropagatedAnnotations: true
define view ZSTO_Tracking_Rep_CDS as select from ZSTO_REP_CDS1 as a
left outer join I_PurchaseOrderAPI01 as B on (B.PurchaseOrder = a.PurchaseOrder )
left outer join I_PurchaseOrderItemAPI01 as c on (c.PurchaseOrder = a.PurchaseOrder and c.PurchaseOrderItem = a.PurchaseOrderItem )
left outer join I_DeliveryDocumentItem as k on a.Plant = k.Plant and a.DeliveryDocument = k.DeliveryDocument and a.DeliveryDocumentItem = k.DeliveryDocumentItem
left outer join ZI_BillingDocumentItem_COGS  as d on (d.ReferenceSDDocument = k.DeliveryDocument and d.ReferenceSDDocumentItem = k.HigherLvlItmOfBatSpltItm and k.HigherLvlItmOfBatSpltItm <> '000000')
                                                 or (d.ReferenceSDDocument = a.DeliveryDocument and d.ReferenceSDDocumentItem = a.DeliveryDocumentItem and k.HigherLvlItmOfBatSpltItm = '000000' )
left outer join I_BillingDocument as e on (e.BillingDocument = d.BillingDocument )
left outer join I_DeliveryDocument as f on (f.DeliveryDocument = a.DeliveryDocument )
left outer join I_MaterialDocumentItem_2 as g on ( g.DeliveryDocument = a.DeliveryDocument and g.DeliveryDocumentItem = a.DeliveryDocumentItem 
and g.PurchaseOrder = a.PurchaseOrder and g.PurchaseOrderItem = a.PurchaseOrderItem and g.GoodsMovementIsCancelled = '' and g.GoodsMovementType = '101' )
left outer join I_MaterialDocumentItem_2 as h on ( h.PurchaseOrder = a.PurchaseOrder and h.PurchaseOrderItem = a.PurchaseOrderItem 
                                                   and h.GoodsMovementIsCancelled = '' and h.GoodsMovementType = '101' 
                                                   and ( g.MaterialDocument is initial or g.MaterialDocument is null or g.MaterialDocument = '') )

{
    @UI.lineItem   : [{ position: 10 }]
    @UI.identification: [{position: 10}]
    @EndUserText.label: 'Receiving Plant' 
    @UI.selectionField: [{ position: 10 }]
    @Consumption.valueHelpDefinition: [ 
        { entity:  { name:    'I_Plant',
                     element: 'Plant' }
        }]
    key a.IssuingOrReceivingPlant   as ReceivingPlant,
    @UI.lineItem   : [{ position: 11 }]
    @UI.identification: [{position: 11}]
    @EndUserText.label: 'Supplying Plant' 
    @UI.selectionField: [{ position: 11 }]
    @Consumption.valueHelpDefinition: [ 
        { entity:  { name:    'I_Plant',
                     element: 'Plant' }
        }]
    key a.Plant   as SupplyingPlant ,
    @UI.lineItem   : [{ position: 12 }]
    @UI.identification: [{position: 12}]
    @EndUserText.label: 'Stock Transfer Order' 
    key a.PurchaseOrder   as StockTransferOrder,
    @UI.lineItem   : [{ position: 13 }]
    @UI.identification: [{position: 13}]
    @EndUserText.label: 'Purchase Order Item' 
    key a.PurchaseOrderItem,
    @UI.lineItem   : [{ position: 14 }]
    @UI.identification: [{position: 14}]
    @EndUserText.label: 'Purchase Order Date' 
      key   B.PurchaseOrderDate,
    @UI.lineItem   : [{ position: 15 }]
    @UI.identification: [{position: 15}]
     @UI.selectionField: [{ position: 11 }]
    @EndUserText.label: 'Material' 
      key   c.Material,
    @UI.lineItem   : [{ position: 16 }]
    @UI.identification: [{position: 16}]
    @EndUserText.label: 'Description' 
      key   c.PurchaseOrderItemText as Description, 

    @UI.lineItem   : [{ position: 18 }]
    @UI.identification: [{position: 18}]
    @EndUserText.label: 'UOM'  
      key   c.BaseUnit as uom,
    @UI.lineItem   : [{ position: 19 }]
    @UI.identification: [{position: 19}]
    @EndUserText.label: 'Delivery Document'   
      key   a.DeliveryDocument,
    @UI.lineItem   : [{ position: 20 }]
    @UI.identification: [{position: 20}]
    @EndUserText.label: 'Goods Movement Status'   
      key   f.OverallGoodsMovementStatus as GoodsMovementStatus,
    @UI.lineItem   : [{ position: 21 }]
    @UI.identification: [{position: 21}]
    @EndUserText.label: 'Delivery Document Item'   
      key   a.DeliveryDocumentItem,
    @UI.lineItem   : [{ position: 22 }]
    @UI.identification: [{position: 22}]
    @EndUserText.label: 'Posting Date'  
    @UI.selectionField: [{ position: 13 }]   
      key   a.PostingDate,

    @UI.lineItem   : [{ position: 24 }]
    @UI.identification: [{position: 24}]
    @EndUserText.label: 'Batch'   
      key   a.Batch,
    @UI.lineItem   : [{ position: 25 }]
    @UI.identification: [{position: 25}]
    @EndUserText.label: 'Invoice No.'    
      key   d.BillingDocument  as InvoiceNo,
    @UI.lineItem   : [{ position: 26 }]
    @UI.identification: [{position: 26}]
    @EndUserText.label: 'Invoice Date'   
      key   e.CreationDate as InvoiceDate,

    @UI.lineItem   : [{ position: 28 }]
    @UI.identification: [{position: 28}]
    @EndUserText.label: 'GRN Number'  
      key   case when ( g.MaterialDocument is initial or g.MaterialDocument is null or g.MaterialDocument = '') then h.MaterialDocument  else g.MaterialDocument end  as   GRNNumber,
    @UI.lineItem   : [{ position: 29 }]
    @UI.identification: [{position: 29}]
    @EndUserText.label: 'GRN Date' 
      key   case when ( g.MaterialDocument is initial or g.MaterialDocument is null or g.MaterialDocument = '') then h.PostingDate else g.PostingDate end as GRNDate,
    @UI.lineItem   : [{ position: 30 }]
    @UI.identification: [{position: 30}]
    @Aggregation.default: #SUM
    @EndUserText.label: 'GRN Qty' 
        case when ( g.MaterialDocument is initial or g.MaterialDocument is null or g.MaterialDocument = '') then h.QuantityInBaseUnit else g.QuantityInBaseUnit end as GRNQty ,
         @UI.lineItem   : [{ position: 17 }]
    @UI.identification: [{position: 17}]
    @EndUserText.label: 'Quantity' 
    @Aggregation.default: #SUM
     c.OrderQuantity as Quantity,  
         @UI.lineItem   : [{ position: 27 }]
    @UI.identification: [{position: 27}]
    @EndUserText.label: 'Invoice Qty'  
    @Aggregation.default: #SUM      
        d.BillingQuantityInBaseUnit  as InvoiceQty, 
            @UI.lineItem   : [{ position: 23 }]
    @UI.identification: [{position: 23}]
    @EndUserText.label: 'Delivery Qty' 
    @Aggregation.default: #SUM       
        a.QuantityInBaseUnit as DeliveryQty 
}

