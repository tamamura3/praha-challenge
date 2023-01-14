import axios from "axios";

export class AddressApiService {
    public constructor() {};
    public async getPrefecture(zipcode: number): Promise<string> {
        const url = `https://zipcloud.ibsnet.co.jp/api/search?zipcode=${zipcode}`;
        const { data } = await axios.get(url);
        const prefecture = data.results.address1 as string;
        return prefecture;
    }
}