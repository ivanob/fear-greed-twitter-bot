import { SQS } from 'aws-sdk';

const sqs = new SQS();

const queueUrl = 'https://sqs.eu-west-1.amazonaws.com/065454142634/sqs-publish-fandg-reading';

export const sendMessage = (messageBody: string) => sqs.sendMessage({
    QueueUrl: queueUrl,
    MessageBody: messageBody
}, (err, data) => {
  if (err) {
    console.error('Failed to send message', err);
  } else {
    console.log('Message sent successfully', data.MessageId);
  }
});