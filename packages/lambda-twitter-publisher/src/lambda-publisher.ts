import { SQSEvent } from "aws-lambda";
import { FAndG } from "@fear-greed-bot/common";
import Twitter from 'twitter-api-v2'

export const TWITTER_API_KEY = 'YOUR_API_KEY';
export const TWITTER_API_SECRET_KEY = 'YOUR_API_SECRET_KEY';
export const TWITTER_ACCESS_TOKEN = 'YOUR_ACCESS_TOKEN';
export const TWITTER_ACCESS_TOKEN_SECRET = 'YOUR_ACCESS_TOKEN_SECRET';

export const handler_publisher = async (event: SQSEvent) => {
  const records: any[] = event.Records;
  const reading: FAndG = JSON.parse(records[0].body)
  console.log(reading)
  const client = new Twitter({
    appKey,
    appSecret,
    accessToken,
    accessSecret
  })
  client.v2.tweet('')
  return {
    statusCode: 200,
    body: JSON.stringify("Reading published into twitter succesfully!"),
  };
};
