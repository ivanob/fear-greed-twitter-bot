import { APIGatewayEvent } from "aws-lambda";
import scrapeFearAndGreedIndex from "./scraper";
import { v4 as uuidv4 } from "uuid";
import AWS from "aws-sdk";
import { sendMessage } from "./send-sqs";
import { FAndG } from "@fear-greed-bot/common";

const dynamodb = new AWS.DynamoDB.DocumentClient();

const addMetadataToReading = (reading: FAndG): FAndG => {
  return {
    ...reading,
    id: uuidv4(),
    timestamp: Date.now()
  }
}
 
export const handler_scraper = async (event: APIGatewayEvent) => {
  try {
    const reading: FAndG | undefined = await scrapeFearAndGreedIndex();
    if(reading){
      const readingComplete = addMetadataToReading(reading);
      const promise1 = sendMessage(readingComplete)
      const promise2 = storeReadingInDB(readingComplete);
      await Promise.all([promise1, promise2])
    }
  } catch {
    return {
      statusCode: 400,
      body: JSON.stringify("Error writing item to DynamoDB"),
    };
  }
  return {
    statusCode: 200,
    body: JSON.stringify("Read of F&G index completed succesfully"),
  };
};

const storeReadingInDB = async (reading: FAndG) => {
  const params = {
    TableName: "fear-greed-readings",
    Item: {
      ...reading
    },
  };
  return dynamodb.put(params).promise();
};