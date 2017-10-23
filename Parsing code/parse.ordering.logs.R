### parsing ordering logs - swiggy data.
### Pre processed logs
### code: Ashwin Ravi
### load libraries
library(ggplot2)
library(dplyr)
library(lubridate)
library(data.table)

### load raw data as an one column table
raw.data = read.table(file = 'order.raw.data.2.csv', sep = '\t', header = FALSE, stringsAsFactors = FALSE)
## define sample template
parsed.data = data.frame(order_id = as.character(), order_status = as.character(), time_of_order = as.character(), order_acceptance_time = as.character(),
                         order_pickup_time = as.character(), order_delivery_time = as.character(), total_billed_amount = as.character(),
                         tax_restaurant = as.character(), gst_enabled = as.character(), item_sgst = as.character(), item_cgst = as.character(), item_igst = as.character(),
                         packaging_charge_sgst = as.character(), packaging_charge_cgst = as.character(), packaging_charge_igst = as.character(), service_charge_sgst = as.character(),
                         service_charge_cgst = as.character(), service_charge_igst = as.character(), item_gst_inclusive = as.character(), packaging_gst_inclusive = as.character(),
                         service_charge_gst_inclusive = as.character(), restaurant_discount = as.character(), packing_charge = as.character(), cancelled_reason = as.character(),
                         food_prepared = as.character(), order_cancellation_time = as.character(), edited_status = as.character(), customer_comment = as.character(), customer_area = as.character(),
                         customer_distance = as.character(), total_item_count = as.character(), sub_item_name = as.character(), sub_item_qty = as.character(), sub_item_total_cost = as.character(),
                         stringsAsFactors = FALSE)
## begin log parsing
for(i in 1:dim(raw.data)[1]){
  log.line = raw.data$V1[i]
  parsed.log.line = unlist(strsplit(log.line,split = ','))
  total_elements = length(parsed.log.line)
  constant.feed = parsed.log.line[1:31]
  unparsed_elements = parsed.log.line[32:total_elements]
  unparsed_elements = unparsed_elements[unparsed_elements != '']
  for(j in 1:length(unparsed_elements)){
    line_items = unlist(strsplit(unparsed_elements[j], split = '_'))
    parsed.data[dim(parsed.data)[1]+1,] = as.list(append(constant.feed,line_items))
  }
}

str(parsed.data)

## make edits to the table structure
parsed.data = parsed.data %>% mutate(total_billed_amount= as.numeric(total_billed_amount),
                                     total_item_count = as.numeric(total_item_count),
                                     sub_item_qty = as.numeric(sub_item_qty),
                                     sub_item_total_cost = as.numeric(sub_item_total_cost)
                                   ) %>% mutate(sub_item_unit_cost = sub_item_total_cost / sub_item_qty)


## wiryte back to a file
write.csv(parsed.data, file = 'parsed.logs.csv', row.names = FALSE)
