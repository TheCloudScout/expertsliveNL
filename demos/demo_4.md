# Demo 4 KQL queries drilldown

## Usage in the last month

```kql
Usage
| where TimeGenerated between(startofday(ago(31d)) .. endofday(ago(1d)))
| where IsBillable = true
| summarize TotalGB = sum(Quantity) / 1000 by DataType
| render piechart
```

## Timechart over time

```kql
Usage
| where TimeGenerated > ago(90d)
| where IsBillable = true
| summarize TotalGB = sum(Quantity) / 1000 by bin(TimeGenerated, 1d)
| render timechart
```

## Sudden spike in usage in April

```kql
Usage
| where TimeGenerated between(startofday(datetime("2025-01-17")) .. endofday(datetime("2025-04-17")))
| where IsBillable = true
| summarize TotalGB = sum(Quantity) / 1000 by bin(TimeGenerated, 1d)
| render timechart
```

## Compare April 17th with the same day a week earlier

```kql
let HighUsageDay = Usage
    | where TimeGenerated between(startofday(datetime("2025-04-16")) .. endofday(datetime("2025-04-17")))
    | where IsBillable = true
    | summarize totalGb = sum(Quantity) / 1000 by DataType
    | extend TimeGenerated = datetime("2025-04-17"); // Add last day of the timespan
let NormalUsageDay = Usage
    | where TimeGenerated between(startofday(datetime("2025-04-09")) .. endofday(datetime("2025-04-10")))
    | where IsBillable = true
    | summarize totalGb = sum(Quantity) / 1000 by DataType
    | extend TimeGenerated = datetime("2025-04-10"); // Add last day of the timespan
HighUsageDay | union NormalUsageDay
| render columnchart with(title="Usage day comparisson April 10th vs April 17th", xtitle="TimeGenerated", ytitle="Total Usage", legend=hidden, kind=stacked)
```

## AADNonInteractiveUserSignInLogs seems to be the problem. Are there more logs ingested in that table?

```kql
AADNonInteractiveUserSignInLogs
| where TimeGenerated between(startofday(datetime("2025-01-17")) .. endofday(datetime("2025-04-17")))
| summarize count() by bin(TimeGenerated, 1d)
| render timechart
```

## Nope, let's zoom in on average column size

```kql
let HighUsageDay = AADNonInteractiveUserSignInLogs
    | where TimeGenerated between(startofday(datetime("2025-04-16")) .. endofday(datetime("2025-04-17")))
    | take 10000
    | evaluate narrow()
    | extend ColumnSizeBytes = estimate_data_size(Value)
    | summarize ColumnSizeBytes = make_list(ColumnSizeBytes) by Column
    | extend series_stats(ColumnSizeBytes)
    | project Column, series_stats_ColumnSizeBytes_avg
    | extend TimeGenerated = datetime("2025-04-17"); // Add last day of the timespan
let NormalUsageDay = AADNonInteractiveUserSignInLogs
    | where TimeGenerated between(startofday(datetime("2025-04-09")) .. endofday(datetime("2025-04-10")))
    | take 10000
    | evaluate narrow()
    | extend ColumnSizeBytes = estimate_data_size(Value)
    | summarize ColumnSizeBytes = make_list(ColumnSizeBytes) by Column
    | extend series_stats(ColumnSizeBytes)
    | project Column, series_stats_ColumnSizeBytes_avg
    | extend TimeGenerated = datetime("2025-04-10"); // Add last day of the timespan
HighUsageDay | union NormalUsageDay
| render columnchart with(title="Usage day comparisson April 10th vs April 17th", xtitle="TimeGenerated", ytitle="Total Usage", legend=hidden, kind=stacked)
```

## Normally we'd filter out the entire CondionalAccessPolicies column. Apparently the DCR was accidentally cleaned up by a Cloud engineer. It's handy to know how to calculate column sizes.

```kql
AADNonInteractiveUserSignInLogs
| where TimeGenerated between(startofday(datetime("2025-04-16")) .. endofday(datetime("2025-04-17")))
| count
```

// Over 1,5 million records! (1.667.412)

```kql
AADNonInteractiveUserSignInLogs
| where TimeGenerated between(startofday(datetime("2025-04-16")) .. endofday(datetime("2025-04-17")))
| take 10000
| evaluate narrow()
| extend ColumnSizeBytes = estimate_data_size(Value)
| summarize ColumnSizeBytes = make_list(ColumnSizeBytes) by Column
| extend series_stats(ColumnSizeBytes)
| project Column, series_stats_ColumnSizeBytes_avg
| sort by series_stats_ColumnSizeBytes_avg
```

That an average of 13,6 KB per row. = x 1.667.412 records = 22 GB per two days!!
Thats 330GB p/m = € 1700,- p/m

## Another incident with a different customer showed a huge sudden dip in usage

```kql
Usage
| where TimeGenerated between(startofday(datetime("2024-05-27")) .. endofday(datetime("2024-08-27")))
| where IsBillable = true
| summarize TotalGB = sum(Quantity) / 1000 by bin(TimeGenerated, 1d) //, DataType
| render timechart
```

## SecurityEvent seems to be cuasing the sudden dip

```kql
SecurityEvent
| where TimeGenerated between(startofday(datetime("2024-05-27")) .. endofday(datetime("2024-08-27")))
| summarize count() by bin(TimeGenerated, 1d)
| render timechart
```

## If we don't have datapoints over time, the graph can look misleading. It helps to create a series instead first. Missing points will be added with a zero value

```kql
SecurityEvent
| where TimeGenerated between(startofday(datetime("2024-05-27")) .. endofday(datetime("2024-08-27")))
| make-series num=count() default=0 on TimeGenerated from startofday(startofday(datetime("2024-05-27"))) to endofday(datetime("2024-08-27")) step 1d by Computer
| render timechart
```
