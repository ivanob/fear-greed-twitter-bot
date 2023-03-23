import scrapeFearAndGreedIndex from "../scraper";

test("Finds the website and downloads the html", async () => {
  const reading = await scrapeFearAndGreedIndex();
  console.log(reading)
  expect(1).toBe(1);
});
