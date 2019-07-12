declare module "@salesforce/apex/CancelOrderController.process" {
  export default function process(param: {orderId: any, jsonString: any}): Promise<any>;
}
declare module "@salesforce/apex/CancelOrderController.getOrderProducts" {
  export default function getOrderProducts(param: {orderId: any, searchKeyword: any}): Promise<any>;
}
