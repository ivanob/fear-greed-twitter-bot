import { APIGatewayEvent } from "aws-lambda";


export const handler = async (event: APIGatewayEvent) => {
  console.log("ENTRA")
  return {
    statusCode: 200,
    body: JSON.stringify("Read of F&G index completed succesfully"),
  };
};