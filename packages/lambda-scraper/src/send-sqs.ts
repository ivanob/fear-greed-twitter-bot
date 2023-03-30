import { FAndG } from "@fear-greed-bot/common";
import { SQS } from "aws-sdk";

const sqs = new SQS();

const queueUrl =
  "https://sqs.eu-west-1.amazonaws.com/065454142634/sqs-publish-fandg-reading";

export const sendMessage = async (messageBody: FAndG) => {
  try {
    const data = await sqs
      .sendMessage({
        QueueUrl: queueUrl,
        MessageBody: JSON.stringify(messageBody),
      })
      .promise();
    console.log("Message sent successfully", data.MessageId);
  } catch (error) {
    console.error("Failed to send message", error);
  }
};
