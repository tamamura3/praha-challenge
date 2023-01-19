# 課題2
テストファイル
https://github.com/tamamura3/praha-challenge-templates/blob/master/jestSample/__tests__/functions.test.ts

### ビルドエラーになる場合について
ビルド時にエラーになるケースは、ビルド時にエラー検知できるためテスト不要だと思う。

# 課題3
## 元の関数がカバレッジ100%のテストを書けなかった理由
関数の中で別のオブジェクトに依存しているため。
Databaseオブジェクトのsaveメソッドは外部と通信する処理のため、常に成功するとは限らない。
そのため関数自体の結果を事前に決定できないため、カバレッジ100%のテストが書けなかった。

## 依存性の注入とはなにか？どのような問題を解決するか
依存性の注入は、あるオブジェクトや関数が、依存する別のオブジェクトや関数を受け取るデザインパターンのこと。
依存している部分を外部から渡す（注入）ことで、対象オブジェクトや関数の依存性をなくし、疎結合なプログラムを作ることができる。

参考：モック化の基礎
https://medium.com/@rickhanlonii/understanding-jest-mocks-f0046c68e53c

今回のような外部依存している関数でカバレッジ100%のテストをするには、以下3つの方法があるように思う。

1. 依存性の注入を利用
依存しているクラスを模したクラスを作成。
テスト対象関数の引数を増やし、作成したクラスを受け取るようにする。

```TypeScript
describe('asyncSumOfArraySometimesZero', () => {
    test('配列の要素の合計値がDBに登録後、返却される', async (): Promise<void> => {
        const databaseValid: Database = new DatabaseValid();
        expect(await asyncSumOfArraySometimesZero([1, 1], databaseValid)).toBe(2);
    });
    test('DBの登録に失敗すると0を返却する', async (): Promise<void> => {
        const databaseError: Database = new DatabaseError();
        expect(await asyncSumOfArraySometimesZero([1, 1], databaseError)).toBe(0);
    });
});
```
参考：依存性の注入について
https://www.w2solution.co.jp/tech/2021/10/06/eg_ns_rs_izonseinotyunyu/#:~:text=%E4%BE%9D%E5%AD%98%E6%80%A7%E3%81%AE%E6%B3%A8%E5%85%A5%E3%81%A8%E3%81%84%E3%81%86,%E8%A7%A3%E6%B1%BA%E3%81%99%E3%82%8B%E3%80%8D%E3%81%A8%E3%81%84%E3%81%86%E3%81%93%E3%81%A8%E3%81%A7%E3%81%99%E3%80%82

2. Mockを利用
依存しているクラスの関数をモック化し、対象の関数の処理を上書きする。
```Typescript
describe('asyncSumOfArraySometimesZero', () => {
    test('配列の要素の合計値がDBに登録後、返却される', async (): Promise<void> => {
        const databaseMock = jest.spyOn(DatabaseMock.prototype, 'save').mockReturnValue();
        expect(await asyncSumOfArraySometimesZero([1, 1])).toBe(2);
        databaseMock.mockRestore();
    });
    test('DBの登録に失敗すると0を返却する', async (): Promise<void> => {
        const databaseMock = jest.spyOn(DatabaseMock.prototype, 'save').mockImplementation(() => { throw new Error() });
        expect(await asyncSumOfArraySometimesZero([1, 1])).toBe(0);
        databaseMock.mockRestore();
    });
});
```
モック化には、他にもクラスごとモック化したり、関数をモック化する方法もある。
今回の場合クラスの一部（save関数）だけをモック化すればいいので、上記を使用。

参考：モック化の種類について
https://qiita.com/yuma-ito-bd/items/38c929eb5cccf7ce501e

3. 依存性の注入とMock
依存しているクラスをモック化し、対象の関数を上書きする。テスト対象関数の引数を増やし、作成したモックを受け取るようにする。



## 依存性の注入を実施することで結合度の強さはどのように変化するか
疎結合になるので、結合度は低くなる。

## 単体テストで外部サービスとの通信が発生するデメリット
単体テストで外部サービスと通信が発生すると、テスト結果が外部サービスの実行結果に依存するため、カバレッジ100%のテストが書けなくなる。
外部サービスを動かしてプログラム全体をテストするのは統合テストのような後ろのフェーズでよいと考える。

## sumOfArrayの修正
空の配列の場合は0を返すように修正。
https://github.com/tamamura3/praha-challenge-templates/blob/09a4a7756a30a2364109619cc873b2fa10129388/jestSample/functions.ts#L5-L7

## Property Based testingとは何か？使わない方が良いケースはあるか？
Property Based Testingは専用のツールを使用してより網羅的にテストをする仕組み。
例えば「一つの自然数」という性質（property）を定義すれば、その性質に当てはまるありとあらゆる入力値が自動的に作成される。（1、33、738470107など）
その入力値をテスト対象の関数に渡してテストすれば、人力では取りこぼしやすいエッジケースなどを含めより手厚いテストができる。

Property Based Testingを使わない方が良いケースがあるとすれば、一回の実行に時間がかかる処理。
自動で何度もテストされるため、完了までに時間がかかる懸念がある。

## Example Based Testingとは何か
Property Based Testingのとは反対で、数ある入力値から人が選出してテストする方法。

## 単体テストでの工夫
- Arrenge-Act-Assert
テストコードを3段階に分けてコメントして管理することで、どこで何をしているか、何のテストをしているかを理解しやすくする方法。Arrengeでは入力値や初期化など、テストに必要なデータを準備する。Actでは、関数やAPIなどテスト対象の実行を行う。Assertでは結果を判定する。
- 一つのユニットテストに複数assertを書かない
一つのユニットテストで複数のassertを実行すると、エラー時にそれ以降のテストが実行されないので注意。
- テスト内にロジックを書かない
テストの中にロジックを書くと、そのロジックにバグが生まれる可能性があるので、極力避ける。
if, for, whileなどを使うようであれば注意し、必要であれば複数のテストケースに分ける。
参考：https://www.simform.com/blog/unit-testing-best-practices/

# 課題4
## テストを書いてみよう（関数3つ）
[functions.ts](https://github.com/tamamura3/praha-challenge/blob/main/test/1_test_jest/functions.ts)、[addressApiService.ts](https://github.com/tamamura3/praha-challenge/blob/main/test/1_test_jest/addressApiService.ts)を参照。

## jestに関するクイズ
1. オブジェクトの等価を判定するmatcharのtoBeとtoEqualの違いは？
2. expect()がない場合のテスト結果はどうなる？
3. 実行結果のFile, Stmts, Branch, Funcs, Lines, Uncoverd Lineはそれぞれ何を意味してる？

# 課題5
- テストの名前には「～されるかどうか」のようなテスト観点を書くとわかりやすいと感じた。
例：「[]の配列を引数に渡した場合」×
　　「空配列の場合0が返却されるかどうか」〇
- テスト実行前にbeforeEachなどでスナップショットを取り、完了後afterEachでスナップショットを戻せば常に同じ状態で各テストを実行できる

参考：https://github.com/PostHog/posthog
https://github.com/n8n-io/n8n
