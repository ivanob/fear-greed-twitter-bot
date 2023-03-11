### List of goals to learn
- [X] Terraform: create a couple of lambdas and a SQS queue in between them, also a DynamoDB table to store some data.
- [X] Twitter API: basic usage of the API
- [X] Typescript must be set in the most strict level in `.tsconfig`

### Description
The idea is to tweet periodically some information about the Fear&Greed index [1]. To do this a lambda will check every X hours the external resource, scrap the status about this index and send it to a SQS queue and also store it into a DynamoDB table.
A second lambda will be reading from that queue and once any message arrives with a new reading it will pusblish it in a tweet.

<b>[1]</b> https://edition.cnn.com/markets/fear-and-greed


#### Bibliography: 

https://www.middlewareinventory.com/blog/aws-lambda-terraform/
