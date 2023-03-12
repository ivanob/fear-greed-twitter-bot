import {APIGatewayEvent} from 'aws-lambda'

const handler = async (event: APIGatewayEvent) => {
  console.log("Hello, world!");
  
  return {
    statusCode: 200,
    body: JSON.stringify("Hello, world!"),
  };
};

export default handler;