import { AddressApiService } from "./addressApiService";

// 課題4

export const averageOfArray = (numbers: number[]): number => {
  return numbers.reduce((a: number, b: number): number =>
    a + b, 0) / numbers.length;
};

export const asyncAverageOfArray = async (numbers: number[]): Promise<number> => {
  return new Promise((resolve) => {
    resolve(averageOfArray(numbers));
  })
};

export const getPrefectureThrowIfNull = async (zipcode: number): Promise<string> => {
  const addressApiService = new AddressApiService();
  const prefecture = await addressApiService.getPrefecture(zipcode);
  if (!prefecture) {
    throw new Error("No Prefecture found");
  }
  return prefecture;
}