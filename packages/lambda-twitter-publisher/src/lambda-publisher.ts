import { APIGatewayEvent } from "aws-lambda";

export const handler_publisher = async (event: APIGatewayEvent) => {
  return {
    statusCode: 200,
    body: JSON.stringify("Reading published into twitter succesfully!"),
  };
};
