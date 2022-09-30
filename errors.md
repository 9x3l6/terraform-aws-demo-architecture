```sh
│ Error: error creating Route in Route Table (rtb-0bd6d8d18fcb31f79) with destination (0.0.0.0/0): InvalidParameterValue: route table rtb-0bd6d8d18fcb31f79 and network gateway igw-0b8c421486ee35f19 belong to different networks
│       status code: 400, request id: 155a8019-6333-42d4-8cae-56f2b6db08c8
│ 
│   with module.aws-route-table.aws_route_table.app-aws-route-table,
│   on modules/app-aws-route-table/main.tf line 11, in resource "aws_route_table" "app-aws-route-table":
│   11: resource "aws_route_table" "app-aws-route-table" {
```