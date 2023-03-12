import { APIGatewayEvent } from "aws-lambda";
import scrapeFearAndGreedIndex, { FAndG } from "./scraper";
import { v4 as uuidv4 } from "uuid";
import AWS from "aws-sdk";

const dynamodb = new AWS.DynamoDB.DocumentClient();

const handler = async (event: APIGatewayEvent) => {
  const reading: FAndG = scrapeFearAndGreedIndex();
  try {
    await storeReadingInDB(reading);
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
      id: uuidv4(),
      timestamp: Date.now(),
      index: reading.index,
    },
  };
  return dynamodb.put(params).promise();
};

export default handler;