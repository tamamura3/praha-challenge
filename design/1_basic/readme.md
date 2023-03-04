# 課題1
## SOLID原則
変更に強いソフトウェアを作るための5つの設計原則の頭文字を取った言葉。
1. Single Responsibility Principle：単一責任の原則
クラスは一つだけの責務を持つべきであるという原則。ここでの責務というのは、そのクラスを利用するアクターに対する責務を意味する。つまり、各クラスはアクターと1対1で紐づいているべきであるということ。

アクターとは、ソフトウェアを利用するユーザーや役割を指す。
システムの変更要求はアクターから生まれるため、クラスが複数アクターに対する責務を負っていると、一つの変更が他のアクターのユースケースにも影響してしまう。

[単一責任の原則（Single responsibility principle）について、もう一度考える](https://www.ogis-ri.co.jp/otc/hiroba/others/OOcolumn/single-responsibility-principle.html)


2. Open/closed principle：オープン/クロースドの原則

ソフトウェアの構成要素（クラス、関数など）は拡張に対して開かれていて（Open）修正に対して閉じて（closed）いなければならないという原則。
つまり、拡張はしやすいが、修正時は既存の成果物を変更する必要がないような設計にするべきということ。

[SOLID原則 ◆オープン・クローズドの原則◆](https://zenn.dev/rafael612/articles/5d68b432d219f8)

3. Liskov substitution principle：リスコフの置換原則

クラスを継承するときに、スーパークラスとサブクラスを入れ替えても動くようにするべきという原則。
is-aの関係が成り立っているからとよく考えずにクラス設計すると、あるサブクラスで矛盾が生まれてしまうことがある。

[TypeScriptでSOLID原則〜リスコフの置換原則〜](https://www.membersedge.co.jp/blog/typescript-solid-liskov-substitution-principle/)

4. Interface segregation principle：インターフェース分離の原則

インターフェースとその利用者がいるとき、利用者にとって必要のないメソッドやプロパティに依存しなくていいようにインターフェースを分割すべきであるという原則。

[TypeScriptでSOLID原則〜インターフェイス分離の原則〜](https://www.membersedge.co.jp/blog/typescript-solid-interface-segregation-principle/)

5. Dependency inversion principle：依存性逆転の原則
あるモジュールが別のモジュールを利用するとき、間に共有された抽象（インターフェースや抽象クラスなど）に依存するべきという原則。

## 単一責任の原則とファイルを分割することの違い
単一責任の原則は設計原則なので、結果的にクラスが増えてファイルが増えるかもしれないが、極端な話ファイルを分割しなくても実現できる。
一方ファイル分割はプログラムが見やすいようにクラスなどの単位でファイルを分けることなので、単一責任の原則とは関係なく実施される。

## Open-Closed-Principleの例
[こちら](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design#open-closed-principle)を参考にした。

円や正方形のような図形の配列を受け取り面積の合計値を出すAreaCaluculatorがあるとする。

```Typescript
class Circle {
    public radius: number = 0;
    constructor(radius: number) {
        this.radius = radius;
    }
}

class Square {
    public length: number = 0;
    constructor(length: number) {
        this.length = length;
    }
}

class AreaCalculator {
    private shapeList: any[];
    constructor(shapeList: any[]) {
        this.shapeList = shapeList;
    }
    public sum(): number {
        let result: number = 0;
        this.shapeList.forEach((shape) => {
            if (shape instanceof Circle) {
                result += Math.pow(shape.radius, 2) * Math.PI;
            } else if (shape instanceof Square) {
                result += Math.pow(shape.length, 2);
            }
        });
        return result;
    }
}

const areaCalculator = new AreaCalculator([new Square(5), new Circle(3)]);
console.log(areaCalculator.sum());
```
上の例だと、例えば長方形も計算できるようにする場合、クラスの追加とAreaCalculatorの修正が必要になる。

これをOpen-Closed-principleに沿うように直すと、次の通り各図形でクラスを作成しAreaCalculatorのif文を無くす方法が考えられる。

これなら長方形を追加する場合はクラスの追加だけで済み、AreaCalculatorは手を加えなくていい。
```typescript
interface ShapeInterface {
    area(): number;
}

class Circle {
    public radius:number = 0;
    constructor(radius: number) {
        this.radius = radius;
    }

    public area(): number {
        return Math.pow(this.radius, 2) * Math.PI;
    }
}

class Square {
    public length: number = 0;
    constructor(length: number) {
        this.length = length;
    }

    public area(): number {
        return Math.pow(this.length, 2)
    }
}

class AreaCalculator {
    private shapeList: any[];
    constructor (shapeList: any[]) {
        this.shapeList = shapeList;
    }
    public sum(): number {
        return this.shapw
        return this.shapeList.reduce((acc, shape) => 
            acc += shape.area(), 0)
    }
}

const areaCalculator = new AreaCalculator([new Square(5), new Circle(3)]);
console.log(areaCalculator.sum());
```

## リスコフの置換原則に違反した場合の不都合は？
原則に違反するということは適切でないサブクラスが存在するということなので、そのサブクラスを利用した処理の中でバグが発生する可能性がある。

## インターフェースを用いることの設計上のメリット
- クラスをインターフェースに依存させることでクラス関係を抽象化でき、変更時の影響範囲が小さくなるような設計にできる
- サブクラスに対して必要な関数の実装を強制できるので、今後作られるサブクラスにも必要な実装がされることが担保できる

## 依存性の逆転を用いる必要があるのはどんなとき？
変更が見込まれるモジュールAに他のモジュールBが依存している場合、モジュールAが変更される度にモジュールBも影響を受けるため、依存性の逆転を使う必要がある。

## デメトルの法則とは
「親クラス.子クラス.子クラスのメソッド」のように、直接のオブジェクトを経由してさらに別のオブジェクトにアクセスするのを避けるべきという法則。

この法則を守ることのメリット。
- 単体テストがしやすくなる
    - ユニットテストでは自分以外のオブジェクトはモックにして常に同じ値を返すようにしてテストするのが一般的なので、関係するオブジェクトが多いとそれだけモックがたくさん必要になる。
- コード変更の影響範囲を小さく保つことができる。
    - 関係するオブジェクトが多いと、それだけあるオブジェクトの変更の影響が及ぶ範囲も大きくなる。デメトルの法則で結合度を低く保つことができる。

[デメテルの法則を厳密に守るにはどうすればいいの？](https://qiita.com/br_branch/items/37cf71dd5865cae21401)

## 新人が書いたコードについて
setter/getterを用意するだけでは結局外部からデータを参照できるのでデメトルの法則に対処できているわけではない。

下記がデメトルの法則を守るのに良いらしい。
- クラス設計を見直してオブジェクトをいくつもまたいで参照しないようにする
- 他オブジェクトに状態を訪ねてその結果で処理するのではなく、他オブジェクトそのものに処理をさせる（Don't tell ask）

# 課題2
## コードの問題点
- 過去の購入履歴を全て取得してからアプリ側で絞り込んでいるので、購入履歴の数によっては性能の問題が発生する

## コードの修正案
ユーザーの平均購入履歴数を考慮して性能要件を満たせる場合は、今のままで問題なさそう。

性能要件を満たせない場合は、アプリではなくSQLで商品の絞り込みを行う修正が考えられる。

各仕様変更があった場合の対応どうするか
- 「1年以内→2年以内」・・アプリまたはSQLで絞り込む際の日付部分を変更して対応。
- 「プレミアム会員の場合は何個でも購入可能」・・アプリでこの判定処理自体を通らないよう修正して対応。
- 例えば「プレミアム会員3カ月以内、それ以外は1年以内」という変更が仮にあった場合は、SQLで対応するならwhere句をバインドできる仕組みが必要。

# 課題3
## コードの問題点
- フィールドがpublicなので、意図せず誤った値に更新してしまう恐れがある

## 解決法
- readonlyを付けるか、privateにしてgetterを書く

# 任意課題
[このスライド](https://fortee.jp/object-oriented-conference-2020/proposal/a826b6c6-167c-4c5c-bfc7-52bb8bc22ec1)がコードの例もありきれいにまとまっていた。

凝集度については、偶発的凝集は通常起こりえないので除き、論理的凝集～逐次的凝集の間の状態に関して、ケースバイケースだが気を付けるべきポイントがあると述べられている。
必ずしも一番理想的な機能的凝集になるべきというわけではないし、そもそもできないこともある。

結合度については、内部結合は起こりえないとして、共通結合と外部結合は避けるべき、制御結合は極力避けるべきだと書かれている。
こちらはなるべく理想形であるスタンプ結合、データ結合、メッセージ結合に近づけた方が良いとのこと。

## 凝集度（cohesion）
単体のモジュールの中の要素（データ、関数）がどれだけ関連しているかを示す。
凝集度が高い・・全てのデータ、関数が一つの機能に関連している
凝集度が低い・・データ、関数がそれぞれ複数の機能に関連している
凝集度は高い方が良いシステムを作ることができる。

- 偶発的凝集
何を根拠にモジュールになっているか説明できないようなモジュール。
- 論理的凝集
関連したいくつかの機能を持っていて、呼び出しモジュールによって選択され実行するモジュール。
例：イベントによる処理の振り分け、フラグによる処理の振り分け
- 時間的凝集
関連の少ないいくつかの機能を逐次的（特定のタイミング）に実行するモジュール。
実行順に意味はない。
例：初期化処理、終了処理
- 手続き的凝集
仕様によって定められた関連の少ない機能を逐次的に実行するモジュール。
実行順に意味がある。
例：ファイル存在チェック→開いて読み込み→閉じるのような一連の処理
- 通信的凝集
複数の処理がありそれぞれ同じ値をインプットにするモジュール。
- 逐次的凝集
一つの関数のアウトプットが他の関数のアウトプットになるモジュール。
- 機能的凝集
一つの固有の機能を実行するモジュール。

[設計におけるオブジェクトの責務分配に有効なものさし -凝集度と結合度-](https://www.ogis-ri.co.jp/otc/hiroba/technical/Cohesion_Coupling/Cohesion_Coupling.html)


## 結合度（Coupleing）
モジュール同士がどれだけ依存しているかを示す。
結合度が高い・・モジュール同士が密接に関係しているため、一つの変更が他のモジュールに大きく影響する状態
結合度が低い・・モジュール同士が独立していて、一つの変更が他のモジュールにあまり影響しない状態
結合度が低い方がメンテナンスしやすいシステムを作ることができる。

結合度には種類があり、結合度が低い順に並べると次の通り。
- メッセージ結合
引数なしで呼び出すパターン。
- データ結合
引数で構造化されていないデータ（string, intなど）を渡すパターン。
- スタンプ結合
引数で構造化されたデータ（オブジェクト、構造体など）を渡すパターン。
- 制御結合
引数の種類によって処理の内容が変わるパターン。
- 外部結合
モジュールがシステムの外部に依存しているパターン。
構造を持たないデータを複数モジュールで共有すること、とも書いてある。
- 共通結合
グローバル領域のデータを複数モジュールで共有しているパターン。
- 内部結合
他のオブジェクトの内部の直接操作するパターン。

# 単一責任の法則の感想
定義が曖昧で結局よく分からなかった(-_-；)
せっかくなので調べたことを自分の理解と共にメモ。

単一責任の法則とは？
> The single-responsibility principle (SRP) is a computer programming principle that states that "A module should be responsible to one, and only one, actor."[1] The term actor refers to a group (consisting of one or more stakeholders or users) that requires a change in the module.
Wikipediaより

つまり、一つのモジュールは一つのアクターに対する責務だけを持つと良いということ。
アクターとは、ユーザーや役割を意味する。

[プログラマが知るべき97のこと](https://xn--97-273ae6a4irb6e2hsoiozc2g4b8082p.com/%E3%82%A8%E3%83%83%E3%82%BB%E3%82%A4/%E5%8D%98%E4%B8%80%E8%B2%AC%E4%BB%BB%E5%8E%9F%E5%89%87/)で紹介されている例を見てみる。
```
public class Employee {
	public Money calculatePay() ...
	public String reportHours() ...
	public void save() ...
}
```
このクラスは単一責任の法則に反していて、理由は次の通り3つの異なるアクターに対する責務を負ってしまっているからと考えられる。
- calculatePay（給与計算をする）のアクターは、会計または経理
- reportHours（勤務時間報告）のアクターは、人事など
- save（計算結果を保存）のアクターは、DBAやDB関連の決め事をするエンジニア

そのため記事の中では、それぞれ別のクラスに分ける方法が紹介されている。
```
public class Employee {
	public Money calculatePay() ...
}
public class EmployReporter {
	public String reportHours(Employee e) ...
}
public class EmployeeRepository {
	public void save(Employee e) ...
}
```

こうすることで1アクターの変更が他のアクターの処理に影響することを防げる。これが単一責任のメリット。
システムの変更要求はアクターから生まれるので、一つのモジュールに紐づくアクターを限定することで、影響範囲を小さくすることができる。

まず思ったのは、アクターという言葉がかなり曖昧な印象。
極端な話、社員一人だけの会社でこのシステムをその人だけが使っていたらアクターは一人？と思ってしまいそう。実際の利用する人ではなく、あくまでも役割としてアクターを考えることが必要そう。

また、対象がモジュールかクラスか関数なのかでも話が変わってくると思った。
関数なら一つのアクターだけに紐づけることができそうだが、モジュールやクラスなら難しい場合もあるかと思う。
例えば共通のユーティリティークラスがあれば、複数のアクターの処理で利用されるので原則に当てはめることは難しそう。
これには、[この記事](https://www.ogis-ri.co.jp/otc/hiroba/others/OOcolumn/single-responsibility-principle.html)によると「共通ユーザーというアクターがいる」と考えることもできるとのこと。

他に思ったのは、原則に沿ってアクターが一つなら常に良いシステムが作れるのかというとそうではない。
例えば経理の仕事は他にも無数にあるので、それらの処理を全て一つのクラスに入れたら神クラスが出来上がってしまう。
そうすると変更があった場合、アクター間での影響はないが、ユースケース間で変更が影響してしまう。

自分は単一責任の法則と聞いたとき、最初は「処理」の話を思い浮かべた。
ただ実際は恐らくアクターに対する責務のことであり、処理に対する責務だと考えてしまうと定義が曖昧で理解ができなそう。
例えば先のEmployeeの例だと、
- 従業員の処理に関する責務だけを負っているからOK
- 従業員の給与計算、勤務時間報告、計算結果保存それぞれの処理に責務を負っているのでNG

のように、「処理」の粒度により解釈が変わってくる気がする。
関数であれば処理を一つにできるかもしれないけど、モジュールやクラスでそれをやろうとすると、一つの処理しかない大量のモジュールやクラスが生まれてしまう。
あくまでアクターに関する責務だという前提が大切そう。

結論：とりあえずアクターが混在しないように、と気を付ければ良さそう。
※ただしアクターを考えるのがムズイ

ちなみに単一責任の原理にはもう一つ、定義があるらしい。

> Robert C. Martin, the originator of the term, expresses the principle as, "A class should have only one reason to change".[2] Because of confusion around the word "reason" he has also clarified saying that the "principle is about people."[3] In some of his talks, he also argues that the principle is, in particular, about roles or actors.
Wikipediaより

つまり、クラスが変更される理由は一つだけとのこと。
変更される理由というのは、先ほどのEmployeeクラスの例で言うと次のようなものが考えられる。

- 会計部門が給与計算のルールを変更したい
- 人事が勤務時間報告のルールを変更したい
- DBAが従業員のデータが格納されているDBのスキーマを変更したい

これもWikipediaにも書いてあるようにアクターの話であることを考えないと理解が難しそう。
例えば原則に沿って勤務時間報告のクラスに分けて次のような関連処理が含まれる場合、
```
public class EmployReporter {
	public String reportHours(Employee e) ...
    // 勤務時間報告に必要な計算処理
	private String calculateHours(int hours) ...
    // 勤務時間報告に必要な報告先取得処理
	private String getReportToAddress(Employee e) ...
}
```
もし変更される理由を「処理」に関することだとして考えると、
- 計算処理（calculateHours）を変更したい
- 報告先取得処理（getReportHours）を変更したい

のように二つの変更される理由があるのでNG！と考えることができる。
しかし実際は報告に関連する処理をまとめているだけなので、同じクラスに存在して良いと思う。

単一原則の法則って分かりにくいよねという記事もあったので参考まで。  
[SRP is a Hoax](https://www.yegor256.com/2017/12/19/srp-is-hoax.html)  
[I don't love the single responsibility principle](https://sklivvz.com/posts/i-dont-love-the-single-responsibility-principle)
