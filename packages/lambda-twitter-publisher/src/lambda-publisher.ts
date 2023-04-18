import { SQSEvent } from "aws-lambda";
import { FAndG } from "@fear-greed-bot/common";
import TwitterApi, { ApiResponseError, TwitterApiTokens } from 'twitter-api-v2'

export const handler_publisher = async (event: SQSEvent) => {
  const records: any[] = event.Records;
  const reading: FAndG = JSON.parse(records[0].body)
  console.log(reading)
  const client = new TwitterApi(
    {
    appKey: process.env.TWITTER_APP_KEY,
    appSecret: process.env.TWITTER_APP_SECRET,
    accessToken: process.env.TWITTER_ACCESS_TOKEN,
    accessSecret: process.env.TWITTER_ACCESS_SECRET
    } as TwitterApiTokens
  )
  try{
    await client.v2.tweet(`Score: ${reading.score}, rating: ${reading.rating}`)
  }catch(error: unknown){
    if(error instanceof ApiResponseError){
      return {
        statusCode: error.data,
        body: JSON.stringify(error.data.detail)
      }
    }
  }
  return {
    statusCode: 200,
    body: JSON.stringify("Reading published into twitter succesfully!"),
  };
};
