import { SQSEvent } from "aws-lambda";

export const handler_publisher = async (event: SQSEvent) => {
  const records: any[] = event.Records;
  console.log(records)
  return {
    statusCode: 200,
    body: JSON.stringify("Reading published into twitter succesfully!"),
  };
};
