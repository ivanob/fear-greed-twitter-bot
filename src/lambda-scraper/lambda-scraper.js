exports.handler = async (event) => {
    console.log('Hello, world!');
    return {
      statusCode: 200,
      body: JSON.stringify('Hello, world!')
    };
  };