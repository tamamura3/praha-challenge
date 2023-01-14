// 配列の平均
export const averageOfArray = (numbers: number[]): number => {
  return numbers.reduce((a: number, b: number): number =>
    a + b, 0) / numbers.length;
};

// 配列の平均（非同期）
export const AsyncAverageOfArray = async (numbers: number[]): Promise<number> => {
  return new Promise((resolve) => {
    resolve(averageOfArray(numbers));
  })
};

import { AddressApiService } from "./addressApiService";

// 郵便番号から住所を取得する。もしnullならエラー
export const getPrefecture = async (zipcode: number): Promise<string> => {
  const addressApiService = new AddressApiService();
  const prefecture = await addressApiService.getPrefecture(zipcode);
  if (!prefecture) {
    throw new Error("No Prefecture found");
  }
  return prefecture;
}