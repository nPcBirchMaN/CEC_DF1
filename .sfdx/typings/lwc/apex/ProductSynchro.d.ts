declare module "@salesforce/apex/ProductSynchro.ProductSynchronization" {
  export default function ProductSynchronization(param: {ProdId: any, Modo: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSynchro.GetProductStock" {
  export default function GetProductStock(param: {OrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSynchro.ChangeProductStock" {
  export default function ChangeProductStock(param: {productId: any, stockQuantity: any, eCommerce: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSynchro.CheckOrderProductsStock" {
  export default function CheckOrderProductsStock(param: {OrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSynchro.getStockByProductId" {
  export default function getStockByProductId(param: {productId: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSynchro.getSoldsByProductId" {
  export default function getSoldsByProductId(param: {productId: any}): Promise<any>;
}
