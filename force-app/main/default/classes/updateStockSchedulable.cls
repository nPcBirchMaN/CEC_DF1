global class updateStockSchedulable Implements Schedulable {
    global void execute(SchedulableContext sc)
    {
        Integer batchSize = Integer.valueOf(Label.updateProductStockBatchSize);
        updateProductStockBatch btch = new updateProductStockBatch();
        Database.executeBatch(btch, batchSize);
    }
}