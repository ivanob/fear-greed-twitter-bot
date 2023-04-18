import { SQSEvent } from "aws-lambda";
import { FAndG } from "@fear-greed-bot/common";

export const handler_publisher = async (event: SQSEvent) => {
  const records: any[] = event.Records;
  const reading: FAndG = JSON.parse(records[0].body)
  console.log(reading)
  return {
    statusCode: 200,
    body: JSON.stringify("Reading published into twitter succesfully!"),
  };
};
