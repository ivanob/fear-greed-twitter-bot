import { FAndG } from "@fear-greed-bot/common";
import { SQS } from "aws-sdk";

const sqs = new SQS();

const queueUrl =
  `https://sqs.${process.env.AWS_REGION}.amazonaws.com/${process.env.AWS_ACCOUNT_ID}/sqs-publish-fandg-reading`;

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
