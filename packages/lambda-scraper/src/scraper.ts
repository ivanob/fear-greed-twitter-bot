import axios from "axios";
import {FAndG} from "@fear-greed-bot/common"

const CNN_Url =
  "https://production.dataviz.cnn.io/index/fearandgreed/graphdata";


const scrapeFearAndGreedIndex = async (): Promise<FAndG|undefined> => {
  try {
    const resp = await axios.get(CNN_Url, {
      headers: {
        "user-agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
      },
    });
    const data = resp.data.fear_and_greed
    return {
      score: data.score,
      rating: data.rating,
      timestamp: data.timestamp
    };
  } catch (error) {
    console.error(error);
    throw new Error("Could not scrape the index")
  }
};

export default scrapeFearAndGreedIndex;
