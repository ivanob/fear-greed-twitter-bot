### List of goals to learn
- [X] Terraform: create a couple of lambdas and a SQS queue in between them, also a DynamoDB table to store some data.
- [X] Twitter API: basic usage of the API
- [X] Typescript must be set in the most strict level in `.tsconfig`
- [X] Compile TS project and bundle it to deploy as JS lambda [1]
- [X] Find a good graphical diagram tool

### Description
The idea is to tweet periodically some information about the Fear&Greed index [1]. To do this a lambda will check every X hours the external resource, scrap the status about this index and send it to a SQS queue and also store it into a DynamoDB table.
A second lambda will be reading from that queue and once any message arrives with a new reading it will pusblish it in a tweet.

<b>[1]</b> https://edition.cnn.com/markets/fear-and-greed


[1] After trying different solutions for sending the TS project to lambda once its transpiled into JS I came into the conclusion that the best tool is esBundle.js (https://esbuild.github.io/)
I tried webpack but it is a much complex configuration and the uglification of the code changes the structure of the code too much, so lambda can not find the name of the lambda. I didnt
want to use SLS or AWS SAM for this cause I want to do it all from terraform. Also esBundle transpiles all TS into one single JS that I did not uglified, so its readable. A much more efficient
way of bundling would be the following, but code is less readable and for debugging purposes I wanted to keep it easy.
```"build": "esbuild index.ts --bundle --minify --sourcemap --platform=node --target=es2020 --outfile=dist/index.js",```


#### Bibliography: 

https://www.middlewareinventory.com/blog/aws-lambda-terraform/
https://dev.to/aws-builders/how-to-schedule-the-execution-of-your-lambda-code-2fl3#:~:text=The%20execution%20of%20a%20Lambda,a%20source%20to%20a%20destination.
